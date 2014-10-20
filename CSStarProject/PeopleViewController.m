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
    NSDictionary *cellDic;
    
    BOOL isHeaderSeted;
    BOOL isFooterSeted;
    
}

@end

@implementation PeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setTableData];
    [self initScroll];
    
    _peopleTableView.delegate = self;
    _peopleTableView.dataSource = self;
    
    _peopleTableView.rowHeight = 300;
    _peopleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _peopleTableView.backgroundColor = [StringUitl colorWithHexString:@"#F5F5F5"];
    
    //集成刷新控件
    [self setHeaderRereshing];
    [self setFooterRereshing];
    
   
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

    [self.peopleTableView reloadData];
}

-(void)initScroll{
    scrollView = [[FFScrollView alloc]initPageViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 180) views:sourceArray];
    NSLog(@"subviws==%d",[[scrollView scrollView] subviews].count);
    
    NSArray *varr = [[scrollView scrollView] subviews];
    for (int i=0; i<varr.count; i++) {
        
        UIImageView *imageView = (UIImageView *)varr[i];
         NSLog(@"arr=%@",imageView.image);
        [imageView setMultipleTouchEnabled:YES];
        [imageView setUserInteractionEnabled:YES];
        
        imageView.tag = i;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        
    }
    
    _peopleTableView.tableHeaderView = scrollView;
}

- (void)tapImage:(UITapGestureRecognizer *)tap{
    
    int tag =  tap.view.tag;
    NSLog(@"index==%d",tag);
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
    
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@%@",REMOTE_URL,SILDER_PEOPLE_URL];
    slideArr = (NSArray *)[convertJson requestData:url];
    if(slideArr!=nil && slideArr.count>0){
        sourceArray = [NSMutableArray arrayWithArray:[slideArr valueForKey:@"imgUrl"]];
    }
    
    NSLog(@"slideArr2====%@",slideArr);
    NSLog(@"sourceArray2====%@",sourceArray);
    
}

-(void)loadTableList{
    
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@%@",REMOTE_URL,PEOPLE_LIST_URL];
    NSArray *peopleArr = (NSArray *)[convertJson requestData:url];
    if(peopleArr!=nil && peopleArr.count>0){
        _peopleDataList = [NSMutableArray arrayWithArray:peopleArr];
    }
    NSLog(@"_peopleDataList====%@",_peopleDataList);
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
    cellDic = [self.peopleDataList objectAtIndex:indexPath.row];
    if(cellDic!=nil){
        PeopleDetailViewController *deatilViewController = [[PeopleDetailViewController alloc]init];
        passValelegate = deatilViewController;
        [passValelegate passValue:[cellDic valueForKey:@"id"]];
        [self.navigationController pushViewController:deatilViewController animated:YES];
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
            [peopelCell.bigCellImg setImageWithURL:[NSURL URLWithString:imgUrl]
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
        
        
        peopelCell.cellTitle.font = TITLE_FONT;
        peopelCell.cellTitle.text = [cellDic valueForKey:@"projectName"];
        NSString *days =[cellDic valueForKey:@"days"];
        NSString *money = [cellDic valueForKey:@"amount"];
        NSString *smoney = [cellDic valueForKey:@"totalamount"];
        NSString *endTime = [cellDic valueForKey:@"endTime"];
        endTime = [endTime substringToIndex:19];
        
        peopelCell.moneyTitle.layer.masksToBounds = YES;
        peopelCell.moneyTitle.layer.cornerRadius = 5;
        peopelCell.dateTitle.text = [NSString stringWithFormat:@"目标%@天 剩余%@天",days,[self changeDate:endTime]];
        peopelCell.moneyTitle.text = [NSString stringWithFormat:@"￥%@ / ￥%@",smoney,money];
        //计算百分比
        float amoney = [money floatValue];
        float bmoney;
        if(smoney==nil){
            bmoney = 0;
        }else{
            bmoney = [smoney floatValue];
        }
        
        float percent = bmoney / amoney;
        float imgWith = percent*616;
        
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

-(NSString *)changeDate:(NSString *)endTime{
    
    DateUtil *dateUtil = [[DateUtil alloc]init];
    NSString *comDate = [dateUtil getLocalDateFormateUTCDate1:endTime];
    double times = [self mxGetStringTimeDiff:[dateUtil getCurDateTimeStr] timeE:comDate];
    times = times/(3600*24);
    NSNumber *numStage =  [NSNumber numberWithDouble:times];
    NSString *numStr = [NSString stringWithFormat:@"%0.0lf",[numStage doubleValue]];
    return numStr;
    
}


- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

@end
