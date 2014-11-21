//
//  MyOrderListViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-11-13.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "MyOrderListViewController.h"

@interface MyOrderListViewController (){
    NSDictionary *cellDic;
    NSString *dataId;
    NSDictionary *params;
}

@end

@implementation MyOrderListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.tabBarController.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)passDicValue:(NSDictionary *)vals{
    params = vals;
}

-(void)passValue:(NSString *)val{
    dataId = val;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showLoading:@"加载中..."];
    [self loadTableList];
    self.orderTableView.rowHeight = 80;
    self.orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.orderTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[self setNavBarWithTitle:@"我的订单" hasLeftItem:YES hasRightItem:NO leftIcon:nil rightIcon:nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)loadTableList{
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_SUPPORT_PROJECTS_URL,dataId];
    [self requestDataByUrl:url withType:0];
}

-(void)requestDataByUrl:(NSString *)url withType:(int)type{
    
    [HttpClient GET:url
         parameters:nil
             isjson:TRUE
            success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSArray *returnArr = (NSArray *)responseObject;
         if(returnArr!=nil && returnArr.count>0){
             _peopleProList = [NSMutableArray arrayWithArray:returnArr];
         }else{
             _peopleProList = [[NSMutableArray alloc]init];
         }
         
         [self.orderTableView reloadData];
         [self hideHud];
         
     }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [self requestFailed:error];
         
     }];
    
}

- (void)requestFailed:(NSError *)error
{
    [self hideHud];
    NSLog(@"error=%@",error);
    [self showNo:ERROR_INNER];
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
    ShowOrderViewController *showOrderController = (ShowOrderViewController *)[self getVCFromSB:@"showOrder"];
    passValelegate = showOrderController;
    [passValelegate passValue:[cellDic valueForKey:@"id"]];
    [self.navigationController pushViewController:showOrderController animated:YES];
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
        [projectCell.orderStateBtn setBackgroundColor:bgColorStr];
        [projectCell.subTitleName setText:@"订单编号："];
        [projectCell.cycDate setText:[cellDic valueForKey:@"orderCode"]];
        
        //projectCell.orderStateBtn.layer.masksToBounds = TRUE;
        //projectCell.orderStateBtn.layer.cornerRadius = 1.0;

        
        NSString *imgUrl =[cellDic valueForKey:@"imgUrl"];
        [projectCell.cellImgView md_setImageWithURL:imgUrl placeholderImage:NO_IMG options:SDWebImageRefreshCached];
        
    }
    return projectCell;
}

@end
