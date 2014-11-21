//
//  GirlsPhotoViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-11-21.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "GirlsPhotoListViewController.h"

@interface GirlsPhotoListViewController ()

@end

@implementation GirlsPhotoListViewController{
    NSDictionary *params;
    NSString *navTitle;
    NSString *catid;
    
    int page_index;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarController.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    page_index = 1;
    [self loadGirlData:@"1"];
    
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:navTitle hasLeftItem:NO hasRightItem:YES leftIcon:nil rightIcon:nil]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    InitTabBarViewController *tabBarController = (InitTabBarViewController *)self.tabBarController;
    [tabBarController showDIYTaBar];
    
}

-(void)passValue:(NSString *)val{
    //
}

-(void)passDicValue:(NSDictionary *)vals{
    params = vals;
    if(params!=nil){
        navTitle = [params valueForKey:@"_title"];
    }else{
        navTitle = @"美女相册";
    }
    
    catid = [params valueForKey:@"_id"];
}

-(void)loadGirlData:(NSString *)pageIndex{
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@/%@/%@/%@",REMOTE_URL,GIRLS_SCLIST,catid,@"0",PAGESIZE,pageIndex];
    [self requestDataByUrl:url];
    
}

/*加载数据*/
-(void)requestDataByUrl:(NSString *)url{
    
    [HttpClient GET:url
         parameters:nil
             isjson:TRUE
            success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         _girlsPhotoList = (NSMutableArray *)responseObject;
         
         //刷新数据
         [self.girlsPhotoTableView reloadData];
         
     }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [self requestFailed:error];
         
     }];
    
    
}

- (void)requestFailed:(NSError *)error
{
    [self hideHud];
    NSLog(@"error=%@",error);
    [self showNo:ERROR_INNER];
}


//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _girlsPhotoList.count;
}


//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary * dicData = [_girlsPhotoList objectAtIndex:indexPath.row];
    static NSString * CellIdentifier = @"girlsPhotoCell";
    UINib *nibCell = [UINib nibWithNibName:@"GirlsPhotoCollectionCell" bundle:nil];
    [collectionView registerNib:nibCell forCellWithReuseIdentifier:CellIdentifier];
    
    GirlsPhotoCollectionCell * girlsCell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    girlsCell.backgroundColor = [UIColor clearColor];
    
    [girlsCell.photoImageView md_setImageWithURL:[dicData valueForKey:@"_img_url"] placeholderImage:NO_IMG options:SDWebImageRefreshCached];
    [girlsCell.photoTitle setText:[dicData valueForKey:@"_title"]];
    
    return girlsCell;
}


#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90, 120);
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
    
    
}


//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
