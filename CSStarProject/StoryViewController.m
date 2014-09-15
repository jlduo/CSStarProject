//
//  StoryViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "StoryViewController.h"
#import "ConvertJSONData.h"
#import "DateUtil.h"
#import "InitTabBarViewController.h"
#import "StoryDetailViewController.h"

@interface StoryViewController (){
    NSString * dataType;
    NSString *nowUpTime;
    NSString *nowDownTime;
    NSDictionary *cellDic;
    DateUtil *dateUtil;
    CommonViewController *comViewController;
    
    BOOL isHeaderSeted;
    BOOL isFooterSeted;
}

@end

@implementation StoryViewController

-(void)passValue:(NSString *)val{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self setTableData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    InitTabBarViewController *tabBarController = (InitTabBarViewController *)self.tabBarController;
    [tabBarController showDIYTaBar];
}

//加载头部刷新
-(void)setHeaderRereshing{
    if(!isHeaderSeted){
        AllAroundPullView *topPullView = [[AllAroundPullView alloc] initWithScrollView:self.storyTableView position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
            
            nowUpTime = [self getTimeString:nowUpTime TimeInterval:3600*24];
            
            [self performSelector:@selector(callBackMethod:) withObject:nowUpTime afterDelay:DELAY_TIME];
            [view performSelector:@selector(finishedLoading) withObject:nowUpTime afterDelay:1.0f];
        }];
        [self.storyTableView addSubview:topPullView];
        isHeaderSeted = YES;
    }
}

//加底部部刷新
-(void)setFooterRereshing{
    if(!isFooterSeted){
        AllAroundPullView *bottomPullView = [[AllAroundPullView alloc] initWithScrollView:self.storyTableView position:AllAroundPullViewPositionBottom action:^(AllAroundPullView *view){
            
            nowDownTime = [self getTimeString:nowDownTime TimeInterval:-3600*24];
            
            [self performSelector:@selector(callBackMethod:) withObject:nowDownTime afterDelay:DELAY_TIME];
            [view performSelector:@selector(finishedLoading) withObject:nowDownTime afterDelay:1.0f];
        }];
        [self.storyTableView addSubview:bottomPullView];
        isFooterSeted = YES;
    }
}

//计算时间
-(NSString *)getTimeString:(NSString *)timeString TimeInterval:(double)timeInterval{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[dateFormatter dateFromString:timeString];
    date = [date dateByAddingTimeInterval:timeInterval];
    
    DateUtil *dateString = [[DateUtil alloc] init];
    return  [dateString date2StringWithFomat:@"yyyy-MM-dd" WithDate:date];
}

//请求完成之后，回调方法
-(void)callBackMethod:(id) obj
{
    ConvertJSONData *jsonData = [[ConvertJSONData alloc] init];
    NSString *url = [[NSString alloc] initWithFormat:@"http://192.168.1.210:8888/cms/GetArticlesByDate/city/%@/0",obj];
    NSMutableArray *addArray = (NSMutableArray *)[jsonData requestData:url];
    if(addArray!=nil && addArray.count>0){
       [_storyDataList addObject:addArray];
        //集成刷新控件
        [self setFooterRereshing];//有2条数据后加载底部刷新
        _storyTableView.backgroundColor = [UIColor lightGrayColor];
        [self.storyTableView reloadData];
    }
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



-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"星城故事" hasLeftItem:NO hasRightItem:YES]];
} 

-(void)setTableData{
    ConvertJSONData *jsonData = [[ConvertJSONData alloc] init];
    NSMutableArray *array = (NSMutableArray *)[jsonData requestData:@"http://192.168.1.210:8888/cms/GetArticlesByDate/city/0/0"];
 
    //获取接口数据的日期时间
    NSDictionary *firstDic = [array objectAtIndex:0];
    nowUpTime = [[firstDic valueForKey:@"_add_time"] substringToIndex:10];
    nowDownTime = nowUpTime;
    
    _storyDataList = [[NSMutableArray alloc] init];
    [_storyDataList addObject:array];
    [self setHeaderRereshing];
    [self setFooterRereshing];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeadView;
    NSArray *sarray = [_storyDataList objectAtIndex:section];
    if(sarray!=nil && sarray.count>0){
        CGRect headFrame = CGRectMake(0, 0, SCREEN_WIDTH, 35);
        sectionHeadView = [[UIView alloc]initWithFrame:headFrame];
        sectionHeadView.backgroundColor = [UIColor whiteColor];
        //设置每组的标题
        UILabel *headtitle = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, 3, 80, 20)];
        headtitle.backgroundColor = [UIColor lightGrayColor];
        
        NSDictionary *cellData = (NSDictionary *)[sarray objectAtIndex:0];
        headtitle.text = [[cellData valueForKey:@"_add_time"] substringToIndex:10];
        headtitle.font = [UIFont fontWithName:@"Arial" size:13.0f];
        headtitle.textColor = [UIColor whiteColor];
        headtitle.textAlignment = NSTextAlignmentCenter;
        
        [sectionHeadView addSubview:headtitle];
    }
    
    return sectionHeadView;
}


