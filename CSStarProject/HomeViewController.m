//
//  HomeViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "InitTabBarViewController.h"

@interface HomeViewController (){
    NSString * dataType;
    NSDictionary *cellDic;
    NSArray *sourceArray;
    NSArray *slideArr;
    NSArray *commonArr;
    NSString * artId;
    
    NSMutableArray *imageArr;
    MWPhoto *photo;
    
    FFScrollView *scrollView;
    UIButton *footerBtn;
    CommonViewController *comViewController;
    
    BOOL isHeaderSeted;
    BOOL isFooterSeted;
    XHFriendlyLoadingView *friendlyLoadingView;
    
    int showflag;
    
    NSString *dataTP;
    NSString *dataID;
}

@end



@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self showLoading:@"加载中，请稍后..."];
    [self initLoading];
    [self initLoadData];
    
    [self setHeaderRereshing];
    [self setFooterRereshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showContent) name:@"showContent" object:nil];
}

-(void)initLoading{
    if(friendlyLoadingView==nil){
      friendlyLoadingView = [[XHFriendlyLoadingView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, MAIN_FRAME_H)];
    }
    __weak typeof(self) weakSelf = self;
    friendlyLoadingView.reloadButtonClickedCompleted = ^(UIButton *sender) {
        [weakSelf reloadTData];
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



-(void)initLoadData{
    
    [self setTableData];
    self.homeTableView.backgroundColor = [StringUitl colorWithHexString:@"#F5F5F5"];
    //_homeTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
    _homeTableView.rowHeight = 85;
    _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

-(void)initScroll{

    scrollView = [[FFScrollView alloc]initPageViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 180) views:sourceArray];
    //NSLog(@"subviws==%d",[[scrollView scrollView] subviews].count);
    
    NSArray *varr = [[scrollView scrollView] subviews];
    for (int i=0; i<varr.count; i++) {
        
        UIImageView *imageView = (UIImageView *)varr[i];
       // NSLog(@"arr=%@",imageView);
        [imageView setMultipleTouchEnabled:YES];
        [imageView setUserInteractionEnabled:YES];
        
        imageView.tag = i;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        
    }
    
    _homeTableView.tableHeaderView = scrollView;
}

- (void)tapImage:(UITapGestureRecognizer *)tap{
    
    int tag =  tap.view.tag;
    NSDictionary *slideDic = [slideArr objectAtIndex:tag-1];
    NSString *dataId = [[slideDic valueForKey:@"_id"] stringValue];
    NSString *data_Type = [slideDic valueForKey:@"_category_call_index"];
    if([self isNotEmpty:dataId]){
        
        dataID = dataId;
        if([data_Type isEqual:@"video"]){//视频
            dataTP = @"video";
            GirlsVideoViewController *videoView = (GirlsVideoViewController *)[self getVCFromSB:@"girlsVideo"];
            passValelegate = videoView;
            [passValelegate passValue:dataId];
            if([self check_login]){
               [self.navigationController pushViewController:videoView animated:YES];
            }
        }
        
        if([data_Type isEqual:@"albums"]){//相册
            dataTP = @"albums";
            artId = dataId;
            if([self check_login]){
              [self loadGirlPhotos:dataId];
            }
        }
        
        
        if([data_Type isEqual:@"article"]||[data_Type isEqual:@"slide"]||[data_Type isEqual:@"city"]){//文章
            dataTP = @"article";
            StoryDetailViewController *storyDetail = (StoryDetailViewController *)[self getVCFromSB:@"storyDetail"];
            passValelegate = storyDetail;
            [passValelegate passValue:dataId];
            if([self check_login]){
               [self.navigationController pushViewController:storyDetail animated:YES];
            }
        }
    }
}


-(void)showContent{
    
    if([self isNotEmpty:dataID]){

        if([dataTP isEqual:@"video"]){//视频
            GirlsVideoViewController *videoView = (GirlsVideoViewController *)[self getVCFromSB:@"girlsVideo"];
            passValelegate = videoView;
            [passValelegate passValue:dataID];
            [self.navigationController pushViewController:videoView animated:YES];
        }
        
        if([dataTP isEqual:@"albums"]){//相册
            [self loadGirlPhotos:dataID];
        }
        
        if([dataTP isEqual:@"article"]){//文章
            
            StoryDetailViewController *storyDetail = (StoryDetailViewController *)[self getVCFromSB:@"storyDetail"];
            passValelegate = storyDetail;
            [passValelegate passValue:dataID];
            [self.navigationController pushViewController:storyDetail animated:YES];
            
        }
        
        if([dataTP isEqual:@"story"]){//跳转到星城故事
            
            StoryDetailViewController *storyDetailView = (StoryDetailViewController *)[self getVCFromSB:@"storyDetail"];
            passValelegate = storyDetailView;
            [passValelegate passValue:dataID];
            [self.navigationController pushViewController:storyDetailView animated:YES];
            
        }
        
        if([dataTP isEqual:@"people"]){//跳转到活动众筹

            PeopleDetailViewController *deatilViewController = (PeopleDetailViewController *)[self getVCFromSB:@"peopleDetail"];
            passValelegate = deatilViewController;
            [passValelegate passValue:dataID];
            [self.navigationController pushViewController:deatilViewController animated:YES];
            
        }
        
    }
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    InitTabBarViewController *tabBarController = (InitTabBarViewController *)self.tabBarController;
    [tabBarController showDIYTaBar];
    //[tabBarController changeTabsFrame];
    [self initLoadData];
    [_homeTableView reloadData];
    
    
}


//加载头部刷新
-(void)setHeaderRereshing{
    if(!isHeaderSeted){
        AllAroundPullView *topPullView = [[AllAroundPullView alloc] initWithScrollView:self.homeTableView position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
            NSLog(@"up-");
            [self performSelector:@selector(callBackMethod:) withObject:nil afterDelay:DELAY_TIME];
            [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:1.0f];
        }];
        [self.homeTableView addSubview:topPullView];
        isHeaderSeted = YES;
    }
}

//加底部部刷新
-(void)setFooterRereshing{
    if(!isFooterSeted){
        AllAroundPullView *bottomPullView = [[AllAroundPullView alloc] initWithScrollView:self.homeTableView position:AllAroundPullViewPositionBottom action:^(AllAroundPullView *view){
            NSLog(@"down-");
            [self performSelector:@selector(callBackMethod:) withObject:nil afterDelay:DELAY_TIME];
            [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:1.0f];
        }];
        [self.homeTableView addSubview:bottomPullView];
        isFooterSeted = YES;
    }
}


//这是一个模拟方法，请求完成之后，回调方法
-(void)callBackMethod:(id) obj
{
    [self reloadTData];
    //[self showHint:@"数据刷新成功!"];
}

-(void)reloadTData{
    
    [self loadSliderPic];
    [self loadGirlsData];
    [self loadStoryData];
    [self loadPeopleData];

}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"长沙星" hasLeftItem:NO hasRightItem:YES leftIcon:nil rightIcon:Nil]];
}


