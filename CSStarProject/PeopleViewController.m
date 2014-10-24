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
    NSArray *slideArr;
    NSArray *commonArr;
    NSDictionary *cellDic;
    
    BOOL isHeaderSeted;
    BOOL isFooterSeted;
    
    NSInteger selectedCount;
    XHFriendlyLoadingView *friendlyLoadingView;
    
}

@end

@implementation PeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self initLoading];
    [self setTableData];
    [self initScroll];
    
    _peopleTableView.delegate = self;
    _peopleTableView.dataSource = self;
    
    _peopleTableView.rowHeight = 300;
    _peopleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _peopleTableView.backgroundColor = [StringUitl colorWithHexString:@"#F5F5F5"];
    
    //集成刷新控件
//    [self setHeaderRereshing];
//    [self setFooterRereshing];
    
   
}

-(void)dealloc{
    cellDic = nil;
    sourceArray = nil;
    slideArr = nil;
    commonArr = nil;
    scrollView = nil;
    friendlyLoadingView = nil;
}

-(void)initLoading{
    if(friendlyLoadingView==nil){
        friendlyLoadingView = [[XHFriendlyLoadingView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, MAIN_FRAME_H)];
    }
    __weak typeof(self) weakSelf = self;
    friendlyLoadingView.reloadButtonClickedCompleted = ^(UIButton *sender) {
        [weakSelf loadTableList];
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


-(void)loadView{
    [super loadView];
    [self.view addSubview:[self setNavBarWithTitle:@"活动众筹" hasLeftItem:NO hasRightItem:YES leftIcon:nil rightIcon:nil]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    InitTabBarViewController *tabBarController = (InitTabBarViewController *)self.tabBarController;
    [tabBarController showDIYTaBar];
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
        NSString *projectId = [[slideDic valueForKey:@"id"] stringValue];
        PeopleDetailViewController *deatilViewController = [[PeopleDetailViewController alloc]init];
        passValelegate = deatilViewController;
        [passValelegate passValue:projectId];
        [self.navigationController pushViewController:deatilViewController animated:YES];
    }
    
}

-(void)setTableData{
    [self loadSliderPic];
    [self loadTableList];
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
    NSLog(@"jsonDic->%@",jsonDic);
    commonArr = (NSArray *)jsonDic;
    if(commonArr!=nil && commonArr.count>0){
        
        switch (request.tag) {
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

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [friendlyLoadingView removeFromSuperview];
        });
    }
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
            PeopleDetailViewController *deatilViewController = [[PeopleDetailViewController alloc]init];
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
        //NSLog(@"imgurl==%@",imgUrl);
        NSRange range = [imgUrl rangeOfString:@"/upload/"];
        if(range.location!=NSNotFound){//判断加载远程图像
            //改写异步加载图片
            [peopelCell.bigCellImg sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                               placeholderImage:[UIImage imageNamed:NOIMG_ICON] options:SDWebImageRefreshCached];
        }
        
        NSString *stateName;
        NSString *tagPicName;
        int stateNum = [[cellDic valueForKey:@"projectStatus"] intValue];
        switch (stateNum) {
            case 2:
                stateName = @"未开始";
                tagPicName =@"label_nostart";
                break;
            case 3:
                stateName = @"筹款中";
                tagPicName =@"label_fundraising.png";
                break;
            default:
                stateName = @"已结束";
                tagPicName =@"lable_success.png";
                break;
        }
        
        [peopelCell.tagTitle setText:stateName];
        [peopelCell.tagImgView setImage:[UIImage imageNamed:tagPicName]];
        
        peopelCell.tagTitle.font = main_font(14);
        peopelCell.cellTitle.font = main_font(14);
        peopelCell.cellTitle.text = [cellDic valueForKey:@"projectName"];
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
        float imgWith = percent*320-20;
        
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
    return [numStage intValue];
    
}


- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

@end
