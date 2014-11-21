//
//  MyProjectListViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-13.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "MyProjectListViewController.h"

@interface MyProjectListViewController (){
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dataId = [StringUitl getSessionVal:LOGIN_USER_ID];
    [self.view setBackgroundColor:[StringUitl colorWithHexString:CONTENT_BACK_COLOR]];
    [StringUitl setViewBorder:self.projectBackView withColor:@"#cccccc" Width:0.5f];
    
    [self initLoadData];
    [self loadTableList:1];
    current_index = 1;
}

//传递过来的参数
-(void)passValue:(NSString *)val{

}

-(void)passDicValue:(NSDictionary *)vals{
    
}

-(void)initLoadData{
    
    _myProjectListTable.rowHeight = 80;
    _myProjectListTable.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
    _myProjectListTable.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (IBAction)clickLikeBtn:(id)sender {
    [self showLoading:@"加载中..."];
    [self.likeIconView setImage:[UIImage imageNamed:@"myzone_like_on.png"]];
    [self.supportIconView setImage:[UIImage imageNamed:@"myzone_suport.png"]];
    [self.sponsorIconView setImage:[UIImage imageNamed:@"myzone_sponsor.png"]];
    
    current_index = 1;
    [self loadTableList:1];
    
}

- (IBAction)clickSupportBtn:(id)sender {
    [self showLoading:@"加载中..."];
    [self.likeIconView setImage:[UIImage imageNamed:@"myzone_like.png"]];
    [self.supportIconView setImage:[UIImage imageNamed:@"myzone_suport_on.png"]];
    [self.sponsorIconView setImage:[UIImage imageNamed:@"myzone_sponsor.png"]];
    current_index = 2;
    [self loadTableList:3];
    
}

- (IBAction)clickSponsorBtn:(id)sender {
    [self showLoading:@"加载中..."];
    [self.likeIconView setImage:[UIImage imageNamed:@"myzone_like.png"]];
    [self.supportIconView setImage:[UIImage imageNamed:@"myzone_suport.png"]];
    [self.sponsorIconView setImage:[UIImage imageNamed:@"myzone_sponsor_on.png"]];
    current_index = 3;
    [self loadTableList:3];

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

    [HttpClient GET:url
         parameters:nil
             isjson:TRUE
            success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSArray *returnArr = (NSArray *)responseObject;
         if(returnArr!=nil && returnArr.count>0){
             _peopleProList = [NSMutableArray arrayWithArray:returnArr];
             [self hideHud];
         }else{
             _peopleProList = [[NSMutableArray alloc]init];
             [self hideHud];
             [self showNo:@"暂无数据!"];
         }
         [_myProjectListTable reloadData];
         
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
        
        PeopleDetailViewController *deatilViewController =  (PeopleDetailViewController *)[self getVCFromSB:@"peopleDetail"];
        _passValelegate = deatilViewController;
        [_passValelegate passValue:proId];
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
