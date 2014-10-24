//
//  GirlsViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "GirlsViewController.h"

@interface GirlsViewController (){
    NSString * dataType;
    NSString * artId;
    NSDictionary *cellDic;
    NSArray *sourceArray;
    NSMutableArray *photoArray;
    FFScrollView *scrollView;
    
    CommonViewController *comViewController;
    XHFriendlyLoadingView *friendlyLoadingView;
    
    BOOL isHeaderSeted;
    BOOL isFooterSeted;
    
    NSMutableArray *imageArr;
    NSMutableArray *titleArr;
    int currentPageIndex;
    
    MWPhoto *photo;
    NSString *max_id;
    NSInteger selectedCount;
    NSMutableArray *commonArr;
}

@end

@implementation GirlsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self initLoading];
    [self initLoadData];
    
    [self setHeaderRereshing];
    [self setFooterRereshing];
    
}

-(void)dealloc{
    
    dataType = nil;
    cellDic = nil;
    sourceArray = nil;
    commonArr = nil;
    artId = nil;
    imageArr= nil;
    photo = nil;
    max_id = nil;
    imageArr = nil;
    titleArr = nil;
    photoArray = nil;
    scrollView = nil;
    comViewController = nil;
    friendlyLoadingView = nil;
    
}


-(void)initLoadData{
    
    bannerData = [[NSMutableDictionary alloc]init];
    _girlsDataList = [[NSMutableArray alloc]init];
    
    [self initBannerData];
    currentPageIndex = 1;
    [self loadGirlData:@"1" withPageSize:PAGESIZE];
    //集成刷新控件
    [self setHeaderRereshing];
    [self setFooterRereshing];
    [self setBannerView];
    
    _girlsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _girlsTableView.backgroundColor = [StringUitl colorWithHexString:CONTENT_BACK_COLOR];
    
}

-(void)initLoading{
    if(friendlyLoadingView==nil){
        friendlyLoadingView = [[XHFriendlyLoadingView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, MAIN_FRAME_H)];
    }
    __weak typeof(self) weakSelf = self;
    friendlyLoadingView.reloadButtonClickedCompleted = ^(UIButton *sender) {
        [weakSelf reloadTData:nil];
    };
    
    [self.view addSubview:friendlyLoadingView];
    
    [friendlyLoadingView showFriendlyLoadingViewWithText:@"正在加载..." loadingAnimated:YES];
}

- (void)showLoading {
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        selectedCount ++;
        if (selectedCount == 3) {
            [friendlyLoadingView showFriendlyLoadingViewWithText:@"重新加载失败，请检查网络。" loadingAnimated:NO];
        } else {
            [friendlyLoadingView showReloadViewWithText:@"加载失败，请点击刷新。"];
        }
    });
}

-(void)setBannerView{
    UIView *bannerBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    //设置顶部图片
    UIImageView *bannerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    NSString *imgUrl =[bannerData valueForKey:@"_img_url"];
    [bannerView sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                   placeholderImage:[UIImage imageNamed:NOIMG_ICON] options:SDWebImageRefreshCached];
    
    bannerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked:)];
    [bannerView addGestureRecognizer:singleTap];
    
    //设置图片标题
    UILabel *picTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 155, SCREEN_WIDTH, 25)];
    picTitle.text = [bannerData valueForKey:@"_title"];
    picTitle.backgroundColor = [UIColor blackColor];
    picTitle.alpha = 0.7f;
    picTitle.textColor = [UIColor whiteColor];
    picTitle.textAlignment = NSTextAlignmentLeft;
    picTitle.font = TITLE_FONT;
    
    [bannerBaseView addSubview:bannerView];
    [bannerView addSubview:picTitle];
    _girlsTableView.tableHeaderView = bannerBaseView;
    
}

