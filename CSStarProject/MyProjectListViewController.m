//
//  MyProjectListViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-13.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "MyProjectListViewController.h"

@interface MyProjectListViewController (){
    UITableView *proListTableView;
    NSDictionary *cellDic;
    NSString *dataId;
    NSString *titleName;
    NSDictionary *params;
    int cellIndex;
    
    UIImageView *BtnIcon1;
    UIImageView *BtnIcon2;
    UIImageView *BtnIcon3;
    
    int current_index;
}

@end

@implementation MyProjectListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self showLoading:@"加载中..."];
        self.tabBarController.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)dealloc{
    [self releaseDMemery];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [self releaseDMemery];
}

-(void)releaseDMemery{
    BtnIcon3 = nil;
    BtnIcon1 = nil;
    BtnIcon2 = nil;
    BtnIcon3 = nil;
    params = nil;
    titleName = nil;
    dataId = nil;
    cellDic= nil;
    proListTableView= nil;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    dataId = [StringUitl getSessionVal:LOGIN_USER_ID];
    [self.view setBackgroundColor:[StringUitl colorWithHexString:CONTENT_BACK_COLOR]];
    
    [self initLoadData];
    [self initTopView];
    [self loadTableList:1];
    current_index = 1;
}

//传递过来的参数
-(void)passValue:(NSString *)val{

}

-(void)passDicValue:(NSDictionary *)vals{
    
}

-(void)initLoadData{
    //计算高度
    CGRect tframe = CGRectMake(0, 100, SCREEN_WIDTH,MAIN_FRAME_H-44-49);
    
    proListTableView = [[UITableView alloc] initWithFrame:tframe];
    proListTableView.delegate = self;
    proListTableView.dataSource = self;
    proListTableView.rowHeight = 80;
    
    proListTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
    proListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //隐藏多余的行
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [proListTableView setTableFooterView:view];
    proListTableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:proListTableView];
}

-(void)initTopView{
    
    int perViewWidth = SCREEN_WIDTH/3;
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(perViewWidth*0, 64, perViewWidth, 40)];
    //view1.backgroundColor = [UIColor redColor];
    //喜欢
    BtnIcon1 = [[UIImageView alloc] init];
    BtnIcon1.frame = CGRectMake(20, 5, 35, 35);
    BtnIcon1.image = [UIImage imageNamed:@"myzone_like_on.png"];
    BtnIcon1.tag = 1;
    [BtnIcon1 setMultipleTouchEnabled:YES];
    [BtnIcon1 setUserInteractionEnabled:YES];
    [BtnIcon1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changSelectedImg:)]];
    [view1 addSubview:BtnIcon1];
    
    UIButton *likeBtn = [[UIButton alloc] init];
    [likeBtn setTitle:@"喜欢" forState:UIControlStateNormal];
    [likeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    likeBtn.titleLabel.font = main_font(14);
    likeBtn.frame = CGRectMake(42, 5, 50, 35);
    likeBtn.tag = 1;
    [likeBtn addTarget:self action:@selector(changSelectedBtn:) forControlEvents:UIControlEventTouchDown];
    [view1 addSubview:likeBtn];
    
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(perViewWidth*1+1, 64, perViewWidth, 40)];
    //view2.backgroundColor = [UIColor yellowColor];
    //支持
    BtnIcon2 = [[UIImageView alloc] init];
    BtnIcon2.frame = CGRectMake(20, 5, 35, 35);
    BtnIcon2.image = [UIImage imageNamed:@"myzone_suport.png"];
    BtnIcon2.tag = 2;
    [BtnIcon2 setMultipleTouchEnabled:YES];
    [BtnIcon2 setUserInteractionEnabled:YES];
    [BtnIcon2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changSelectedImg:)]];
    [view2 addSubview:BtnIcon2];
    
    UIButton *supBtn = [[UIButton alloc] init];
    [supBtn setTitle:@"支持" forState:UIControlStateNormal];
    [supBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    supBtn.titleLabel.font = main_font(14);
    supBtn.frame = CGRectMake(42, 5, 50, 35);
    supBtn.tag = 2;
    [supBtn addTarget:self action:@selector(changSelectedBtn:) forControlEvents:UIControlEventTouchDown];
    [view2 addSubview:supBtn];
    
    
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(perViewWidth*2+2, 64, perViewWidth, 40)];
    //view3.backgroundColor = [UIColor blueColor];
    //发起
    BtnIcon3 = [[UIImageView alloc] init];
    BtnIcon3.frame = CGRectMake(20, 5, 35, 35);
    BtnIcon3.image = [UIImage imageNamed:@"myzone_sponsor.png"];
    BtnIcon3.tag = 3;
    [BtnIcon3 setMultipleTouchEnabled:YES];
    [BtnIcon3 setUserInteractionEnabled:YES];
    [BtnIcon3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changSelectedImg:)]];
    [view3 addSubview:BtnIcon3];
    
    UIButton *orderBtn = [[UIButton alloc] init];
    [orderBtn setTitle:@"发起" forState:UIControlStateNormal];
    [orderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    orderBtn.titleLabel.font = main_font(14);
    orderBtn.frame = CGRectMake(42, 5, 50, 35);
    orderBtn.tag = 3;
    [orderBtn addTarget:self action:@selector(changSelectedBtn:) forControlEvents:UIControlEventTouchDown];
    [view3 addSubview:orderBtn];
    
    
    //分割线
    UIImageView *imgSpl1 = [[UIImageView alloc] init];
    imgSpl1.frame = CGRectMake(perViewWidth*1, 80, 1, 14);
    imgSpl1.image = [UIImage imageNamed:@"homeplaynumbg.png"];
    imgSpl1.alpha = 0.5;
    [self.view addSubview:imgSpl1];
    
    UIImageView *imgSpl2 = [[UIImageView alloc] init];
    imgSpl2.frame = CGRectMake(perViewWidth*2+1, 80, 1, 14);
    imgSpl2.image = [UIImage imageNamed:@"homeplaynumbg.png"];
    imgSpl2.alpha = 0.5;
    [self.view addSubview:imgSpl2];
    
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    [self.view addSubview:view3];

}

