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
    //处理相册变量
    NSString * artId;
    NSMutableArray *imageArr;
    NSMutableArray *titleArr;
    NSMutableArray *thumb_ImageArr;
    NSMutableDictionary *totalData;
    MWPhoto *photo;
    
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
    
    [self showLoading:@"加载中..."];
    [super viewDidLoad];
    _girlsPhotoTableView.showsVerticalScrollIndicator = NO;
    page_index = 1;
    [self loadGirlData:@"1"];
    
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:navTitle hasLeftItem:YES hasRightItem:YES leftIcon:nil rightIcon:nil]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    InitTabBarViewController *tabBarController = (InitTabBarViewController *)self.tabBarController;
    [tabBarController hiddenDIYTaBar];
    
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

/*加载数据*/
-(void)requestDataByUrl:(NSString *)url{
    
    [HttpClient GET:url
         parameters:nil
             isjson:TRUE
            success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         _girlsPhotoList = (NSMutableArray *)responseObject;
         if(_girlsPhotoList!=nil&&_girlsPhotoList.count>0){
             //刷新数据
             [self hideHud];
             [self.girlsPhotoTableView reloadData];
         }else{
             [self hideHud];
             [self showNo:@"没有数据了"];
         }
         
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
    return CGSizeMake(95, 150);
}


//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,5,5,5);
}


#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    //获取内容类型
    NSDictionary *dicData = [_girlsPhotoList objectAtIndex:indexPath.row];
    
    artId = [[dicData valueForKey:@"_id"] stringValue];//文章编号
    NSString *category_index = [dicData valueForKey:@"_category_call_index"];
    if([category_index isEqualToString:@"albums"]){//跳转到相册
        
        [self loadGirlPics:artId];
        [self goPhotoView:artId];
        
    }else if([category_index isEqualToString:@"video"]){//跳转到视频
    
        [self goVideoView:artId];
        
    }else{//跳转到文章
        
        [self goArticelView:artId];
        
    }
    
    
    
    
}


//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