-(void)UesrClicked:(UIImageView *)imgView{
    
    NSString *artcleId = [bannerData valueForKey:@"_id"];
    NSString * data_type = [bannerData valueForKey:@"_category_call_index"];
    if([data_type isEqualToString:@"video"]){
        [self goVideoView:artcleId];
    }else if([data_type isEqualToString:@"albums"]){
       [self loadGirlPhotoData:artcleId];
    }else{
       [self goArticelView:artcleId];
    }
    
}

//加载头部刷新
-(void)setHeaderRereshing{
    if(!isHeaderSeted){
        AllAroundPullView *topPullView = [[AllAroundPullView alloc] initWithScrollView:self.girlsTableView position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
            [self performSelector:@selector(callBackMethod:) withObject:@"new" afterDelay:DELAY_TIME];
            [view performSelector:@selector(finishedLoading) withObject:@"old" afterDelay:1.0f];
        }];
        [self.girlsTableView addSubview:topPullView];
        isHeaderSeted = YES;
    }
}

//加底部部刷新
-(void)setFooterRereshing{
    if(!isFooterSeted){
        AllAroundPullView *bottomPullView = [[AllAroundPullView alloc] initWithScrollView:self.girlsTableView position:AllAroundPullViewPositionBottom action:^(AllAroundPullView *view){
            [self performSelector:@selector(callBackMethod:) withObject:nil afterDelay:DELAY_TIME];
            [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:1.0f];
        }];
        [self.girlsTableView addSubview:bottomPullView];
        isFooterSeted = YES;
    }
}


//这是一个模拟方法，请求完成之后，回调方法
-(void)callBackMethod:(id) obj
{
    
    [self reloadTData:obj];
    
}

-(void)reloadTData:(id)object{
    
    //再次请求数据
    if([object isEqualToString:@"new"]){
        [self loadNewGirlData:max_id];
    }else{
        currentPageIndex++;
        [self loadGirlData:[NSString stringWithFormat:@"%d",currentPageIndex] withPageSize:PAGESIZE];
    }
    
    [self initBannerData];
    [self.girlsTableView reloadData];
}

- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger s = [self.girlsTableView numberOfSections];
	if (s<1) return;
	NSInteger r = [self.girlsTableView numberOfRowsInSection:s-1];
	if (r<1) return;
	
	NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
	
	[self.girlsTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
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
    
    //[_girlsTableView reloadData];
}


/*********************************************处理数据方法 开始********************************************/

//初始化头部数据
-(void)initBannerData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",REMOTE_URL,PHOTO_BANNER_URL];
    [self requestDataByUrl:url withType:1 withIndex:nil];
    
}

-(void)loadGirlData:(NSString *)pageIndex withPageSize:(NSString *)pageSize {
    
    NSString *url = [NSString stringWithFormat:@"%@%@/0/%@/%@",REMOTE_URL,GIRLS_LIST,pageSize,pageIndex];
    [self requestDataByUrl:url withType:2 withIndex:pageIndex];

}

-(void)loadNewGirlData:(NSString *)maxid{
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@/%@",REMOTE_URL,LOAD_NEW_DATA,@"girl",max_id];
    [self requestDataByUrl:url withType:3 withIndex:nil];
    
}

-(void)loadGirlPhotoData:(NSString *)articleId {
    artId = articleId;
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_PHOTO_LIST,articleId];
    [self requestDataByUrl:url withType:4 withIndex:nil];
    
}