#pragma mark 设置组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _storyDataList.count;
}

#pragma mark 设置组高度
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25.0;
}

#pragma mark 设置每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *sarray = [_storyDataList objectAtIndex:section];
    return sarray.count;
}

#pragma mark 行选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{ 
    NSDictionary *row = [[_storyDataList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *rowId = [row valueForKey:@"_id"];
    
    StoryDetailViewController *detailController = [[StoryDetailViewController alloc] init];
    delegate = detailController;
    [delegate passValue:rowId];
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight=0.0f;
    NSArray *parray = [_storyDataList objectAtIndex:indexPath.section];
    if (parray==nil) {
        return cellHeight;
    }
    NSInteger dataCount = parray.count;
    if(dataCount==0){
        cellHeight = 25.0f;
    }
    if(indexPath.row==0){
        if(dataCount==1){
            cellHeight = 260.0f;
        }
        if(dataCount>1){
            cellHeight = 200.0f;
        }
    }else{
            cellHeight = 50.0f;
    }
    return cellHeight;
}


#pragma mark 加载数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{ 
    NSArray *parray = [_storyDataList objectAtIndex:indexPath.section];
    if(parray.count==0){
       UITableViewCell *nilCell = [[UITableViewCell alloc]init];
       nilCell.textLabel.text = @"对不起，没有查询到任何数据！";
       return nilCell;
    }
    cellDic = [parray objectAtIndex:indexPath.row];
    //处理数据 如果当天只有一条数据
    if(parray.count==1){
        static BOOL isNibregistered = NO;
        if(!isNibregistered){
            UINib *nibCell = [UINib nibWithNibName:@"StoryTableViewBigDescCell" bundle:nil];
            [tableView registerNib:nibCell forCellReuseIdentifier:@"StoryBDCell"];
            isNibregistered = YES;
        }
        
        StoryTableViewBigDescCell *storyBDCell = [_storyTableView dequeueReusableCellWithIdentifier:@"StoryBDCell"];
        storyBDCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *imgUrl = [cellDic valueForKey:@"_img_url"];
        UIImage *picImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
        [storyBDCell.imgView setBackgroundImage:picImg forState:UIControlStateNormal];
        
        storyBDCell.titleView.text = [cellDic valueForKey:@"_title"];
        storyBDCell.descView.text = [cellDic valueForKey:@"_zhaiyao"];
        
        return storyBDCell;
        
    }else{
        if(indexPath.row==0){//处理第一条数据
            static BOOL isNibregistered = NO;
            if(!isNibregistered){
                UINib *nibCell = [UINib nibWithNibName:@"StoryTableViewBigCell" bundle:nil];
                [tableView registerNib:nibCell forCellReuseIdentifier:@"StoryBCell"];
                isNibregistered = YES;
            }
            
            StoryTableViewBigCell *storyBCell = [_storyTableView dequeueReusableCellWithIdentifier:@"StoryBCell"];
            storyBCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            NSString *imgUrl = [cellDic valueForKey:@"_img_url"];
            UIImage *picImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
            [storyBCell.cellImgView setBackgroundImage:picImg forState:UIControlStateNormal];
            
            storyBCell.imgTitle.text = [cellDic valueForKey:@"_title"];
            
            return storyBCell;
            
        }else{//处理基本列数据
            static BOOL isNibregistered = NO;
            if(!isNibregistered){
                UINib *nibCell = [UINib nibWithNibName:@"StoryTableViewSmallCell" bundle:nil];
                [tableView registerNib:nibCell forCellReuseIdentifier:@"StorySMCell"];
                isNibregistered = YES;
            }
            
            StoryTableViewSmallCell *storySMCell = [_storyTableView dequeueReusableCellWithIdentifier:@"StorySMCell"];
            storySMCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSString *imgUrl = [cellDic valueForKey:@"_img_url"];
            UIImage *picImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
            [storySMCell.cellImg setImage:picImg];
            storySMCell.cellTitle.text = [cellDic valueForKey:@"_title"];
            
            return storySMCell;

        }
    
    }
    
}


@end