-(void)setTableData{

    [self loadSliderPic];
    [self loadGirlsData];
    [self loadStoryData];
    [self loadPeopleData];
    
}

-(void)loadGirlPhotos:(NSString *)articleId {
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_PHOTO_LIST,articleId];
    [self requestDataByUrl:url withType:5];
}


-(void)loadSliderPic{

    NSString *url = [NSString stringWithFormat:@"%@%@",REMOTE_URL,SLIDE_TOP];
    [self requestDataByUrl:url withType:1];
    
}

-(void)loadGirlsData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@/1/is_red=1",REMOTE_URL,GIRLS_TOP];
    [self requestDataByUrl:url withType:2];
    
}

-(void)loadStoryData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@/1/is_red=1",REMOTE_URL,CITY_TOP];
    [self requestDataByUrl:url withType:3];
}

-(void)loadPeopleData{

    NSString *url = [NSString stringWithFormat:@"%@%@",REMOTE_URL,HOME_PEOPLE_URL];
    [self requestDataByUrl:url withType:4];
    
}

-(void)requestDataByUrl:(NSString *)url withType:(int)type{
    //处理路劲
    NSURL *reqUrl = [NSURL URLWithString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:reqUrl];
    //设置代理
    [request setDelegate:self];
    [request startAsynchronous];
    [request setTag:type];
    
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestFinished:)];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self hideHud];
    NSData *respData = [request responseData];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    //NSLog(@"jsonDic->%@",jsonDic);
    commonArr = (NSArray *)jsonDic;
    if(commonArr!=nil && commonArr.count>0){
    
        switch (request.tag) {
            case 1:
                sourceArray = [NSMutableArray arrayWithArray:[commonArr valueForKey:@"_img_url"]];
                slideArr = commonArr;
                [self initScroll];
                break;
            case 2:
                _girlsDataList = [NSMutableArray arrayWithArray:commonArr];
                break;
            case 3:
                _storyDataList = [NSMutableArray arrayWithArray:commonArr];
                break;
            case 4:
                _peopleDataList = [NSMutableArray arrayWithArray:commonArr];
                break;
            case 5:
                imageArr = [[NSMutableArray alloc]init];
                for (int i=0; i<commonArr.count; i++) {
                    NSDictionary * dic = (NSDictionary *)commonArr[i];
                    photo = [MWPhoto photoWithURL:[NSURL URLWithString:[dic valueForKey:@"_original_path"]]];
                    photo.caption = [dic valueForKey:@"_remark"];
                    [imageArr addObject:photo];
                    photo = nil;
                }
                [self goPhotoView:imageArr];
                imageArr = nil;

                break;
            default:
                break;
        }
        
        
        _headTitleArray = [NSMutableArray arrayWithArray:@[@"美女私房",@"星城故事",@"活动众筹"]];
        [_homeTableView reloadData];
        showflag++;
        if (showflag==4) {
            [friendlyLoadingView removeFromSuperview];
        }
    }
    
}

