//
//  PeopleProListViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-13.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "PeopleProListViewController.h"

@interface PeopleProListViewController (){
    UITableView *proListTableView;
    NSDictionary *cellDic;
    NSString *dataId;
    NSString *titleName;
    NSDictionary *params;
    int cellIndex;
}

@end

@implementation PeopleProListViewController

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
    NSLog(@"go dealloc....");
    [self releaseDMemery];
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear....");
    [super viewDidDisappear:YES];
    [self releaseDMemery];
}

-(void)releaseDMemery{
    NSLog(@"releaseDMemery....");
    proListTableView = nil;
    cellDic = nil;
    dataId = nil;
    titleName = nil;
    params = nil;
}

-(void)viewDidUnload{
    [self releaseDMemery];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self initLoadData];
    [self loadTableList];
}

//传递过来的参数
-(void)passValue:(NSString *)val{
    dataId = val;
    NSLog(@"dataId====%@",dataId);
}

-(void)passDicValue:(NSDictionary *)vals{
    params = vals;
    dataId = [params valueForKey:@"userId"];
    //NSLog(@"vals====%@",vals);
    cellIndex =[[params valueForKey:@"titleName"] intValue];
    switch (cellIndex) {
        case 1:
            titleName = @"Ta喜欢的众筹";
            break;
            
        case 2:
            titleName = @"Ta支持的众筹";
            break;
            
        case 3:
            titleName = @"Ta发起的众筹";
            break;
            
        default:
            break;
    }
    
    if([[params valueForKey:@"titleValue"] isEqualToString:@"order"]){
        titleName = @"我的订单";
    }

}

-(void)initLoadData{
    //计算高度
    CGRect tframe = CGRectMake(0, 64, SCREEN_WIDTH,MAIN_FRAME_H-44);
    
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

-(void)loadTableList{
    NSString *url;
    cellIndex =[[params valueForKey:@"titleName"] intValue];
    switch (cellIndex) {
        case 1:
            url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_LOVE_PROJECTS_URL,dataId];
            break;
            
        case 2:
            url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_SUPPORT_PROJECTS_URL,dataId];
            break;
            
        case 3:
            url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_OTORDER_PROJECTS_URL,dataId];
            break;
            
        default:
            break;
    }

    [self requestDataByUrl:url withType:cellIndex];
    
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
    [self.view addSubview:[self setNavBarWithTitle:titleName hasLeftItem:YES hasRightItem:NO leftIcon:nil rightIcon:nil]];
    
}


#pragma mark 设置组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 设置组高度
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
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
    
    if([[params valueForKey:@"titleValue"] isEqualToString:@"order"]){
        ShowOrderViewController *showOrderController = [[ShowOrderViewController alloc]init];
        passValelegate = showOrderController;
        [passValelegate passValue:[cellDic valueForKey:@"id"]];
        [self.navigationController pushViewController:showOrderController animated:YES];
        
    }else{

        if(cellDic!=nil){
            NSString *proId;
            switch (cellIndex) {
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
        
        double pay_money = [[cellDic valueForKey:@"amount"] doubleValue];
        projectCell.proMoney.text = [NSString stringWithFormat:@"￥%.2f",pay_money];
        
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
        [projectCell.stateBtn setTitle:stateName forState:UIControlStateNormal];
        [projectCell.stateBtn setTitle:stateName forState:UIControlStateSelected];
        
        [projectCell.stateBtn setBackgroundImage:[UIImage imageNamed:tagPicName] forState:UIControlStateNormal];
        [projectCell.stateBtn setBackgroundImage:[UIImage imageNamed:tagPicName] forState:UIControlStateSelected];
        
        
        
        if (cellIndex==2) {//处理订单状态
            NSString *orderStateName;
            UIColor *bgColorStr;
            int orderState = [[cellDic valueForKey:@"projectStatus"] intValue];
            if(cellIndex==2){
                orderState = [[cellDic valueForKey:@"orderStatus"] intValue];
            }
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
            [projectCell.orderStateBtn setBackgroundColor:bgColorStr];
            [projectCell.subTitleName setText:@"订单编号："];
            [projectCell.cycDate setText:[cellDic valueForKey:@"orderCode"]];
            
            //projectCell.orderStateBtn.layer.masksToBounds = TRUE;
            //projectCell.orderStateBtn.layer.cornerRadius = 1.0;
            
            
        }else{
            
            [projectCell.orderStateBtn removeFromSuperview];
            
        }
        
        NSString *imgUrl =[cellDic valueForKey:@"imgUrl"];
        [projectCell.cellImgView md_setImageWithURL:imgUrl placeholderImage:NO_IMG options:SDWebImageRefreshCached];
        
        
        
    }
    return projectCell;
}



@end