-(void)requestDataByUrl:(NSString *)url withType:(int)type withIndex:(NSString *)pageIndex{
    //处理路劲
    NSURL *reqUrl = [NSURL URLWithString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:reqUrl];
    //设置代理
    [request setDelegate:self];
    [request startAsynchronous];
    [request setTag:type];
    [request setUsername:pageIndex];
    
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestFinished:)];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *respData = [request responseData];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"tag->%d",request.tag);
    commonArr = (NSMutableArray *)jsonDic;
    if(commonArr!=nil && commonArr.count>0){
        
        switch (request.tag) {
            case 1:
                if(commonArr!=nil && commonArr.count>0){
                    bannerData = (NSMutableDictionary *)commonArr[0];
                }
                [self setBannerView];
                break;
            case 2:
                //_girlsDataList = [[NSMutableArray alloc] init];
                if (commonArr!=nil && commonArr.count>0) {
                    [_girlsDataList addObjectsFromArray:commonArr];
                    if([request.username isEqualToString:@"1"]){
                        max_id = [[commonArr objectAtIndex:0] valueForKey:@"_id"];
                    }
                }else{
                    [self showHint:@"没有更多数据了!"];
                }
                break;
            case 3:
                if (commonArr!=nil && commonArr.count>0) {
                    [commonArr addObjectsFromArray:_girlsDataList];
                    _girlsDataList = [[NSMutableArray alloc]init];
                    [_girlsDataList addObjectsFromArray:commonArr];
                }else{
                    [self showHint:@"没有更多数据了!"];
                }
                break;
            case 4:
                imageArr = [[NSMutableArray alloc]init];
                for (int i=0; i<commonArr.count; i++) {
                    NSDictionary * dic = (NSDictionary *)commonArr[i];
                    photo = [MWPhoto photoWithURL:[NSURL URLWithString:[dic valueForKey:@"_original_path"]]];
                    photo.caption = [dic valueForKey:@"_remark"];
                    [imageArr addObject:photo];
                }
                [self goPhotoView:artId];
                
                break;
            default:
                break;
        }
        [_girlsTableView reloadData];
    }
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"jsonDic->%@",error);
    [self initLoading];
    [self setHeaderRereshing];
    [self showLoading];
    //[self setFooterRereshing];
    
}

-(void)loadGirlPhotos:(NSString *)articleId {
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_PHOTO_LIST,articleId];
    NSMutableArray * newDataArr = (NSMutableArray *)[convertJson requestData:url];
    photoArray = [[NSMutableArray alloc]init];
    [photoArray addObjectsFromArray:newDataArr];
    //NSLog(@"photoArray===%@",photoArray);
}




/*********************************************处理数据方法 结束********************************************/


#pragma mark 控制滚动头部一起滚动
- (void)scrollViewDidScroll:(UIScrollView *)sclView{
    CGFloat sectionHeaderHeight = 30;
    //固定section 随着cell滚动而滚动
    if (sclView.contentOffset.y<=sectionHeaderHeight && sclView.contentOffset.y>=0) {
        sclView.contentInset = UIEdgeInsetsMake(-sclView.contentOffset.y, 0, 0, 0);
    } else if (sclView.contentOffset.y>=sectionHeaderHeight) {
        //sclView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark 设置组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark 设置组高度
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

#pragma mark 设置组标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

#pragma mark 设置每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_girlsDataList count];
}

#pragma mark 行选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![StringUitl checkLogin]==TRUE){
        
        [StringUitl setSessionVal:@"NAV" withKey:FORWARD_TYPE];
        LoginViewController *loginView = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginView animated:YES];
        
    }else{
        
        cellDic = [self.girlsDataList objectAtIndex:indexPath.row];
        dataType = [cellDic valueForKey:@"_category_call_index"];
        if([dataType isEqualToString:@"albums"]){
            
            [self loadGirlPhotoData:[[cellDic valueForKey:@"_id"] stringValue]];
            
        }else if([dataType isEqualToString:@"video"]){
            
            [self goVideoView:[[cellDic valueForKey:@"_id"] stringValue]];
            
        }else{
            
            [self goArticelView:[[cellDic valueForKey:@"_id"] stringValue]];
            
        }
        
    }
    
}

#pragma mark 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    cellDic = [self.girlsDataList objectAtIndex:indexPath.row];
    dataType = [cellDic valueForKey:@"_category_call_index"];
    if([dataType isEqualToString:@"albums"]){
        return 120.0;
    }else{
        return 95.0;
    }
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self scrollTableToFoot:YES];
            [friendlyLoadingView removeFromSuperview];
        });
    }
}


