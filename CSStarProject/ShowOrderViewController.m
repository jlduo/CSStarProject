//
//  ShowOrderViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-17.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "ShowOrderViewController.h"

@interface ShowOrderViewController (){
    UITableView *orderInfoTableView;
    NSString *orderId;
    UIButton *rbtn;
    UIImageView *stateView;
}

@end

@implementation ShowOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarController.hidesBottomBarWhenPushed = TRUE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadOrderInfo];
    [self initLoadData];
    [self setHeadView];
    [self setFooterView];
    [self setNavgationBar];
    
    [orderInfoTableView addSubview:[self setTagView]];
    
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view setBackgroundColor:[StringUitl colorWithHexString:@"#F5F5F5"]];

}

-(void)initLoadData{
    //计算高度
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CGRect tframe = CGRectMake(0, 64, SCREEN_WIDTH,MAIN_FRAME_H-49);
    orderInfoTableView = [[UITableView alloc] initWithFrame:tframe];
    orderInfoTableView.delegate = self;
    orderInfoTableView.dataSource = self;
    orderInfoTableView.rowHeight = 180;
    
    orderInfoTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
    orderInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //隐藏多余的行
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [orderInfoTableView setTableFooterView:view];
    orderInfoTableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:orderInfoTableView];
}

-(void)passValue:(NSString *)val{
    orderId = val;
    NSLog(@"orderId==%@",val);
}

-(void)passDicValue:(NSDictionary *)vals{
    NSLog(@"vals==%@",vals);
}

-(void)loadOrderInfo{
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_ORDER_BID_URL,orderId];
    _orderInfoData = (NSMutableDictionary *)[convertJson requestData:url];
    //NSLog(@"_orderInfoData====%@",_orderInfoData);
    
}

-(void)setHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [headView setBackgroundColor:[UIColor whiteColor]];
    
    NSString *stateName;
    NSString *tagPicName;
    int stateNum = [[_orderInfoData valueForKey:@"projectStatus"] intValue];
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
    
    UIButton *imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 13, 60, 25)];
    [imageBtn setImage:[UIImage imageNamed:tagPicName] forState:UIControlStateNormal];
    [imageBtn setImage:[UIImage imageNamed:tagPicName] forState:UIControlStateSelected];
    [headView addSubview:imageBtn];
    
    UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 11, 60, 25)];
    btnLabel.text = stateName;
    
    btnLabel.font = main_font(12);
    btnLabel.textAlignment = NSTextAlignmentCenter;
    btnLabel.textColor = [UIColor whiteColor];
    [headView addSubview:btnLabel];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 12, 260, 25)];
    titleLabel.text = [_orderInfoData valueForKey:@"projectName"];
    titleLabel.textColor = [UIColor blackColor];
    [headView addSubview:titleLabel];
    
    UIImageView *nextView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-25, 13, 24, 24)];
    [nextView setImage:[UIImage imageNamed:@"next_icon.png"]];
    [headView addSubview:nextView];
    
    //添加手势
    UITapGestureRecognizer *singleTapWeb = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goProject)];
    [headView addGestureRecognizer:singleTapWeb];
    singleTapWeb.delegate= self;
    singleTapWeb.cancelsTouchesInView = NO;

    [orderInfoTableView setTableHeaderView:headView];
}

-(void)goProject{
    PeopleDetailViewController *detailViewController = [[PeopleDetailViewController alloc]init];
    passValelegate = detailViewController;
    [passValelegate passValue:[_orderInfoData valueForKey:@"projectId"]];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(void)setFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    UIButton *payBox = [[UIButton alloc]initWithFrame:CGRectMake(15, 16, SCREEN_WIDTH-30, 40)];
    [payBox setBackgroundColor:[UIColor redColor]];
    [payBox setTitle:@"重新支付" forState:UIControlStateNormal];
    [payBox setTitle:@"重新支付" forState:UIControlStateSelected];
    payBox.titleLabel.font = main_font(16);
    [payBox.layer setCornerRadius:5.0];
    [payBox.layer setMasksToBounds:YES];
    payBox.tag = -1;
    [payBox addTarget:self action:@selector(goPayMoney:) forControlEvents:UIControlEventTouchDown];
    
    [footerView addSubview:payBox];
    int orderState = [[_orderInfoData valueForKey:@"orderStatus"] intValue];
    if(orderState!=3 && orderState!=4){
       [orderInfoTableView setTableFooterView:footerView];
    }
    
}