-(void)changSelectedBtn:(UIView *)sender{
     [self showLoading:@"加载中..."];
    switch (sender.tag) {
        case 1:
            [BtnIcon1 setImage:[UIImage imageNamed:@"myzone_like_on.png"]];
            [BtnIcon2 setImage:[UIImage imageNamed:@"myzone_suport.png"]];
            [BtnIcon3 setImage:[UIImage imageNamed:@"myzone_sponsor.png"]];
            break;
        case 2:
            [BtnIcon1 setImage:[UIImage imageNamed:@"myzone_like.png"]];
            [BtnIcon2 setImage:[UIImage imageNamed:@"myzone_suport_on.png"]];
            [BtnIcon3 setImage:[UIImage imageNamed:@"myzone_sponsor.png"]];
            break;
        case 3:
            [BtnIcon1 setImage:[UIImage imageNamed:@"myzone_like.png"]];
            [BtnIcon2 setImage:[UIImage imageNamed:@"myzone_suport.png"]];
            [BtnIcon3 setImage:[UIImage imageNamed:@"myzone_sponsor_on.png"]];
            break;
        default:
            break;
    }
    current_index = sender.tag;
    
    [self loadTableList:sender.tag];
    [proListTableView reloadData];
}


-(void)changSelectedImg:(UITapGestureRecognizer *)tap{
    [self showLoading:@"加载中..."];
    switch (tap.view.tag) {
        case 1:
            [BtnIcon1 setImage:[UIImage imageNamed:@"myzone_like_on.png"]];
            [BtnIcon2 setImage:[UIImage imageNamed:@"myzone_suport.png"]];
            [BtnIcon3 setImage:[UIImage imageNamed:@"myzone_sponsor.png"]];
            break;
        case 2:
            [BtnIcon1 setImage:[UIImage imageNamed:@"myzone_like.png"]];
            [BtnIcon2 setImage:[UIImage imageNamed:@"myzone_suport_on.png"]];
            [BtnIcon3 setImage:[UIImage imageNamed:@"myzone_sponsor.png"]];
            break;
        case 3:
            [BtnIcon1 setImage:[UIImage imageNamed:@"myzone_like.png"]];
            [BtnIcon2 setImage:[UIImage imageNamed:@"myzone_suport.png"]];
            [BtnIcon3 setImage:[UIImage imageNamed:@"myzone_sponsor_on.png"]];
            break;
        default:
            break;
    }
    current_index = tap.view.tag;
    [self loadTableList:tap.view.tag];
    [proListTableView reloadData];
}

-(void)loadTableList:(int)cIndex{
    NSString *url;
    switch (cIndex) {
        case 1:
            url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_LOVE_PROJECTS_URL,dataId];
            break;
            
        case 2:
            url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_SUPPORT_PROJECTS_URL,dataId];
            break;
            
        case 3:
            url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_ORDER_PROJECTS_URL,dataId];
            break;
            
        default:
            break;
    }
    
    [self requestDataByUrl:url withType:cIndex];
    
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
    NSArray *returnArr = (NSArray *)jsonDic;
    if(returnArr!=nil && returnArr.count>0){
        _peopleProList = [NSMutableArray arrayWithArray:returnArr];
    }else{
        _peopleProList = [[NSMutableArray alloc]init];
    }
    
    [proListTableView reloadData];
    [self hideHud];
    
}


- (void)requestFailed:(ASIHTTPRequest *)request
{

    [self hideHud];
    NSError *error = [request error];
    NSLog(@"jsonDic->%@",error);
    
}



-(void)loadView{
    [super loadView];
    [self.view addSubview:[self setNavBarWithTitle:@"我的众筹" hasLeftItem:YES hasRightItem:NO leftIcon:nil rightIcon:nil]];
    
}