#pragma mark 加载数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cellDic = [self.girlsDataList objectAtIndex:indexPath.row];
    dataType = [cellDic valueForKey:@"_category_call_index"];
    if([dataType isEqualToString:@"article"]){//判断是否为图片
        UINib *nibCell = [UINib nibWithNibName:@"PicTableViewCell" bundle:nil];
        [tableView registerNib:nibCell forCellReuseIdentifier:@"PicCell"];
        
        PicTableViewCell *picCell = [tableView dequeueReusableCellWithIdentifier:@"PicCell"];
        picCell.selectionStyle = UITableViewCellSelectionStyleNone;
        picCell.backgroundColor = [UIColor clearColor];
        
        //[StringUitl setCornerRadius:picCell.cellBgView withRadius:5.0f];
        //[StringUitl setCornerRadius:picCell.picView withRadius:5.0f];
        //[StringUitl setViewBorder:picCell.cellBgView withColor:@"#F5F5F5" Width:0.5f];
        
        [picCell.picView sd_setImageWithURL:[NSURL URLWithString:[cellDic valueForKey:@"_img_url"]]
                       placeholderImage:[UIImage imageNamed:NOIMG_ICON] options:SDWebImageRefreshCached];
        //picCell.cellBgView.layer.cornerRadius = 5.0f;
        //picCell.cellBgView.layer.masksToBounds = YES;
        picCell.titleView.text = [cellDic valueForKey:@"_title"];
        picCell.descView.text = [cellDic valueForKey:@"_zhaiyao"];
        picCell.titleView.font = TITLE_FONT;
        picCell.descView.font = DESC_FONT;
        return picCell;
        
    }else if([dataType isEqualToString:@"video"]){
        static BOOL isNibregistered = NO;
        if(!isNibregistered){
            UINib *nibCell = [UINib nibWithNibName:@"VideoTableViewCell" bundle:nil];
            [tableView registerNib:nibCell forCellReuseIdentifier:@"VideoCell"];
            isNibregistered = YES;
        }
        
        VideoTableViewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:@"VideoCell"];
        videoCell.selectionStyle =UITableViewCellSelectionStyleNone;
        videoCell.backgroundColor = [UIColor clearColor];
        
        //[StringUitl setViewBorder:videoCell.cellBgView withColor:@"#F5F5F5" Width:0.5f];
        //[StringUitl setCornerRadius:videoCell.cellBgView withRadius:5.0f];
        //[StringUitl setCornerRadius:videoCell.videoPic withRadius:5.0f];
        
        [videoCell.videoPic sd_setImageWithURL:[NSURL URLWithString:[cellDic valueForKey:@"_img_url"]]
                        placeholderImage:[UIImage imageNamed:NOIMG_ICON] options:SDWebImageRefreshCached];
        
        videoCell.videoTitle.text = [cellDic valueForKey:@"_title"];
        videoCell.videoDesc.text = [cellDic valueForKey:@"_zhaiyao"];
        
        NSString *clickNum = [cellDic valueForKey:@"clicknum"];
        if([StringUitl isEmpty:clickNum]){
            clickNum = @"0";
        }
        videoCell.clickNum.text = clickNum;
        videoCell.videoTitle.font = main_font(14);
        videoCell.videoDesc.font = DESC_FONT;
        
        [videoCell.videoBtn setUserInteractionEnabled:YES];
        return videoCell;
   }else{
       
       static BOOL isNibregistered = NO;
       if(!isNibregistered){
           UINib *nibCell = [UINib nibWithNibName:@"PhotoScrollViewCell" bundle:nil];
           [tableView registerNib:nibCell forCellReuseIdentifier:@"photoScroll"];
           isNibregistered = YES;
       }
       
       PhotoScrollViewCell *photoCell = [tableView dequeueReusableCellWithIdentifier:@"photoScroll"];
       [photoCell setBackgroundColor:[UIColor clearColor]];
       photoCell.selectionStyle =UITableViewCellSelectionStyleNone;
       //通过文章获取相册
       NSString *artcleId =[cellDic valueForKey:@"_id"];
       [self loadGirlPhotos:artcleId];
       if(photoArray!=nil && photoArray.count>0){
           [photoCell.photoScroll setContentSize:CGSizeMake((photoArray.count)*130-10, 80)];
           [photoCell.photoScroll setShowsHorizontalScrollIndicator:NO];
           [photoCell.photoScroll setBackgroundColor:[UIColor whiteColor]];
           //[photoScroll setShowsVerticalScrollIndicator:NO];
           
           //加载图片
           for(int i=0;i<photoArray.count;i++){

               NSMutableDictionary *picDic = (NSMutableDictionary *)[photoArray objectAtIndex:i];
               UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((100+30)*i, 0, 120, 80)];
               imageView.userInteractionEnabled = YES;
               [imageView sd_setImageWithURL:[NSURL URLWithString:[picDic valueForKey:@"_thumb_path"]]
                         placeholderImage:[UIImage imageNamed:NOIMG_ICON] options:SDWebImageRefreshCached];
               [StringUitl setCornerRadius:imageView withRadius:5.0f];
               
               UIButton *imgbtn = [[UIButton alloc]initWithFrame:CGRectMake((100+30)*i, 0, 120, 80)];
               [imgbtn setBackgroundColor:[UIColor clearColor]];
               imgbtn.tag = [artcleId integerValue];
               [imgbtn addTarget:self action:@selector(imgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
               
               [photoCell.photoScroll addSubview:imageView];
               [photoCell.photoScroll addSubview:imgbtn];
           }
           
           [StringUitl setCornerRadius:photoCell.cellBgView withRadius:5.0f];
           [StringUitl setViewBorder:photoCell.cellBgView withColor:@"#cccccc" Width:0.5f];
           
           
           [photoCell.titleView setText:[cellDic valueForKey:@"_title"]];
           photoCell.titleView.font = main_font(13);
           
       }
       
       return photoCell;
   }
    
}


