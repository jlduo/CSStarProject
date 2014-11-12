//
//  PeopleFilterProjectController.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-25.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "PeopleFilterProjectController.h"

@interface PeopleFilterProjectController (){
    NSDictionary *cellDic;
    NSArray *commonArr;
    MarqueeLabel *titleLabel;
    
    int pageIndex;
    NSString *dataId;
    BOOL isHeaderSeted;
    BOOL isFooterSeted;
    NSInteger selectedCount;
    
    UITableView *peopleTableView;
    XHFriendlyLoadingView *friendlyLoadingView;
    
}

@end

@implementation PeopleFilterProjectController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarController.hidesBottomBarWhenPushed = TRUE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _peopleDataList = [[NSMutableArray alloc]init];
    
    peopleTableView.delegate = self;
    peopleTableView.dataSource = self;
    
    pageIndex = 1;
    [self initLoadData];
    [self initLoading];
    [self loadTableList];
    

    
}

-(void)initLoadData{
    //计算高度
    CGRect tframe = CGRectMake(0, 64, SCREEN_WIDTH,MAIN_FRAME_H-49-44);
    
    peopleTableView = [[UITableView alloc] initWithFrame:tframe];
    peopleTableView.delegate = self;
    peopleTableView.dataSource = self;
    peopleTableView.rowHeight = 300;
    
    peopleTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
    peopleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //隐藏多余的行
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [peopleTableView setTableFooterView:view];
    peopleTableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:peopleTableView];
}

-(void)dealloc{
    cellDic = nil;
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
    [self.view addSubview:[self setNavBarWithTitle:@"活动众筹" hasLeftItem:YES hasRightItem:YES leftIcon:nil rightIcon:nil]];
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
        AllAroundPullView *topPullView = [[AllAroundPullView alloc] initWithScrollView:peopleTableView position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
            [self performSelector:@selector(callBackMethod:) withObject:@"top" afterDelay:DELAY_TIME];
            [view performSelector:@selector(finishedLoading) withObject:@"top" afterDelay:1.0f];
        }];
        [peopleTableView addSubview:topPullView];
        isHeaderSeted = YES;
    }
}

//加底部部刷新
-(void)setFooterRereshing{
    if(!isFooterSeted){
        AllAroundPullView *bottomPullView = [[AllAroundPullView alloc] initWithScrollView:peopleTableView position:AllAroundPullViewPositionBottom action:^(AllAroundPullView *view){
            pageIndex++;
            [self performSelector:@selector(callBackMethod:) withObject:@"foot" afterDelay:DELAY_TIME];
            [view performSelector:@selector(finishedLoading) withObject:@"foot" afterDelay:1.0f];
        }];
        [peopleTableView addSubview:bottomPullView];
        isFooterSeted = YES;
    }
}

//这是一个模拟方法，请求完成之后，回调方法
-(void)callBackMethod:(id) obj
{
    if([obj isEqualToString:@"top"]){
        [self loadMoreData];
    }else{
        [self loadTableList];
    }
    
}

-(void)passDicValue:(NSDictionary *)vals{
    
}

-(void)passValue:(NSString *)val{
    dataId = val;
    NSLog(@"cid=%@",val);
}

-(void)loadTableList{
    NSString *url;
    if([dataId isEqualToString:@"-1"]){
       url = [NSString stringWithFormat:@"%@%@/%@/%d/",REMOTE_URL,GET_PPLIST_URL,CF_PAGESIZE,pageIndex];
    }else{
       url = [NSString stringWithFormat:@"%@%@/%@/%d/%@",REMOTE_URL,GET_PPLIST_URL,CF_PAGESIZE,pageIndex,dataId];
    }
    
    [self requestDataByUrl:url withType:1];
    
}

-(void)loadMoreData{
    int maxId=0;
    NSString *url;
    NSDictionary *dicData = [_peopleDataList objectAtIndex:0];
    if(dicData!=nil){
        maxId = [[dicData valueForKey:@"id"] intValue];
    }
    if([dataId isEqualToString:@"-1"]){
        url = [NSString stringWithFormat:@"%@%@/%d/%@",REMOTE_URL,GET_PPLIST_URL,maxId,@"0"];
    }else{
        url = [NSString stringWithFormat:@"%@%@/%d/%@",REMOTE_URL,GET_MORE_LIST_URL,maxId,dataId];
    }
    
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
    
    NSData *respData = [request responseData];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"jsonDic->%@",jsonDic);
    commonArr = (NSArray *)jsonDic;
    if(commonArr!=nil && commonArr.count>0){
        NSMutableArray *newArr;
        switch (request.tag) {
            case 1:
                [_peopleDataList addObjectsFromArray:commonArr];
                break;
            case 2:
                
                newArr = [[NSMutableArray alloc]init];
                [newArr addObjectsFromArray:commonArr];
                [newArr addObject:_peopleDataList];
                
                _peopleDataList = [[NSMutableArray alloc]init];
                _peopleDataList = newArr;
                break;
                
            default:
                break;
        }
        
        
        
        [self setHeaderRereshing];
        [self setFooterRereshing];
        [peopleTableView reloadData];

    }else{
        [self showHint:@"对不起，没有更多数据了!"];
    }
    [friendlyLoadingView removeFromSuperview];
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
        [peopelCell.bigCellImg md_setImageWithURL:imgUrl placeholderImage:NO_IMG options:SDWebImageRefreshCached];
        
        NSString *stateName;
        NSString *tagPicName;
        int stateNum = [[cellDic valueForKey:@"projectStatus"] intValue];
        //项目状态 1 草稿 2 待审核 3 已审核 4 已成功 5 已失败
        switch (stateNum) {
            case 1:
                stateName = @"未开始";
                tagPicName =@"label_nostart_s2";
                break;
            case 2:
                stateName = @"未开始";
                tagPicName =@"label_nostart_s2";
                break;
            case 3:
                stateName = @"筹款中";
                tagPicName =@"label_fundraising_s2.png";
                break;
            case 4:
                stateName = @"已结束";
                tagPicName =@"label_fundraising_s2.png";
                break;
            default:
                stateName = @"已失败";
                tagPicName =@"lable_success_s2.png";
                break;
        }
        
        [peopelCell.tagTitle setText:stateName];
        [peopelCell.tagImgView setImage:[UIImage imageNamed:tagPicName]];
        
        peopelCell.tagTitle.font = main_font(14);
        peopelCell.cellTitle.font = main_font(14);
        peopelCell.cellTitle.text = @"";
        
        titleLabel = [[MarqueeLabel alloc] initWithFrame:peopelCell.cellTitle.frame duration:15.0 andFadeLength:10.0f];
        titleLabel.text = [cellDic valueForKey:@"projectName"];
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
    return [numStage intValue];
    
}


- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    return [UIImage imageWithCGImage:newImageRef];
}


@end
