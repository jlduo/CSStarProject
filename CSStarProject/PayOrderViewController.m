//
//  PayOrderViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-17.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "Order.h"
#import "DataSigner.h"
#import "PayOrderViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface PayOrderViewController (){
    NSMutableArray *titleArr;
    NSString *orderId;
    
    NSDictionary *orderInfo;
}

@end

@implementation PayOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarController.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLoadData];
    [self setHeadView];
    [self loadOrderInfo];
    titleArr = [[NSMutableArray alloc]initWithArray:@[ @"支付宝支付",@"网上银行支付"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPageInfo) name:@"showPageInfo" object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = TRUE;
    InitTabBarViewController * customTabar = (InitTabBarViewController *)self.tabBarController;
    [customTabar hiddenDIYTaBar];
}

-(void)showPageInfo{
    
    //支付成功跳转到回报列表页面
    UIViewController *previousViewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3];
    [self.navigationController popToViewController:previousViewController animated:YES];
    
}

-(void)initLoadData{
 
    _payOrderTable.rowHeight = 180;
    _payOrderTable.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
    _payOrderTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)setHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [headView setBackgroundColor:[UIColor clearColor]];
    
    [_payOrderTable setTableHeaderView:headView];
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[self setNavBarWithTitle:@"选择支付方式" hasLeftItem:NO hasRightItem:YES leftIcon:nil rightIcon:@"btn-close.png"]];
    
}

-(void)goForward{
    //NSLog(@"weweqeqeq");
    ShowOrderViewController *showOrder = (ShowOrderViewController *)[self getVCFromSB:@"showOrder"];
    _passValelegate = showOrder;
    [_passValelegate passValue:orderId];
    [self.navigationController pushViewController:showOrder animated:YES];     
}

-(void)passValue:(NSString *)val{
    orderId = val;
    NSLog(@"val==%@",val);
}

-(void)passDicValue:(NSDictionary *)vals{
    NSLog(@"vals==%@",vals);
}

-(void)loadOrderInfo{
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_ORDER_BID_URL,orderId];
    orderInfo = (NSMutableDictionary *)[ConvertJSONData requestData:url];
    NSLog(@"_orderInfoData====%@",orderInfo);
    
}


#pragma mark 控制滚动头部一起滚动
- (void)scrollViewDidScroll:(UIScrollView *)sclView{
    CGFloat sectionHeaderHeight = 35;
    //固定section 随着cell滚动而滚动
    if (sclView.contentOffset.y<=sectionHeaderHeight && sclView.contentOffset.y>=0) {
        sclView.contentInset = UIEdgeInsetsMake(-sclView.contentOffset.y, 0, 0, 0);
    } else if (sclView.contentOffset.y>=sectionHeaderHeight) {
        //sclView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGRect headFrame = CGRectMake(0, 4, SCREEN_WIDTH, 35);
    UIView *sectionHeadView = [[UIView alloc]initWithFrame:headFrame];
    sectionHeadView.backgroundColor = [StringUitl colorWithHexString:@"#F5F5F5"];

    //设置每组的标题
    UILabel *headtitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 13, 100, 30)];
    headtitle.text = titleArr[section];
    headtitle.font = main_font(13);
    headtitle.textColor = [UIColor grayColor];
    [sectionHeadView addSubview:headtitle];
    
    if(section==1){
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, SCREEN_WIDTH, 1)];
        lineLabel.backgroundColor = [UIColor lightGrayColor];
        lineLabel.alpha = 0.3;
        [sectionHeadView addSubview:lineLabel];
        
        [headtitle setFrame:CGRectMake(15, 40, 100, 30)];
    }

    return sectionHeadView;
}

#pragma mark 设置组高度
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section==1){
        return 60.0;
    }else{
        return 35.0;
    }
}


#pragma mark 设置组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return titleArr[section];
}

#pragma mark 设置每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


#pragma mark 行选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        NSLog(@"支付宝支付！");
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        NSString *appScheme = @"AlipaySdkJlduo";
        
        Order *order = [[Order alloc] init];
        order.partner = PartnerID;
        order.seller = SellerID;
        
        order.tradeNO = [orderInfo valueForKey:@"orderCode"]; //订单ID（由商家自行制定）
        order.productName = [orderInfo valueForKey:@"projectName"]; //商品标题
        order.productDescription = [orderInfo valueForKey:@"returnContent"]; //商品描述
        float price = [[orderInfo valueForKey:@"amount"] floatValue];
        order.amount = [NSString stringWithFormat:@"%.2f",price]; //商品价格
        order.notifyURL = Notify_Url; //回调URL
        
        order.service = @"mobile.securitypay.pay";
        order.paymentType = @"1";
        order.inputCharset = @"utf-8";
        order.itBPay = @"30m";
        order.showUrl = @"m.alipay.com";
        
        //将商品信息拼接成字符串
        NSString *orderSpec = [order description];
        NSLog(@"orderSpec = %@",orderSpec);
        
        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
        id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
        NSString *signedString = [signer signString:orderSpec];

        
        //将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = nil;
        if (signedString != nil) {
            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                           orderSpec, signedString, @"RSA"];
            
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
            }];
            
        }

        
    }else{
        NSLog(@"网银支付！");
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
    
}

#pragma mark 加载数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PayTableViewCell *payCell;
        
    static NSString *CustomCellIdentifier = @"PayCell";
    payCell=  (PayTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    if (payCell == nil) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"PayTableViewCell" owner:self options:nil] ;
        payCell = [nib objectAtIndex:0];
    }
    
    payCell.selectionStyle =UITableViewCellSelectionStyleBlue;
    payCell.backgroundColor = [UIColor clearColor];
    
    payCell.conBgView.layer.masksToBounds = YES;
    payCell.conBgView.layer.cornerRadius = 5.0;
    
    if(indexPath.section==0){
        [payCell.payTitleView setText:@"使用支付宝支付"];
        [payCell.payIconView setImage:[UIImage imageNamed:@"logo-alipay.png"]];
    }else{
        //[payCell.payTitleView setText:@"使用网银支付"];
        //[payCell.payIconView setImage:[UIImage imageNamed:@"logo-unionpay.png"]];
    }
    
    return payCell;
}




@end
