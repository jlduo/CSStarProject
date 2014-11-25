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
    
    //处理相册变量
    NSString * artId;
    NSMutableArray *imageArr;
    NSMutableArray *titleArr;
    NSMutableArray *thumb_ImageArr;
    NSMutableDictionary *totalData;
    MWPhoto *photo;

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
    
    //[self reloadTBData];
    //[self.girlsCollectionView reloadData];
    
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
             bannberData = ((NSArray *)responseObject)[0];
             
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
         
     }];
    
    
}

- (void)requestFailed:(NSError *)error
{
    NSLog(@"error=%@",error);
    [self initLoading];
    [self showLoading];
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
    if (![StringUitl checkLogin]) {
        
        LoginViewController *login = (LoginViewController *)[self getVCFromSB:@"userLogin"];
        [self.navigationController pushViewController:login animated:YES];
        
    }else{
    
        GirlsPhotoListViewController *girlsPhotoView = (GirlsPhotoListViewController *)[self getVCFromSB:@"girlsPhoto"];
        passValelegate = girlsPhotoView;
        [passValelegate passDicValue:[_girlsDataList objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:girlsPhotoView animated:YES];
        
    }
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
        //添加手势
        [headerView.bannerImageView setMultipleTouchEnabled:YES];
        [headerView.bannerImageView setUserInteractionEnabled:YES];
        [headerView.bannerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        
        reusableview = headerView;
        
    }
    
    return reusableview;
}

- (void)tapImage:(UITapGestureRecognizer *)tap{
    
    if (![StringUitl checkLogin]) {
        
        LoginViewController *login = (LoginViewController *)[self getVCFromSB:@"userLogin"];
        [self.navigationController pushViewController:login animated:YES];
        
    }else{
    
        NSString *dataId = [[bannberData valueForKey:@"_id"] stringValue];
        NSString *data_Type = [bannberData valueForKey:@"_category_call_index"];
        artId = dataId;
        if([self isNotEmpty:dataId]){

            if([data_Type isEqual:@"video"]){//视频
                
                if([StringUitl checkLogin]){
                    [self goVideoView:dataId];
                }
                
            }
            
            if([data_Type isEqual:@"albums"]){//相册
                
                if([StringUitl checkLogin]){
                    [self loadGirlPics:dataId];
                    [self goPhotoView:dataId];
                }
                
            }
            
            
            if([data_Type isEqual:@"article"]||[data_Type isEqual:@"slide"]||[data_Type isEqual:@"city"]){//文章
                
                if([StringUitl checkLogin]){
                    [self goArticelView:dataId];
                }
                
            }
        }
        
    }
    
}

//处理相册信息
-(void)loadGirlPics:(NSString *)articleId{
    
    totalData = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *perData = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_PHOTO_LIST,articleId];
    NSMutableArray *jsonArr = (NSMutableArray *)[ConvertJSONData requestData:url];
    if(jsonArr!=nil){
        
        imageArr = [[NSMutableArray alloc]init];
        thumb_ImageArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in jsonArr) {
            
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:[dic valueForKey:@"_original_path"]]];
            photo.caption = [dic valueForKey:@"_remark"];
            [imageArr addObject:photo];
            
            photo = nil;
            
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:[dic valueForKey:@"_thumb_path"]]];
            [thumb_ImageArr addObject:photo];
            
            
        }
        
        //以每条文章信息的ID保存信息
        [perData setObject:imageArr forKey:@"imageArr"];//大图
        [perData setObject:thumb_ImageArr forKey:@"thumb_ImageArr"];//小图
        
        [totalData setObject:perData forKey:articleId];
        
        //NSLog(@"totalData=%@",totalData);
        
    }
    
}


-(void)goPhotoView:(NSString *)articleId{
    
    
    self.photos = [[totalData valueForKey:articleId] valueForKey:@"imageArr"];
    self.thumbs = [[totalData valueForKey:articleId] valueForKey:@"thumb_ImageArr"];
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = YES;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
	
	MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:0];
    
    [self.navigationController pushViewController:browser animated:YES];
    //    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    //    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //    [self presentViewController:nc animated:YES completion:nil];
    
    self.tabBarController.tabBar.hidden = YES;
    InitTabBarViewController *tabBarController = (InitTabBarViewController *)self.tabBarController;
    [tabBarController hiddenDIYTaBar];
    
}

-(void)goVideoView:(NSString *)articleId{
    GirlsVideoViewController *girlVideoView = (GirlsVideoViewController*)[self getVCFromSB:@"girlsVideo"];
    passValelegate = girlVideoView;
    [passValelegate passValue:articleId];
    [self.navigationController pushViewController:girlVideoView animated:YES];
    //NSLog(@"articleId=%@",articleId);
    
}

-(void)goArticelView:(NSString *)articleId{
    
    StoryDetailViewController *storyDetail = (StoryDetailViewController *)[self getVCFromSB:@"storyDetail"];
    passValelegate = storyDetail;
    [passValelegate passValue:articleId];
    [self.navigationController pushViewController:storyDetail animated:YES];
    
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}


- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
    
    NSString *userId = [StringUitl getSessionVal:LOGIN_USER_ID];
    if ([self isEmpty:userId]) {
        LoginViewController *login = (LoginViewController *)[self getVCFromSB:@"userLogin"];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }else{
        StoryCommentViewController *storyComment = (StoryCommentViewController *)[self getVCFromSB:@"storyComment"];
        passValelegate = storyComment;
        [passValelegate passValue:artId];
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        [param setObject:@"xc" forKey:@"stype"];
        [passValelegate passDicValue:param];
        
        [self.navigationController pushViewController:storyComment animated:YES];
    }
    
}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"%d / %d", index+1,_photos.count];
}

@end