#pragma mark 设置组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 设置组高度
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0;
}

#pragma mark 设置组标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _peopleProList.count;
}

#pragma mark 行选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转到详情页面
    NSLog(@"go detail......!");
    cellDic = [self.peopleProList objectAtIndex:indexPath.row];
    if(cellDic!=nil){
        NSString *proId;
        switch (current_index) {
            case 1:
                proId = [cellDic valueForKey:@"pid"];
                break;
            case 2:
                proId = [cellDic valueForKey:@"projectId"];
                break;
            case 3:
                proId = [cellDic valueForKey:@"id"];
                break;
            default:
                break;
        }
        
        
        PeopleDetailViewController *deatilViewController = [[PeopleDetailViewController alloc]init];
        passValelegate = deatilViewController;
        [passValelegate passValue:proId];
        [self.navigationController pushViewController:deatilViewController animated:YES];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProjectTableViewCell *projectCell;
    cellDic = [self.peopleProList objectAtIndex:indexPath.row];
    if(cellDic!=nil){
        
        static NSString *CustomCellIdentifier = @"ProjectCell";
        projectCell=  (ProjectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        
        if (projectCell == nil) {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"ProjectTableViewCell" owner:self options:nil] ;
            projectCell = [nib objectAtIndex:0];
        }
        
        projectCell.selectionStyle =UITableViewCellSelectionStyleNone;
        projectCell.backgroundColor = [UIColor clearColor];
        
        
        //[StringUitl setCornerRadius:projectCell.cellContentView withRadius:5.0];
        //[StringUitl setViewBorder:projectCell.cellContentView withColor:@"#cccccc" Width:0.5];
        
        projectCell.cellTitle.font = TITLE_FONT;
        projectCell.cellTitle.text = [cellDic valueForKey:@"projectName"];
        
        NSString *days =[cellDic valueForKey:@"days"];
        projectCell.cycDate.text = [NSString stringWithFormat:@"项目周期%@天",days];
        double pay_money = [[cellDic valueForKey:@"amount"] doubleValue];
        projectCell.proMoney.text = [NSString stringWithFormat:@"%.2f",pay_money];
        
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
                tagPicName =@"lable_success_s2.png";
                break;
            default:
                stateName = @"已失败";
                tagPicName =@"lable_success_s2.png";
                break;
        }
        [projectCell.stateBtn setTitle:stateName forState:UIControlStateNormal];
        [projectCell.stateBtn setTitle:stateName forState:UIControlStateSelected];
        
        [projectCell.stateBtn setBackgroundImage:[UIImage imageNamed:tagPicName] forState:UIControlStateNormal];
        [projectCell.stateBtn setBackgroundImage:[UIImage imageNamed:tagPicName] forState:UIControlStateSelected];
        
        
        
        if (current_index==2) {//处理订单状态
            NSString *orderStateName;
            UIColor *bgColorStr;
            int orderState = [[cellDic valueForKey:@"orderStatus"] intValue];
            switch (orderState) {
                    //订单状态 1 提交 2 支付成功 3 自己取消 4 卖家取消（众筹失败）5 已发货 6 已签收
                case 1:
                    orderStateName = @"未支付";
                    bgColorStr = [UIColor redColor];
                    break;
                case 2:
                    orderStateName = @"已支付";
                    bgColorStr = [UIColor blueColor];
                    break;
                case 5:
                    orderStateName = @"已发货";
                    bgColorStr = [UIColor orangeColor];
                    break;
                case 6:
                    orderStateName = @"已签收";
                    bgColorStr = [UIColor greenColor];
                    break;
                default:
                    orderStateName = @"已取消";
                    bgColorStr = [UIColor grayColor];
                    break;
            }
            
            [projectCell.orderStateBtn setTitle:orderStateName forState:UIControlStateNormal];
            [projectCell.orderStateBtn setTitle:orderStateName forState:UIControlStateSelected];
            [projectCell.subTitleName setText:@"订单编号："];
            [projectCell.cycDate setText:[cellDic valueForKey:@"orderCode"]];
            [projectCell.orderStateBtn setBackgroundColor:bgColorStr];
            
            //projectCell.orderStateBtn.layer.masksToBounds = TRUE;
            //projectCell.orderStateBtn.layer.cornerRadius = 1.0;
            
            
        }else{
            
            [projectCell.orderStateBtn removeFromSuperview];
            
        }
        
        
        
        
        NSString *imgUrl =[cellDic valueForKey:@"imgUrl"];
        NSRange range = [imgUrl rangeOfString:@"/upload/"];
        if(range.location!=NSNotFound){//判断加载远程图像
            //改写异步加载图片
            [projectCell.cellImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                                    placeholderImage:[UIImage imageNamed:NOIMG_ICON] options:SDWebImageRefreshCached];
        }
        
        
    }
    return projectCell;
}



@end