-(void)goPhotoView:(NSMutableArray *)arr{

    //NSLog(@"arr=%@",arr);
    self.photos = arr;
    self.thumbs = arr;
    
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
    self.tabBarController.tabBar.hidden = YES;
    InitTabBarViewController *tabBarController = (InitTabBarViewController *)self.tabBarController;
    [tabBarController hiddenDIYTaBar];
}



- (void)requestFailed:(ASIHTTPRequest *)request
{
    showflag = 0;
    NSError *error = [request error];
    NSLog(@"jsonDic->%@",error);
    [self initLoading];
    [self showLoading];
    
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
    //提交评论
    NSString *userId = [StringUitl getSessionVal:LOGIN_USER_ID];
    if ([self isEmpty:userId]) {
        LoginViewController *login  = (LoginViewController *)[self getVCFromSB:@"userLogin"];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }else{
        StoryCommentViewController *storyComment  = (StoryCommentViewController *)[self getVCFromSB:@"storyComment"];
        passValelegate = storyComment;
        [passValelegate passValue:artId];
        [self.navigationController pushViewController:storyComment animated:YES];
    }
}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"%d / %d", index+1,_photos.count];
}





#pragma mark 控制滚动头部一起滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollViews {
    CGFloat sectionHeaderHeight = 30;
    if (scrollViews.contentOffset.y<=sectionHeaderHeight && scrollViews.contentOffset.y>=0) {
        scrollViews.contentInset = UIEdgeInsetsMake(-scrollViews.contentOffset.y, 0, 0, 0);
    } else if (scrollViews.contentOffset.y>=sectionHeaderHeight) {
        //scrollViews.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGRect headFrame = CGRectMake(0, 4, 320, 35);
    UIView *sectionHeadView = [[UIView alloc]initWithFrame:headFrame];
    sectionHeadView.backgroundColor = [StringUitl colorWithHexString:@"#F5F5F5"];
    //设置每组的头部图片
    NSString *imgName = [NSString stringWithFormat:@"header_%d@2x.png",section];
    UIImageView *imageView = IMG_WITH_NAME(imgName);
    [imageView setFrame:CGRectMake(5, 6, 3, 20)];
    //设置每组的标题
    UILabel *headtitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 30)];
    headtitle.text = [_headTitleArray objectAtIndex:section];
    headtitle.font = TITLE_FONT;
    
    [sectionHeadView addSubview:imageView];
    [sectionHeadView addSubview:headtitle];

    
    return sectionHeadView;
}