-(void)goPayMoney:(UIButton *)sender{
    [self goPreviou];
}

-(UIImageView *)setTagView{
    
    stateView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-140, 65, 84, 52)];
    NSString *orderStateName;
    int orderState = [[_orderInfoData valueForKey:@"orderStatus"] intValue];
    switch (orderState) {
            //订单状态 1 提交 2 支付成功 3 自己取消 4 卖家取消（众筹失败）5 已发货 6 已签收
        case 1:
            orderStateName = @"payment-none.png";
            break;
        case 2:
            orderStateName = @"payment-paid.png";
            break;
        case 3:
            orderStateName = @"payment_cancel.png";
            break;
        case 4:
            orderStateName = @"payment_cancel.png";
            break;
        case 5:
            orderStateName = @"payment_shipment.png";
            break;
        case 6:
            orderStateName = @"payment_receipt.png";
            break;
        default:
            break;
    }
    
    [stateView setImage:[UIImage imageNamed:orderStateName]];
    return stateView;
}

-(void)setNavgationBar{
    //处理导航开始
    self.navigationController.navigationBarHidden = YES;
    UINavigationBar *navgationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_TITLE_HEIGHT+20)];
    [navgationBar setBackgroundImage:[UIImage imageNamed:NAVBAR_BG_ICON] forBarMetrics:UIBarMetricsDefault];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:nil];
    //处理标题
    UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 160, 50, 44)];
    [titleLabel setText:@"订单详情"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    [titleLabel setTextColor:[StringUitl colorWithHexString:@"#0099FF"]];
    titleLabel.font = BANNER_FONT;
    
    //设置左边箭头
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [lbtn setFrame:CGRectMake(0, 0, 32, 32)];
    [lbtn setBackgroundImage:[UIImage imageNamed:NAVBAR_LEFT_ICON] forState:UIControlStateNormal];
    [lbtn addTarget:self action:@selector(goPreviou) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:lbtn];
    int orderState = [[_orderInfoData valueForKey:@"orderStatus"] intValue];
    if(orderState!=3 && orderState!=4){
        //设置右侧按钮
        rbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [rbtn setFrame:CGRectMake(0, 0, 45, 45)];
        [rbtn setTitle:@"取消" forState:UIControlStateNormal];
        [rbtn setTitle:@"取消" forState:UIControlStateHighlighted];
        [rbtn setTintColor:[UIColor whiteColor]];
        rbtn.titleLabel.font=main_font(18);
        [rbtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rbtn];
        navItem.rightBarButtonItem = rightBtnItem;
    }
    
    navItem.titleView = titleLabel;
    navItem.leftBarButtonItem = leftBtnItem;

    [navgationBar pushNavigationItem:navItem animated:YES];
    
    [self.view addSubview:navgationBar];
    
}

-(void)cancelOrder:(UIButton *)sender{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"确认提示" message:@"确定取消订单吗？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"index=%d",buttonIndex);
    if(buttonIndex==0){
        [self delOrder];
    }
}

-(void)delOrder{
    
    //开始处理
    NSURL *del_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REMOTE_URL,DEL_ORDER_URL]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:del_url];
    [ASIHTTPRequest setSessionCookies:nil];
    
    [request setUseCookiePersistence:YES];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setStringEncoding:NSUTF8StringEncoding];
    
    [request setPostValue:orderId forKey:@"id"];
    
    [request buildPostBody];
    [request startAsynchronous];
    [request setDidFailSelector:@selector(addInfoFailed:)];
    [request setDidFinishSelector:@selector(addFinished:)];
    
    
}

- (void)addFinished:(ASIHTTPRequest *)req
{
    //NSLog(@"info->%@",[req responseString]);
    NSData *respData = [req responseData];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"false"]){//失败
        [self showCAlert:[jsonDic valueForKey:@"info"] widthType:ERROR_LOGO];
    }
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"true"]){//成功
        [self showCAlert:[jsonDic valueForKey:@"info"] widthType:SUCCESS_LOGO];
        
        [rbtn setTitle:@" " forState:UIControlStateNormal];
        [rbtn setTitle:@" " forState:UIControlStateHighlighted];
        [rbtn removeTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        [stateView setImage:[UIImage imageNamed:@"payment_cancel.png"]];
        [orderInfoTableView setTableFooterView:nil];
        [self setTagView];
    }
    
}


