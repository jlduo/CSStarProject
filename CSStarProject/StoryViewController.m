//
//  StoryViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "StoryViewController.h"

@interface StoryViewController (){
    NSString * dataType;
    NSDictionary *cellDic;
    DateUtil *dateUtil;
    CommonViewController *comViewController;
    NSInteger addDateCount;
    
    BOOL isHeaderSeted;
    BOOL isFooterSeted;
}

@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    addDateCount = 1;
    dateUtil = [[DateUtil alloc] init];
    [self setTableData];
    
    //self.storyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

//加载头部刷新
-(void)setHeaderRereshing{
    if(!isHeaderSeted){
        AllAroundPullView *topPullView = [[AllAroundPullView alloc] initWithScrollView:self.storyTableView position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
            NSLog(@"up-");
            [self performSelector:@selector(callBackMethod:) withObject:nil afterDelay:DELAY_TIME];
            [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:1.0f];
        }];
        [self.storyTableView addSubview:topPullView];
        isHeaderSeted = YES;
    }
}

//加底部部刷新
-(void)setFooterRereshing{
    if(!isFooterSeted){
        AllAroundPullView *bottomPullView = [[AllAroundPullView alloc] initWithScrollView:self.storyTableView position:AllAroundPullViewPositionBottom action:^(AllAroundPullView *view){
            NSLog(@"down-");
            [self performSelector:@selector(callBackMethod:) withObject:nil afterDelay:DELAY_TIME];
            [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:1.0f];
        }];
        [self.storyTableView addSubview:bottomPullView];
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

//请求完成之后，回调方法
-(void)callBackMethod:(id) obj
{
    NSDate *olderDate = [NSDate dateWithTimeIntervalSinceNow: -(24 * 60 * 60)*addDateCount];
    NSString *filter = [dateUtil date2StringWithFomat:SIMPLE_DATE_FORMATER WithDate:olderDate];
    NSArray *addArray = [self getDataWithFilter:filter];
    if(addArray!=nil && addArray.count>0){
       [_storyDataList addObject:addArray];
    }
    //根据数据判断是否加载刷新组件
    if(_storyDataList!=nil && _storyDataList.count>1){
        //集成刷新控件
        [self setFooterRereshing];//有2条数据后加载底部刷新
        _storyTableView.backgroundColor = [UIColor lightGrayColor];
    }
    
    addDateCount++;
    [self.storyTableView reloadData];
}



-(void)loadView{
    [super loadView];
    [self.view addSubview:[self setNavBarWithTitle:@"星城故事" hasLeftItem:NO hasRightItem:YES leftIcon:nil rightIcon:nil]];
}

//获取数据
-(NSArray *)getDataWithFilter:(NSString *)filter{
    NSBundle *manBund = [NSBundle mainBundle];
    NSString *path = [manBund pathForResource:@"storyDataList" ofType:@"plist"];
    NSMutableArray *myData = [NSMutableArray arrayWithContentsOfFile:path];
    
    NSString *fomat = [NSString stringWithFormat:@"self.pubdate BEGINSWITH '%@'",filter];
    NSPredicate *dataPredicate = [NSPredicate predicateWithFormat:fomat];
    NSArray *filterArray = [myData filteredArrayUsingPredicate:dataPredicate];
    
    return filterArray;
}

-(void)setTableData{
    
    NSBundle *manBund = [NSBundle mainBundle];
    NSString *path = [manBund pathForResource:@"storyDataList" ofType:@"plist"];
    NSMutableArray *myData = [NSMutableArray arrayWithContentsOfFile:path];
    
    NSString *filter = [dateUtil getCurDateWithFormat:SIMPLE_DATE_FORMATER];
    NSLog(@"filter=%@",filter);
    NSString *fomat = [NSString stringWithFormat:@"self.pubdate BEGINSWITH '%@'",filter];
    NSPredicate *dataPredicate = [NSPredicate predicateWithFormat:fomat];
    NSArray *filterArray = [myData filteredArrayUsingPredicate:dataPredicate];
    
    _storyDataList = [[NSMutableArray alloc]init];
    if(filterArray!=nil&&filterArray.count>0){
      [_storyDataList addObject:filterArray];
    }
    
    [self setHeaderRereshing];
    
    
    NSLog(@"_storyDataList==%@",_storyDataList);
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    

    UIView *sectionHeadView;
    NSArray *sarray = [_storyDataList objectAtIndex:section];
    if(sarray!=nil && sarray.count>0){
        CGRect headFrame = CGRectMake(0, 0, SCREEN_WIDTH, 35);
        sectionHeadView = [[UIView alloc]initWithFrame:headFrame];
        //sectionHeadView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbarbg.png"]];
        
        sectionHeadView.backgroundColor = [UIColor whiteColor];
        //设置每组的标题
        UILabel *headtitle = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, 3, 80, 20)];
        headtitle.backgroundColor = [UIColor lightGrayColor];
        
        NSDictionary *cellData = (NSDictionary *)[sarray objectAtIndex:0];
        headtitle.text = [[cellData valueForKey:@"pubdate"] substringToIndex:10];
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
    
    NSLog(@"cellHeight==%f",cellHeight);
    
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
        
        UIImage *picImg =[UIImage imageNamed:[cellDic valueForKey:@"pic"]];
        [storyBDCell.imgView setBackgroundImage:picImg forState:UIControlStateNormal];
        
        //storyBDCell.dateView.text = [[cellDic valueForKey:@"pubdate"] substringToIndex:10];
        storyBDCell.titleView.text = [cellDic valueForKey:@"title"];
        storyBDCell.descView.text = [cellDic valueForKey:@"desc"];
        
        return storyBDCell;
        
    }else{
        NSLog(@"rowIndex==%d",indexPath.row);
        if(indexPath.row==0){//处理第一条数据
            NSLog(@"cell11111");
            static BOOL isNibregistered = NO;
            if(!isNibregistered){
                UINib *nibCell = [UINib nibWithNibName:@"StoryTableViewBigCell" bundle:nil];
                [tableView registerNib:nibCell forCellReuseIdentifier:@"StoryBCell"];
                isNibregistered = YES;
            }
            
            StoryTableViewBigCell *storyBCell = [_storyTableView dequeueReusableCellWithIdentifier:@"StoryBCell"];
            storyBCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            UIImage *picImg =[UIImage imageNamed:[cellDic valueForKey:@"pic"]];
            [storyBCell.cellImgView setBackgroundImage:picImg forState:UIControlStateNormal];
            
            //storyBCell.cellTitle.text = [[cellDic valueForKey:@"pubdate"] substringToIndex:10];
            storyBCell.imgTitle.text = [cellDic valueForKey:@"title"];
            
            return storyBCell;
            
        }else{//处理基本列数据
             NSLog(@"cell22222222");
            static BOOL isNibregistered = NO;
            if(!isNibregistered){
                UINib *nibCell = [UINib nibWithNibName:@"StoryTableViewSmallCell" bundle:nil];
                [tableView registerNib:nibCell forCellReuseIdentifier:@"StorySMCell"];
                isNibregistered = YES;
            }
            
            StoryTableViewSmallCell *storySMCell = [_storyTableView dequeueReusableCellWithIdentifier:@"StorySMCell"];
            storySMCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImage *picImg =[UIImage imageNamed:[cellDic valueForKey:@"pic"]];
            [storySMCell.cellImg setImage:picImg];
            storySMCell.cellTitle.text = [cellDic valueForKey:@"title"];
            
            return storySMCell;

        }
    
    }
    
}


@end