#pragma mark 设置组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _headTitleArray.count;
}

#pragma mark 设置组高度
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

#pragma mark 设置组标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_headTitleArray objectAtIndex:section];
}


#pragma mark 设置每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [_girlsDataList count];
            break;
        case 1:
            return [_storyDataList count];
            break;
        case 2:
            return [_peopleDataList count];
            break;
        default:
            return 0;
            break;
    }
}

-(BOOL)check_login{
    
    if(![StringUitl checkLogin]){
        LoginViewController *loginView = (LoginViewController *)[self getVCFromSB:@"userLogin"];
        [self presentViewController:loginView animated:YES completion:nil];
        [StringUitl setSessionVal:@"TAB" withKey:FORWARD_TYPE];
        //[self.navigationController pushViewController:loginView animated:YES];
        return NO;
    }else{
      return YES;
    }
    
}

#pragma mark 行选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
        if(indexPath.section==0){//跳转到美女私房
            
            NSDictionary *girlCellDic = [self.girlsDataList objectAtIndex:indexPath.row];
            NSString *dataId = [[girlCellDic valueForKey:@"_id"] stringValue];
            NSString *data_Type = [girlCellDic valueForKey:@"_category_call_index"];
            
            
            if([self isNotEmpty:dataId]){
                
                dataID = dataId;
                if([data_Type isEqual:@"video"]){//视频
                     dataTP = @"video";
                     GirlsVideoViewController *videoView = (GirlsVideoViewController *)[self getVCFromSB:@"girlsVideo"];
                     passValelegate = videoView;
                    [passValelegate passValue:dataId];
                    if([self check_login]){
                      [self.navigationController pushViewController:videoView animated:YES];
                    }
                }
                
                if([data_Type isEqual:@"albums"]){//相册
                     artId = dataId;
                     dataTP = @"albums";
                    if([self check_login]){
                      [self loadGirlPhotos:dataId];
                    }
                }
                
                
                if([data_Type isEqual:@"article"]){//文章
                    dataTP = @"article";
                    StoryDetailViewController *storyDetail = (StoryDetailViewController *)[self getVCFromSB:@"storyDetail"];
                    passValelegate = storyDetail;
                    [passValelegate passValue:dataId];
                    if([self check_login]){
                       [self.navigationController pushViewController:storyDetail animated:YES];
                    }
                }
                
                
            }
            
        }
        
        if(indexPath.section==1){//跳转到星城故事
            
            NSDictionary *storyCellDic = [self.storyDataList objectAtIndex:indexPath.row];
            NSString *dataId = [[storyCellDic valueForKey:@"_id"] stringValue];
            
            dataID = dataId;
            dataTP = @"story";
            
            StoryDetailViewController *storyDetailView = (StoryDetailViewController *)[self getVCFromSB:@"storyDetail"];
            passValelegate = storyDetailView;
            [passValelegate passValue:dataId];
            if([self check_login]){
               [self.navigationController pushViewController:storyDetailView animated:YES];
            }
            
        }
        
        if(indexPath.section==2){//跳转到活动众筹
            NSDictionary *peopleDic = [_peopleDataList objectAtIndex:0];
            if(peopleDic!=nil){
                NSString *projectId = [[peopleDic valueForKey:@"id"] stringValue];
                
                dataID = projectId;
                dataTP = @"people";
                PeopleDetailViewController *deatilViewController = (PeopleDetailViewController *)[self getVCFromSB:@"peopleDetail"];
                passValelegate = deatilViewController;
                [passValelegate passValue:projectId];
                if([self check_login]){
                   [self.navigationController pushViewController:deatilViewController animated:YES];
                }
            }
            
        }
}


