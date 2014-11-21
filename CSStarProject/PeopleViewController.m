//
//  PeopleViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "PeopleViewController.h"

@interface PeopleViewController (){
    
    FFScrollView *scrollView;
    NSArray *sourceArray;
    NSArray *projectsArray;
    NSArray *slideArr;
    NSArray *commonArr;
    NSDictionary *cellDic;
    MarqueeLabel *titleLabel;
    
    BOOL isHeaderSeted;
    BOOL isFooterSeted;
    UIView *filterBgView;
    UIScrollView *photoScroll;
    XHFriendlyLoadingView *friendlyLoadingView;
    
    int showflag;
}

@end

@implementation PeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLoading];
    [self setTableData];
    
    _peopleTableView.rowHeight = 300;
    _peopleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _peopleTableView.backgroundColor = [StringUitl colorWithHexString:@"#F5F5F5"];
    
    //集成刷新控件
    [self setHeaderRereshing];
    [self setFooterRereshing];
    
   
}

-(void)initLoading{
    if(friendlyLoadingView==nil){
        friendlyLoadingView = [[XHFriendlyLoadingView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, MAIN_FRAME_H)];
    }
    __weak typeof(self) weakSelf = self;
    friendlyLoadingView.reloadButtonClickedCompleted = ^(UIButton *sender) {
        [weakSelf setTableData];
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

//初始化过来条件层
-(void)initFilterView{
    
    UILabel *ptitle;
    UIButton *imgbtn;
    UIView *imgBgView;
    UIImageView *imageView;
    
    filterBgView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH,64, SCREEN_WIDTH, 75)];
    filterBgView.backgroundColor = [StringUitl colorWithHexString:@"#F5F5F5"];
    [StringUitl setViewBorder:filterBgView withColor:@"#cccccc" Width:0.5];
    //处理全部按钮
    imgBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 75)];
    [StringUitl setViewBorder:imgBgView withColor:@"#cccccc" Width:0.5];
    
    imageView = CGIMAG(20, 10, 40, 40);
    imageView.userInteractionEnabled = YES;
    [imageView setImage:CG_IMG(@"category-all.png")];
    
    [imgBgView addSubview:imageView];
    
    ptitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, 80, 40)];
    ptitle.text = @"所有";
    ptitle.font = main_font(12);
    ptitle.textColor = [UIColor grayColor];
    ptitle.textAlignment = NSTextAlignmentCenter;
    [imgBgView addSubview:ptitle];
    
    [filterBgView addSubview:imgBgView];
    
    imgbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 75)];
    [imgbtn setBackgroundColor:[UIColor clearColor]];
    imgbtn.tag = -1;
    [imgbtn addTarget:self action:@selector(imgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [filterBgView addSubview:imgbtn];

    
    photoScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH-80, 75)];
    if(projectsArray!=nil && projectsArray.count>0){
        
        [photoScroll setContentSize:CGSizeMake((projectsArray.count)*80, 75)];
        [photoScroll setShowsHorizontalScrollIndicator:NO];
        [photoScroll setBackgroundColor:[StringUitl colorWithHexString:@"#FFFFFF"]];
        [photoScroll setShowsVerticalScrollIndicator:NO];
        
        
        NSMutableDictionary *picDic;
        int len = projectsArray.count;
        for(int i=len;i>0;i--){
            
            picDic = (NSMutableDictionary *)[projectsArray objectAtIndex:(i-1)];
            imgBgView = [[UIView alloc]initWithFrame:CGRectMake(-80*(i-len), 0, 80, 75)];
            [StringUitl setViewBorder:imgBgView withColor:@"#F5F5F5" Width:0.5];
            imageView = CGIMAG(15, 15, 50, 30);
            imageView.userInteractionEnabled = YES;
            [imageView md_setImageWithURL:[picDic valueForKey:@"imageUrl"] placeholderImage:NO_IMG options:SDWebImageRefreshCached];
            
            [imgBgView addSubview:imageView];
            
            ptitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, 80, 40)];
            ptitle.text = [picDic valueForKey:@"catName"];
            ptitle.font = main_font(12);
            ptitle.textColor = [UIColor grayColor];
            ptitle.textAlignment = NSTextAlignmentCenter;
            [imgBgView addSubview:ptitle];
            
            [photoScroll addSubview:imgBgView];
            
            imgbtn = [[UIButton alloc]initWithFrame:CGRectMake(-80*(i-len), 0, 80, 75)];
            [imgbtn setBackgroundColor:[UIColor clearColor]];
            imgbtn.tag = [[picDic valueForKey:@"id"] intValue];
            [imgbtn addTarget:self action:@selector(imgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [photoScroll addSubview:imgbtn];
            
        }
        
    }
    
    [filterBgView addSubview:photoScroll];
    [self.view addSubview:filterBgView];
    
}