- (void)addInfoFailed:(ASIHTTPRequest *)req
{
    [self showCAlert:@"处理数据失败！" widthType:ERROR_LOGO];
}


#pragma mark 设置组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" ";
}
#pragma mark 设置组高度
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0;
}

#pragma mark 设置每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

#pragma mark 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==3){
        OrderTableViewCell *orderCell;
        static NSString *CustomCellIdentifier = @"OrderCell";
        orderCell=  (OrderTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        if (orderCell == nil) {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:self options:nil] ;
            orderCell = [nib objectAtIndex:0];
        }
        
        //内容自适应
        NSString *returnContent = [_orderInfoData valueForKey:@"returnContent"];
        UIFont *font = [UIFont systemFontOfSize:12];
        CGSize size = CGSizeMake(orderCell.titleValue.frame.size.width,2000);
        CGSize labelsize = [returnContent sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        if(labelsize.height>20){
           return labelsize.height+10;
        }else{
           return 40.5;
        }
    }else{
       return 40.5;
    }
}

#pragma mark 加载数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderTableViewCell *orderCell;
    static NSString *CustomCellIdentifier = @"OrderCell";
    orderCell=  (OrderTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    if (orderCell == nil) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:self options:nil] ;
        orderCell = [nib objectAtIndex:0];
    }
    
    orderCell.selectionStyle =UITableViewCellSelectionStyleNone;
    orderCell.backgroundColor = [UIColor clearColor];
    
    DateUtil *dateUtil = [[DateUtil alloc]init];
    
    NSString *titleName;
    NSString *titleKey;
    NSString *titleValue;
    switch (indexPath.row) {
        case 0:
            titleName = @"支持金额：";
            titleKey = @"amount";
            double amount = [[_orderInfoData valueForKey:@"amount"] doubleValue];
            titleValue =[NSString stringWithFormat:@"￥%.2f",amount];
            break;
        case 1:
            titleName = @"订 单 号：";
            titleKey = @"orderCode";
            titleValue =[_orderInfoData valueForKeyPath:titleKey];
            break;
        case 2:
            titleName = @"下单时间：";
            titleKey = @"addTime";
            titleValue = [dateUtil getLocalDateFormateUTCDate1:[self changTime:[_orderInfoData valueForKey:titleKey]]];
            break;
        case 3:
            titleName = @"回报内容：";
            titleKey = @"returnContent";
            titleValue =[_orderInfoData valueForKeyPath:titleKey];
            break;
        case 4:
            titleName = @"回报时间：";
            titleKey = @"days";
            titleValue =[NSString stringWithFormat:@"项目结束%@天后",[_orderInfoData valueForKeyPath:titleKey]];
            break;
        case 5:
            titleName = @"收货信息：";
            titleKey = @"deliveryAddress";
            titleValue =[_orderInfoData valueForKeyPath:titleKey];
            break;
        case 6:
            titleName = @"备   注：";
            titleKey = @"beizhu";
            titleValue =[_orderInfoData valueForKeyPath:titleKey];
            break;
            
        default:
            break;
    }
    
    NSString *labelString = titleValue;
    [orderCell.titleValue setNumberOfLines:0];
    UIFont *font = [UIFont systemFontOfSize:12];
    [orderCell.titleValue setLineBreakMode:NSLineBreakByCharWrapping];
    CGSize size = CGSizeMake( orderCell.titleValue.frame.size.width,2000);
    CGSize labelsize = [labelString sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    if (labelsize.height > 20) {

        orderCell.titleValue.frame = CGRectMake(orderCell.titleValue.frame.origin.x,
                                           orderCell.titleValue.frame.origin.y,
                                           orderCell.titleValue.frame.size.width,
                                           labelsize.height);
       
    }
    
    orderCell.cellTitle.text = titleName;
    orderCell.titleValue.text = titleValue;
    
    return orderCell;
}


-(NSString *)changTime:(NSString *)datetTime{
    if([datetTime length]>19) {
        datetTime = [datetTime substringToIndex:19];
    }
    //NSLog(@"time==%@",datetTime);
    return datetTime;
}

@end
