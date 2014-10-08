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
    NSInteger pageIndex;
}

@end

@implementation StoryViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    pageIndex = 1;
    [self setTableData];
    
    _storyTableView.backgroundColor = [StringUitl colorWithHexString:@"#F5F5F5"];
    _storyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    AllAroundPullView *topPullView = [[AllAroundPullView alloc] initWithScrollView:_storyTableView position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
        pageIndex = 1;
        [self performSelector:@selector(callBackMethod:) withObject:@"top" afterDelay:DELAY_TIME];
        [view performSelector:@selector(finishedLoading) withObject:@"top" afterDelay:1.0f];
    }];
    [_storyTableView addSubview:topPullView];
}

//加底部部刷新
-(void)setFooterRereshing{
    AllAroundPullView *bottomPullView = [[AllAroundPullView alloc] initWithScrollView:_storyTableView position:AllAroundPullViewPositionBottom action:^(AllAroundPullView *view){
        pageIndex++;
        [self performSelector:@selector(callBackMethod:) withObject:@"foot" afterDelay:DELAY_TIME];
        [view performSelector:@selector(finishedLoading) withObject:@"foot" afterDelay:1.0f];
    }];
    [_storyTableView addSubview:bottomPullView];
}

//请求完成之后，回调方法
-(void)callBackMethod:(id) isTop
{
    ConvertJSONData *jsonData = [[ConvertJSONData alloc] init];
    NSString *url = [[NSString alloc] initWithFormat:@"%@/cms/GetArticleList/city/0/6/%d",REMOTE_URL,pageIndex];
    NSMutableArray *nextArray = (NSMutableArray *)[jsonData requestData:url];
    
    if(nextArray!=nil && nextArray.count>0){
        if ([isTop isEqualToString:@"top"]) {
            _storyDataList  = nextArray;
        } else {
            [_storyDataList  addObjectsFromArray:nextArray];
        }
        [_storyTableView reloadData];
    }else{
        [self showCustomAlert:@"没有数据了！" widthType:WARNN_LOGO];
    }
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"星城故事" hasLeftItem:NO hasRightItem:YES  leftIcon:nil rightIcon:nil]];
} 

-(void)setTableData{
    ConvertJSONData *jsonData = [[ConvertJSONData alloc] init];
    NSString *url = [[NSString alloc] initWithFormat:@"%@/cms/GetArticleList/city/0/6/%d",REMOTE_URL,pageIndex];
 
    _storyDataList = [[NSMutableArray alloc] init];
    _storyDataList = (NSMutableArray *)[jsonData requestData:url]; 
    [self setHeaderRereshing];
    [self setFooterRereshing];
}
                                             
#pragma mark 行选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{ 
    NSDictionary *row = [_storyDataList objectAtIndex:indexPath.row];
    NSString *rowId = [row valueForKey:@"_id"];
    
    StoryDetailViewController *detailController = [[StoryDetailViewController alloc] init];
    delegate = detailController;
    [delegate passValue:rowId];
    [self.navigationController pushViewController:detailController animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _storyDataList .count;
}

#pragma mark 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *parray = [_storyDataList objectAtIndex:indexPath.row];
    NSString * isTop =[[NSString alloc] initWithFormat:@"%@",[parray valueForKey:@"_is_red"]];
    NSInteger height = 75;
    if ([isTop isEqualToString:@"1"]) {
        height = 190;
    }
    return height;
}


#pragma mark 加载数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{ 
    NSDictionary *parray = [_storyDataList objectAtIndex:indexPath.row];
    NSString * isTop =[[NSString alloc] initWithFormat:@"%@",[parray valueForKey:@"_is_red"]];
    if ([isTop isEqualToString:@"0"]) {
        static BOOL isNibregistered = NO;
        if(!isNibregistered){
            UINib *nibCell = [UINib nibWithNibName:@"StoryTableViewSmallCell" bundle:nil];
            [tableView registerNib:nibCell forCellReuseIdentifier:@"StorySMCell"];
            isNibregistered = YES;
        }
        
        StoryTableViewSmallCell *storySMCell = [_storyTableView dequeueReusableCellWithIdentifier:@"StorySMCell"];
        storySMCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *imgUrl = [parray valueForKey:@"_img_url"];
        UIImage *picImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
        storySMCell.cellImg.image = picImg;
        storySMCell.cellTitle.text = [parray valueForKey:@"_title"];
        
        return storySMCell;

    }else{
        static BOOL isNibregistered = NO;
        if(!isNibregistered){
            UINib *nibCell = [UINib nibWithNibName:@"StoryTableViewBigCell" bundle:nil];
            [tableView registerNib:nibCell forCellReuseIdentifier:@"StoryBCell"];
            isNibregistered = YES;
        }
        StoryTableViewBigCell *storyBCell = [_storyTableView dequeueReusableCellWithIdentifier:@"StoryBCell"];
        storyBCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *imgUrl = [parray valueForKey:@"_img_url"];
        UIImage *picImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
        storyBCell.cellImgView.image = picImg;
        
        storyBCell.imgTitle.text = [parray valueForKey:@"_title"];
        
        return storyBCell;

    }
}

-(void)showCustomAlert:(NSString *)msg widthType:(NSString *)tp{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:tp]];
    //[imgView setFrame:CGRectMake(0, 0, 48, 48)];
    HUD.customView = imgView;
    
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.labelText = msg;
    HUD.dimBackground = YES;
	 
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
}
@end
