//
//  HomeViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "HomeViewController.h"
#import "InitTabBarViewController.h"

@interface HomeViewController (){
    NSString * dataType;
    NSDictionary *cellDic;
    NSArray *sourceArray;
    FFScrollView *scrollView;
    UIButton *footerBtn;
    CommonViewController *comViewController;
    
    BOOL isHeaderSeted;
    BOOL isFooterSeted;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setTableData];
    self.homeTableView.backgroundColor = [UIColor lightGrayColor];
    
    scrollView = [[FFScrollView alloc]initPageViewWithFrame:CGRectMake(0, 69, 320, 180) views:sourceArray];
    _homeTableView.tableHeaderView = scrollView;
    _homeTableView.rowHeight = 70;
    _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //集成刷新控件
    [self setHeaderRereshing];
    [self setFooterRereshing];
    
    
//    self.navigationController.navigationBarHidden = YES;
//    //处理导航开始
//    UINavigationBar *navgationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, STATU_BAR_HEIGHT, SCREEN_WIDTH, NAV_TITLE_HEIGHT)];
//    [navgationBar setBackgroundImage:[UIImage imageNamed:NAVBAR_BG_ICON] forBarMetrics:UIBarMetricsDefault];
//    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:nil];
//    //处理标题
//    UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 160, 50, 44)];
//    [titleLabel setText:@"长沙星"];
//    [titleLabel setTextColor:[UIColor whiteColor]];
//    [titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [titleLabel setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
//    
//    //设置左边箭头
//    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [rbtn setFrame:CGRectMake(0, 0, 32, 32)];
//    [rbtn setBackgroundImage:[UIImage imageNamed:NAVBAR_RIGHT_ICON] forState:UIControlStateNormal];
//    [rbtn addTarget:self action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rbtn];
//    
//    navItem.titleView = titleLabel;
//    navItem.rightBarButtonItem = rightBtnItem;
//    [navgationBar pushNavigationItem:navItem animated:YES];
//    
//    
//    [self.view addSubview:navgationBar];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    InitTabBarViewController *tabBarController = (InitTabBarViewController *)self.tabBarController;
    [tabBarController showDIYTaBar];
}

-(void)goForward{
    NSLog(@"go");
    UserViewController *userPage = [[UserViewController alloc] init];
    [self.navigationController pushViewController:userPage animated:YES];
    
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



-(void) refreshTableView
{
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:REFRESH_LOADING];
        self.refreshControl.backgroundColor = [UIColor lightTextColor];
        self.refreshControl.alpha = 0.5f;
        //添加新的模拟数据
        NSDate *date = [[NSDate alloc] init];
        //模拟请求完成之后，回调方法callBackMethod
        [self performSelector:@selector(callBackMethod:) withObject:date afterDelay:DELAY_TIME];
    }
}

//这是一个模拟方法，请求完成之后，回调方法
-(void)callBackMethod:(id) obj
{
    [self loadSliderPic];
    [self loadGirlsData];
    [self loadStoryData];
    [self loadPeopleData];
    
    [self.homeTableView reloadData];
}



-(void)loadView{
    [super loadView];
    [self.view addSubview:[self setNavBarWithTitle:@"长沙星" hasLeftItem:NO hasRightItem:YES]];
}



-(void)setTableData{
    
//    NSBundle *manBund = [NSBundle mainBundle];
//    NSString *path = [manBund pathForResource:@"homeDataList" ofType:@"plist"];
//    NSDictionary *myData = [NSDictionary dictionaryWithContentsOfFile:path];
//    
//    NSArray *titleKeys = [myData allKeys];
    
    //NSArray *array1 = [myData valueForKey:@"美女私房"];
    //NSArray *array2 = [myData valueForKey:@"星城故事"];
    //NSArray *array3 = [myData valueForKey:@"活动众筹"];
    //NSArray *array4 = [myData valueForKey:@"朋友圈"];
    
    _headTitleArray = [NSMutableArray arrayWithArray:@[@"美女私房",@"星城故事",@"活动众筹"]];
    //_girlsDataList  = [NSMutableArray arrayWithArray:array1];
    //_peopleDataList = [NSMutableArray arrayWithArray:array2];
    //_friendDataList = [NSMutableArray arrayWithArray:array4];
    //_storyDataList  = [NSMutableArray arrayWithArray:array3];
    //NSLog(@"_girlsDataList==%@",_girlsDataList);
    [self loadSliderPic];
    [self loadGirlsData];
    [self loadStoryData];
    [self loadPeopleData];
    
}