#pragma mark 加载数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:
            cellDic = [self.girlsDataList objectAtIndex:indexPath.row];
            break;
        case 1:
            cellDic = [self.storyDataList objectAtIndex:indexPath.row];
            break;
        case 2:
            cellDic = [self.peopleDataList objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    
    
    
    dataType = [cellDic valueForKey:@"_category_call_index"];
    if([dataType isEqual:@"video"]){//判断是否为视频
        
        static BOOL isNibregistered = NO;
        if(!isNibregistered){
            UINib *nibCell = [UINib nibWithNibName:@"VideoTableViewCell" bundle:nil];
            [tableView registerNib:nibCell forCellReuseIdentifier:@"VideoCell"];
            isNibregistered = YES;
        }
        
        VideoTableViewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:@"VideoCell"];
        videoCell.selectionStyle =UITableViewCellSelectionStyleNone;
        videoCell.backgroundColor = [UIColor clearColor];
        //[StringUitl setCornerRadius:videoCell.cellBgView withRadius:5.0f];
        //[StringUitl setCornerRadius:videoCell.videoPic withRadius:5.0f];
        //[StringUitl setViewBorder:videoCell.cellBgView withColor:@"#F5F5F5" Width:0.5f];
        
        NSString *imgUrl =[cellDic valueForKey:@"_img_url"];
        [videoCell.videoPic md_setImageWithURL:imgUrl placeholderImage:NO_IMG options:SDWebImageRefreshCached];
        
        videoCell.videoTitle.text = [cellDic valueForKey:@"_title"];
        videoCell.videoTitle.font = TITLE_FONT;
        videoCell.videoDesc.text = [cellDic valueForKey:@"_zhaiyao"];
        videoCell.videoDesc.font = DESC_FONT;
        NSNumber * clickNum =[cellDic valueForKey:@"_click"];
        videoCell.clickNum.text = [clickNum stringValue];
        videoCell.videoTime.text = [cellDic valueForKey:@"_call_index"];
        return videoCell;

    }else{
        
        static BOOL isNibregistered = NO;
        if(!isNibregistered){
            UINib *nibCell = [UINib nibWithNibName:@"PicTableViewCell" bundle:nil];
            [tableView registerNib:nibCell forCellReuseIdentifier:@"PicCell"];
            isNibregistered = YES;
        }
        
        PicTableViewCell *picCell = [tableView dequeueReusableCellWithIdentifier:@"PicCell"];
        picCell.selectionStyle =UITableViewCellSelectionStyleNone;
        picCell.backgroundColor = [UIColor clearColor];
        //[StringUitl setCornerRadius:picCell.cellBgView withRadius:5.0f];
        //[StringUitl setCornerRadius:picCell.picView withRadius:5.0f];
        //[StringUitl setViewBorder:picCell.cellBgView withColor:@"#F5F5F5" Width:0.5f];
        
        
        
        NSString *imgUrl =[cellDic valueForKey:@"_img_url"];
        NSString *labelText = [cellDic valueForKey:@"_zhaiyao"];
        NSString *ctitle = [cellDic valueForKey:@"_title"];
        if (indexPath.section==2) {//处理众筹
            imgUrl = [cellDic valueForKey:@"imgUrl"];
            labelText = [cellDic valueForKey:@"introduction"];
            ctitle = [cellDic valueForKey:@"projectName"];
        }

        [picCell.picView md_setImageWithURL:imgUrl placeholderImage:NO_IMG options:SDWebImageRefreshCached];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        [paragraphStyle setLineSpacing:25.0f];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        picCell.descView.attributedText = attributedString;
        picCell.titleView.text = ctitle;
        picCell.titleView.font = TITLE_FONT;
        picCell.descView.text = labelText;
        picCell.descView.font = DESC_FONT;
        return picCell;
        
    }
    
}

@end