-(void)imgBtnClick:(UIButton *)sender{
    
    //NSLog(@"@artcleId=%d",sender.tag);
    [self loadGirlPhotoData:[NSString stringWithFormat:@"%d",sender.tag]];
}

-(void)goPhotoView2:(NSString *)articleId{
    GirlsPhotosViewController *girlPhotoView = [[GirlsPhotosViewController alloc]init];
    passValelegate = girlPhotoView;
    [passValelegate passValue:articleId];
    [self.navigationController pushViewController:girlPhotoView animated:YES];
    //NSLog(@"articleId=%@",articleId);
}



-(void)goPhotoView:(NSString *)articleId{

    self.photos = imageArr;
    self.thumbs = imageArr;
    
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
    GirlsVideoViewController *girlVideoView = [[GirlsVideoViewController alloc]init];
    passValelegate = girlVideoView;
    [passValelegate passValue:articleId];
    [self.navigationController pushViewController:girlVideoView animated:YES];
    //NSLog(@"articleId=%@",articleId);
    
}

-(void)goArticelView:(NSString *)articleId{
    StoryDetailViewController *articelView = [[StoryDetailViewController alloc]init];
    passValelegate = articelView;
    [passValelegate passValue:articleId];
    [self.navigationController pushViewController:articelView animated:YES];
    //NSLog(@"articleId=%@",articleId);
    
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
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }else{
        StoryCommentViewController *storyComment  = [[StoryCommentViewController alloc] init];
        passValelegate = storyComment;
        [passValelegate passValue:artId];
        [self.navigationController pushViewController:storyComment animated:YES];
    }
}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"%d / %d", index+1,_photos.count];
}

@end