-(void)loadSliderPic{
    
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = @"http://192.168.1.210:8888/cms/GetArticles/slide/3/is_red=1";
    NSArray *slideArr = (NSArray *)[convertJson requestData:url];
    if(slideArr!=nil && slideArr.count>0){
        sourceArray = [NSMutableArray arrayWithArray:[slideArr valueForKey:@"_img_url"]];
    }
    //NSLog(@"sourceArray====%@",sourceArray);
    
    
}

-(void)loadGirlsData{
    
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = @"http://192.168.1.210:8888/cms/GetArticles/girl/1/is_red=1";
    NSArray *girlsArr = (NSArray *)[convertJson requestData:url];
    if(girlsArr!=nil && girlsArr.count>0){
        _girlsDataList = [NSMutableArray arrayWithArray:girlsArr];
    }
    //NSLog(@"_girlsDataList====%@",_girlsDataList);
    
}

-(void)loadStoryData{
    
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = @"http://192.168.1.210:8888/cms/GetArticles/city/1/is_red=1";
    NSArray *storyArr = (NSArray *)[convertJson requestData:url];
    if(storyArr!=nil && storyArr.count>0){
        _storyDataList = [NSMutableArray arrayWithArray:storyArr];
    }
    //NSLog(@"_storyDataList====%@",_storyDataList);
}

-(void)loadPeopleData{
   
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = @"http://192.168.1.210:8888/cms/GetArticles/city/1/is_red=1";
    NSArray *peopleArr = (NSArray *)[convertJson requestData:url];
    if(peopleArr!=nil && peopleArr.count>0){
        _peopleDataList = [NSMutableArray arrayWithArray:peopleArr];
    }
    //NSLog(@"_peopleDataList====%@",_peopleDataList);
    
}


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


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGRect headFrame = CGRectMake(0, 0, 320, 22);
    UIView *sectionHeadView = [[UIView alloc]initWithFrame:headFrame];
    sectionHeadView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbarbg.png"]];
    //设置每组的头部图片
    NSString *imgName = [NSString stringWithFormat:@"header_%d@2x.png",section];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
    [imageView setFrame:CGRectMake(10, 4, 3, 15)];
    //设置每组的标题
    UILabel *headtitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 22)];
    headtitle.text = [_headTitleArray objectAtIndex:section];
    headtitle.font = [UIFont fontWithName:@"Arial" size:14.0f];
    
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
    return 22.0;
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
        case 3:
            return [_friendDataList count];
            break;
        default:
            return 0;
            break;
    }
}

#pragma mark 行选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0){//跳转到美女私房
        NSDictionary *girlCellDic = [self.girlsDataList objectAtIndex:indexPath.row];
        NSString *dataId = [[girlCellDic valueForKey:@"_id"] stringValue];
        NSString *data_Type = [girlCellDic valueForKey:@"_category_call_index"];
        if([self isNotEmpty:dataId] && [data_Type isEqual:@"video"]){
             GirlsVideoViewController *videoView = [[GirlsVideoViewController alloc] init];
             passValelegate = videoView;
            [passValelegate passValue:dataId];
            [self.navigationController presentModalViewController:videoView animated:YES];
        }else{
            
            
            
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
        case 3:
            cellDic = [self.friendDataList objectAtIndex:indexPath.row];
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
        
        NSString *imgUrl =[cellDic valueForKey:@"_img_url"];
        NSLog(@"imgurl==%@",imgUrl);
        NSRange range = [imgUrl rangeOfString:@"/upload/"];
        if(range.location!=NSNotFound){//判断加载远程图像
            UIImage *videImg =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
            [videoCell.videoPic setBackgroundImage:videImg forState:UIControlStateNormal];
        }
        videoCell.videoTitle.text = [cellDic valueForKey:@"_title"];
        
        videoCell.videoDesc.text = [cellDic valueForKey:@"_zhaiyao"];
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
        
        NSString *imgUrl =[cellDic valueForKey:@"_img_url"];
        NSLog(@"imgurl==%@",imgUrl);
        NSRange range = [imgUrl rangeOfString:@"/upload/"];
        if(range.location!=NSNotFound){//判断加载远程图像
            UIImage *videImg =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
            [picCell.picView setBackgroundImage:videImg forState:UIControlStateNormal];
        }
        
        picCell.titleView.text = [cellDic valueForKey:@"_title"];
        [picCell.descView alignTop];
        picCell.descView.text = [cellDic valueForKey:@"_zhaiyao"];
        return picCell;
        
    }
    
}

@end
