//
//  GirlsInfoViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-11-21.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "GirlsInfoViewController.h"

@interface GirlsInfoViewController ()

@end

@implementation GirlsInfoViewController{

    NSDictionary *bannberData;

    CommonViewController *comViewController;
    XHFriendlyLoadingView *friendlyLoadingView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationController.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initLoading];
    [self initBannerData];
    [self loadGirlData];
    [self.girlsCollectionView setBackgroundColor:[StringUitl colorWithHexString:CONTENT_BACK_COLOR]];

}


-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"美女私房" hasLeftItem:NO hasRightItem:YES leftIcon:nil rightIcon:nil]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    InitTabBarViewController *tabBarController = (InitTabBarViewController *)self.tabBarController;
    [tabBarController showDIYTaBar];
    
    [self reloadTBData];
    [self.girlsCollectionView reloadData];
    
}

-(void)UesrClicked:(UIImageView *)imgView{
    
    
}

-(void)initLoading{
    if(friendlyLoadingView==nil){
        friendlyLoadingView = [[XHFriendlyLoadingView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, MAIN_FRAME_H)];
    }
    __weak typeof(self) weakSelf = self;
    friendlyLoadingView.reloadButtonClickedCompleted = ^(UIButton *sender) {
        [weakSelf reloadTBData];
    };
    
    [self.view addSubview:friendlyLoadingView];
    
    [friendlyLoadingView showFriendlyLoadingViewWithText:@"正在加载..." loadingAnimated:YES];
}

- (void)showLoading {
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        
        [friendlyLoadingView showReloadViewWithText:@"请点击刷新.."];
        
    });
}

-(void)reloadTBData{
    [self initBannerData];
    [self loadGirlData];
}

//初始化头部数据
-(void)initBannerData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",REMOTE_URL,PHOTO_BANNER_URL];
    [self requestDataByUrl:url type:0];
    
}

-(void)loadGirlData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@/34",REMOTE_URL,GIRLS_CLIST];
    [self requestDataByUrl:url type:1];
    
}

/*加载数据*/
-(void)requestDataByUrl:(NSString *)url type:(int)type{
    
    [HttpClient GET:url
         parameters:nil
             isjson:TRUE
            success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (type==0) {//头部数据
             
             bannberData = (NSDictionary *)responseObject;
             
         }else{
             _girlsDataList = (NSMutableArray *)responseObject;
             
         }
         
         //刷新数据
         [self.girlsCollectionView reloadData];
         [friendlyLoadingView removeFromSuperview];
         
     }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [self requestFailed:error];
         [friendlyLoadingView removeFromSuperview];
         
     }];
    
    
}

- (void)requestFailed:(NSError *)error
{
    NSLog(@"error=%@",error);
    [self showNo:ERROR_INNER];
}


//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _girlsDataList.count;
}


//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary * dicData = [_girlsDataList objectAtIndex:indexPath.row];
    static NSString * CellIdentifier = @"girlsCell";
    UINib *nibCell = [UINib nibWithNibName:@"GirlsCollectionCell" bundle:nil];
    [collectionView registerNib:nibCell forCellWithReuseIdentifier:CellIdentifier];
    
    GirlsCollectionCell * girlsCell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    girlsCell.backgroundColor = [UIColor clearColor];
    
    [girlsCell.girlsImageView md_setImageWithURL:[dicData valueForKey:@"_img_url"] placeholderImage:NO_IMG options:SDWebImageRefreshCached];
    [girlsCell.girlsTitle setText:[dicData valueForKey:@"_title"]];
    
    [StringUitl setCornerRadius:girlsCell.girlsImageView withRadius:30.0f];
    [StringUitl setViewBorder:girlsCell.girlsImageView withColor:@"#cccccc" Width:1.0f];

    return girlsCell;
}


#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 90);
}


//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5,5,5,5);
}


#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    GirlsPhotoListViewController *girlsPhotoView = (GirlsPhotoListViewController *)[self getStoryBoard:@"GirlsPhotoView"];
    passValelegate = girlsPhotoView;
    [passValelegate passDicValue:[_girlsDataList objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:girlsPhotoView animated:YES];
    
}


//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        
        GirlsCollectionHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView" forIndexPath:indexPath];
        
        headerView.bannerTitler.text =[bannberData valueForKey:@"_title"];
        [headerView.bannerImageView md_setImageWithURL:[bannberData valueForKey:@"_img_url"] placeholderImage:NO_IMG options:SDWebImageRefreshCached];
        reusableview = headerView;
        
    }
    
    return reusableview;
}

@end
