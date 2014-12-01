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
    XHFriendlyLoadingView *friendlyLoadingView;
    
    int showflag;
}

@end

@implementation StoryViewController 

- (void)viewDidLoad {
    [super viewDidLoad];

    pageIndex = 1;
    [self initLoading];
    [self setTableData];
    self.storyTableView.showsVerticalScrollIndicator = NO;
    _storyTableView.backgroundColor = [StringUitl colorWithHexString:@"#F5F5F5"];
    _storyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)initLoading{
    if(friendlyLoadingView==nil){
        friendlyLoadingView = [[XHFriendlyLoadingView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, MAIN_FRAME_H)];
    }
    __weak typeof(self) weakSelf = self;
    friendlyLoadingView.reloadButtonClickedCompleted = ^(UIButton *sender) {
        [weakSelf loadTableData:nil];
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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    InitTabBarViewController *tabBarController = (InitTabBarViewController *)self.tabBarController;
    [tabBarController showDIYTaBar];
    
    [self loadTableData:nil];
    [_storyTableView reloadData];
}

//加载头部刷新
-(void)setHeaderRereshing{
    NSLog(@"up-");
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
    [self loadTableData:isTop];
}

-(void)loadTableData:(id)isTop{
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@/cms/GetArticleList/city/0/6/%d",REMOTE_URL,pageIndex];
    int k = 0;
    if([isTop isEqualToString:@"top"]){
        k=1;
    }else if([isTop isEqualToString:@"foot"]){
        k=2;
    }else{
        k=0;
    }
    [self requestDataByUrl:url withType:k];
    
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"星城故事" hasLeftItem:NO hasRightItem:YES  leftIcon:nil rightIcon:nil]];
} 

-(void)setTableData{
    [self loadTableData:nil];
    [self setHeaderRereshing];
    [self setFooterRereshing];
}


-(void)requestDataByUrl:(NSString *)url withType:(int)type{
    
    [HttpClient GET:url parameters:nil isjson:TRUE
            success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                
                NSArray *nextArray = (NSArray *)responseObject;
                if(nextArray!=nil && nextArray.count>0){
                    if (type==0) {
                        
                        _storyDataList = [[NSMutableArray alloc] initWithArray:nextArray];
                        
                    }else if(type==1){
                        
                        _storyDataList = [[NSMutableArray alloc] initWithArray:nextArray];
                        
                    }else{
                        
                        [_storyDataList  addObjectsFromArray:nextArray];
                        
                    }
                }
                
                [_storyTableView reloadData];
                showflag++;
                if (showflag==1) {
                    [friendlyLoadingView removeFromSuperview];
                }
                
                
            }
     
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                [self requestFailed:error];
                
            }
     ];
    
}

- (void)requestFailed:(NSError *)error
{

    NSLog(@"error=%@",error);
    showflag = 0;
    [self initLoading];
    [self setHeaderRereshing];
    [self showLoading];
    //[self showNo:@"请求失败,网络错误!"];
    
}


                                             
#pragma mark 行选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{ 
    
    
    NSDictionary *row = [_storyDataList objectAtIndex:indexPath.row];
    NSString *rowId = [row valueForKey:@"_id"];
    
    if(![StringUitl checkLogin]==TRUE){
        
        [StringUitl setSessionVal:@"NAV" withKey:FORWARD_TYPE];
        LoginViewController *loginView = (LoginViewController *)[self getVCFromSB:@"userLogin"];
        [self.navigationController pushViewController:loginView animated:YES];
        
    }else{
    
        StoryDetailViewController *detailController = (StoryDetailViewController *)[self getVCFromSB:@"storyDetail"];
        delegate = detailController;
        [delegate passValue:rowId];
        [self.navigationController pushViewController:detailController animated:YES];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _storyDataList .count;
}

#pragma mark 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *parray = [_storyDataList objectAtIndex:indexPath.row];
    NSString * isTop =[[NSString alloc] initWithFormat:@"%@",[parray valueForKey:@"_is_red"]];
    NSInteger height = 80;
    if ([isTop isEqualToString:@"1"]) {
        height = 200;
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
        storySMCell.backgroundColor = [UIColor clearColor];
        storySMCell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        NSString *imgUrl = [parray valueForKey:@"_img_url"];
        [storySMCell.cellImg md_setImageWithURL:imgUrl placeholderImage:NO_IMG options:SDWebImageRefreshCached];
        storySMCell.cellTitle.font = DESC_FONT;
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
        
        storyBCell.backgroundColor = [UIColor clearColor];
        storyBCell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        NSString *imgUrl = [parray valueForKey:@"_img_url"];
        [storyBCell.cellImgView md_setImageWithURL:imgUrl placeholderImage:NO_IMG options:SDWebImageRefreshCached];
        storyBCell.imgTitle.font = DESC_FONT;
        storyBCell.imgTitle.text = [parray valueForKey:@"_title"];
        
        return storyBCell;
    }
}
@end