-(void)imgBtnClick:(UIButton *)sender{
    
    if([StringUitl checkLogin]==TRUE){
        NSLog(@"tag==%d",sender.tag);
        PeopleFilterProjectController *filterController = (PeopleFilterProjectController *)[self getVCFromSB:@"peopleFilter"];
        passValelegate = filterController;
        [passValelegate passValue:[NSString stringWithFormat:@"%d",sender.tag]];
        [self.navigationController pushViewController:filterController animated:YES];
        
    }else{
        [StringUitl setSessionVal:@"NAV" withKey:FORWARD_TYPE];
        LoginViewController *loginView = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginView animated:YES];
    }
    
    

}

-(void)setNavgationBar{
    //处理导航开始
    self.navigationController.navigationBarHidden = YES;
    UINavigationBar *navgationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_TITLE_HEIGHT+20)];
    [navgationBar setBackgroundImage:[UIImage imageNamed:NAVBAR_BG_ICON] forBarMetrics:UIBarMetricsDefault];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:nil];
    //处理标题
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 160, 44)];
    UILabel *titleLabels =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    [titleLabels setText:@"活动众筹"];
    titleLabels.font = BANNER_FONT;
    [titleLabels setTextColor:[StringUitl colorWithHexString:@"#0099FF"]];
    [titleLabels setTextAlignment:NSTextAlignmentCenter];
    [titleLabels setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    [centerView addSubview:titleLabels];
    
    UIButton *cbtn = [[UIButton alloc]initWithFrame:CGRectMake(120, 10, 32, 24)];
    [cbtn setImage:CG_IMG(@"btncategory.png") forState:UIControlStateNormal];
    [cbtn addTarget:self action:@selector(showFilterView:) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:cbtn];
    
    //设置右侧按钮
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rbtn setFrame:CGRectMake(0, 0, 32, 32)];
    [rbtn setTintColor:[UIColor whiteColor]];
    [rbtn setBackgroundImage:[UIImage imageNamed:NAVBAR_RIGHT_ICON] forState:UIControlStateNormal];
    [rbtn addTarget:self action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rbtn];
    
    navItem.titleView = centerView;
    navItem.rightBarButtonItem = rightBtnItem;
    [navgationBar pushNavigationItem:navItem animated:YES];
    
    [self.view addSubview:navgationBar];
    
}

-(void)showFilterView:(UIButton *)sender{
    
    [UIView animateWithDuration:0.35 animations:^{
        NSLog(@"y===%f",filterBgView.frame.origin.x);
        CGPoint tempCenter = filterBgView.center;
        if (filterBgView.frame.origin.x == SCREEN_WIDTH) {
            tempCenter.x -= filterBgView.bounds.size.width;
        } else {
            tempCenter.x += filterBgView.bounds.size.width;
        }
        filterBgView.center = tempCenter;
        
    }];
    
}


-(void)loadView{
    [super loadView];
    [self setNavgationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    InitTabBarViewController *tabBarController = (InitTabBarViewController *)self.tabBarController;
    [tabBarController showDIYTaBar];
    
    
    [self loadSliderPic];
    [self loadTableList];
    [self initScroll];
    
    [filterBgView removeFromSuperview];
    [self initFilterView];
}

//加载头部刷新
-(void)setHeaderRereshing{
    if(!isHeaderSeted){
        AllAroundPullView *topPullView = [[AllAroundPullView alloc] initWithScrollView:self.peopleTableView position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
            [self performSelector:@selector(callBackMethod:) withObject:@"new" afterDelay:DELAY_TIME];
            [view performSelector:@selector(finishedLoading) withObject:@"old" afterDelay:1.0f];
        }];
        [self.peopleTableView addSubview:topPullView];
        isHeaderSeted = YES;
    }
}

//加底部部刷新
-(void)setFooterRereshing{
    if(!isFooterSeted){
        AllAroundPullView *bottomPullView = [[AllAroundPullView alloc] initWithScrollView:self.peopleTableView position:AllAroundPullViewPositionBottom action:^(AllAroundPullView *view){
            [self performSelector:@selector(callBackMethod:) withObject:nil afterDelay:DELAY_TIME];
            [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:1.0f];
        }];
        [self.peopleTableView addSubview:bottomPullView];
        isFooterSeted = YES;
    }
}

//这是一个模拟方法，请求完成之后，回调方法
-(void)callBackMethod:(id) obj
{
    [self initScroll];
    [self loadTableList];
    [self.peopleTableView reloadData];
}

-(void)initScroll{
    
    scrollView = [[FFScrollView alloc]initPageViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 180) views:sourceArray];
    NSArray *varr = [[scrollView scrollView] subviews];
    for (int i=0; i<varr.count; i++) {
        
        UIImageView *imageView = (UIImageView *)varr[i];
        [imageView setMultipleTouchEnabled:YES];
        [imageView setUserInteractionEnabled:YES];
        
        imageView.tag = i;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        
    }
    
    _peopleTableView.tableHeaderView = scrollView;
}

- (void)tapImage:(UITapGestureRecognizer *)tap{
    
    int tag =  tap.view.tag;
    NSDictionary *slideDic = [slideArr objectAtIndex:tag-1];
    if(slideDic!=nil){
        
        if([StringUitl checkLogin]==TRUE){
            NSString *projectId = [[slideDic valueForKey:@"id"] stringValue];
            PeopleDetailViewController *deatilViewController = (PeopleDetailViewController *)[self getVCFromSB:@"peopleDetail"];
            passValelegate = deatilViewController;
            [passValelegate passValue:projectId];
            [self.navigationController pushViewController:deatilViewController animated:YES];
        }else{
            [StringUitl setSessionVal:@"NAV" withKey:FORWARD_TYPE];
            LoginViewController *loginView = (LoginViewController *)[self getVCFromSB:@"userLogin"];
            [self.navigationController pushViewController:loginView animated:YES];
        }
        
    }
    
}

-(void)setTableData{
    [self loadProjectCats];
    [self loadSliderPic];
    [self loadTableList];
    
    [self initScroll];
}

-(void)loadProjectCats{
    NSString *url = [NSString stringWithFormat:@"%@%@",REMOTE_URL,GET_PROJECT_CATS];
    [self requestDataByUrl:url withType:0];
}

-(void)loadSliderPic{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",REMOTE_URL,SILDER_PEOPLE_URL];
    [self requestDataByUrl:url withType:1];
    
}

-(void)loadTableList{
    
     NSString *url = [NSString stringWithFormat:@"%@%@",REMOTE_URL,PEOPLE_LIST_URL];
    [self requestDataByUrl:url withType:2];
    
}



-(void)requestDataByUrl:(NSString *)url withType:(int)type{
    
    [HttpClient GET:url
         parameters:nil
             isjson:TRUE
            success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        
        commonArr = (NSArray *)responseObject;
        if(commonArr!=nil && commonArr.count>0){
            
            switch (type) {
                case 0:
                    projectsArray = commonArr;
                    [self initFilterView];
                    break;
                case 1:
                    sourceArray = [NSMutableArray arrayWithArray:[commonArr valueForKey:@"imgUrl"]];
                    slideArr = commonArr;
                    [self initScroll];
                    break;
                case 2:
                    _peopleDataList = [NSMutableArray arrayWithArray:commonArr];
                    break;
                default:
                    break;
            }
            
            
            [self setHeaderRereshing];
            [self setFooterRereshing];
            [_peopleTableView reloadData];
            
        }
        
        showflag++;
        if (showflag==3) {
            [friendlyLoadingView removeFromSuperview];
        }
        
        
    }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        
        [self requestFailed:error];
        
    }];
    
}

- (void)requestFailed:(NSError *)error
{
    
    showflag=0;
    NSLog(@"error->%@",error);
    [self initLoading];
    [self showLoading];
    [self showNo:ERROR_INNER];
    
}

#pragma mark 设置组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 设置每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _peopleDataList.count;
}


#pragma mark 行选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转到详情页面
    NSLog(@"go detail......!");
    if(![StringUitl checkLogin]==TRUE){
        [StringUitl setSessionVal:@"NAV" withKey:FORWARD_TYPE];
        LoginViewController *loginView = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginView animated:YES];
    }else{
        cellDic = [self.peopleDataList objectAtIndex:indexPath.row];
        if(cellDic!=nil){

            PeopleDetailViewController *deatilViewController = (PeopleDetailViewController *)[self getVCFromSB:@"peopleDetail"];
            passValelegate = deatilViewController;
            [passValelegate passValue:[cellDic valueForKey:@"id"]];
            [self.navigationController pushViewController:deatilViewController animated:YES];
        }
    }
}

#pragma mark 加载数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PeopleTableViewCell *peopelCell;
    cellDic = [self.peopleDataList objectAtIndex:indexPath.row];
    if(cellDic!=nil){

        static NSString *CustomCellIdentifier = @"PeopelCell";
        peopelCell=  (PeopleTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        
        if (peopelCell == nil) {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"PeopleTableViewCell" owner:self options:nil] ;
            peopelCell = [nib objectAtIndex:0];
        }
        
        peopelCell.selectionStyle =UITableViewCellSelectionStyleNone;
        peopelCell.backgroundColor = [UIColor clearColor];

        NSString *imgUrl =[cellDic valueForKey:@"imgUrl"];
        [peopelCell.bigCellImg md_setImageWithURL:imgUrl placeholderImage:NO_IMG options:SDWebImageRefreshCached];
        
        NSString *stateName;
        NSString *tagPicName;
        int stateNum = [[cellDic valueForKey:@"projectStatus"] intValue];
        //项目状态 1 草稿 2 待审核 3 已审核 4 已成功 5 已失败
        switch (stateNum) {
            case 1:
                stateName = @"未开始";
                tagPicName =@"label_nostart";
                break;
            case 2:
                stateName = @"未开始";
                tagPicName =@"label_nostart";
                break;
            case 3:
                stateName = @"筹款中";
                tagPicName =@"label_fundraising.png";
                break;
            case 4:
                stateName = @"已结束";
                tagPicName =@"lable_success_s.png";
                break;
            default:
                stateName = @"已失败";
                tagPicName =@"lable_success_s.png";
                break;
        }
        
        [peopelCell.tagTitle setText:stateName];
        [peopelCell.tagImgView setImage:[UIImage imageNamed:tagPicName]];
        
        peopelCell.tagTitle.font = main_font(14);
        peopelCell.cellTitle.font = main_font(14);
        peopelCell.cellTitle.text = @"";
        
        titleLabel = [[MarqueeLabel alloc] initWithFrame:peopelCell.cellTitle.frame duration:10.0 andFadeLength:10.0f];
        titleLabel.text = [cellDic valueForKey:@"projectName"];
        titleLabel.textColor = [UIColor blackColor];
        [peopelCell addSubview:titleLabel];
        
        NSString *days =[cellDic valueForKey:@"days"];
        NSString *money = [NSString stringWithFormat:@"%0.1f",[[cellDic valueForKey:@"amount"] doubleValue]];
        NSString *smoney = [NSString stringWithFormat:@"%0.1f",[[cellDic valueForKey:@"totalamount"] doubleValue]];
        NSString *endTime = [cellDic valueForKey:@"endTime"];
        endTime = [endTime substringToIndex:19];
        
        [StringUitl setCornerRadius:peopelCell.moneyTitle withRadius:5.0];
        peopelCell.dateTitle.text = [NSString stringWithFormat:@"目标%@天 剩余%d天",days,[self changeDate:endTime]];
        peopelCell.moneyTitle.text = [NSString stringWithFormat:@"￥%@/￥%@",smoney,money];
        peopelCell.moneyTitle.font = main_font(11);
        //计算百分比
        float amoney = [money floatValue];
        float bmoney;
        if(smoney==nil){
            bmoney = 0;
        }else{
            bmoney = [smoney floatValue];
        }
        
        float percent = bmoney / amoney;
        float imgWith = percent*320;
        
        NSString *perceStr = [NSString stringWithFormat:@"已完成%0.1f%@",percent*100,@"%"];
        peopelCell.percentView.text = perceStr;
        
        UIImage *sourceImage = [UIImage imageNamed:@"progressbar-success.png"];
        UIImage *sourceImage2 = [UIImage imageNamed:@"progressbar-nosuccess.png"];
        if(imgWith!=0){
           UIImage *newImage = [self imageFromImage:sourceImage inRect:CGRectMake(0, 0, imgWith, 10)];
           peopelCell.redProgressView.image = newImage;
        }
        
        UIImage *newImage2 = [self imageFromImage:sourceImage2 inRect:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        peopelCell.blackProgressView.image = newImage2;
        
        peopelCell.redProgressView.contentMode = UIViewContentModeLeft;
        peopelCell.blackProgressView.contentMode = UIViewContentModeScaleToFill;

        [StringUitl setCornerRadius:peopelCell.cellContentView withRadius:5.0];
        [StringUitl setViewBorder:peopelCell.cellContentView withColor:@"#cccccc" Width:0.5f];
        
    }
    return peopelCell;
}

- (double)mxGetStringTimeDiff:(NSString*)timeS timeE:(NSString*)timeE
{
    double timeDiff = 0.0;
    NSDateFormatter *formatters = [[NSDateFormatter alloc]init];
    [formatters setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateS = [formatters dateFromString:timeS];

    NSDateFormatter *formatterE = [[NSDateFormatter alloc]init];
    [formatterE setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateE = [formatterE dateFromString:timeE];
    timeDiff = [dateE timeIntervalSinceDate:dateS];
    
    //单位秒
    return timeDiff;
}

-(int)changeDate:(NSString *)endTime{
    
    DateUtil *dateUtil = [[DateUtil alloc]init];
    NSString *comDate = [dateUtil getLocalDateFormateUTCDate1:endTime];
    double times = [self mxGetStringTimeDiff:[dateUtil getCurDateTimeStr] timeE:comDate];
    times = times/(3600*24);
    NSNumber *numStage =  [NSNumber numberWithDouble:times];
    if([numStage integerValue]<0){
        numStage = 0;
    }
    
    return [numStage intValue];
    
}


- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    return [UIImage imageWithCGImage:newImageRef];
}

@end
