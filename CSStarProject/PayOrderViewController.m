//
//  PayOrderViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-17.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "PayOrderViewController.h"

@interface PayOrderViewController (){
    UITableView *payTypeTableView;
    NSMutableArray *titleArr;
    NSString *orderId;
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
    
    titleArr = [[NSMutableArray alloc]initWithArray:@[ @"支付宝支付",@"网上银行支付"]];
    
    
}

-(void)initLoadData{
    //计算高度
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CGRect tframe = CGRectMake(0, 64, SCREEN_WIDTH,MAIN_FRAME_H-49);
    payTypeTableView = [[UITableView alloc] initWithFrame:tframe];
    payTypeTableView.delegate = self;
    payTypeTableView.dataSource = self;
    payTypeTableView.rowHeight = 180;
    
    payTypeTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
    payTypeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //隐藏多余的行
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [payTypeTableView setTableFooterView:view];
    payTypeTableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:payTypeTableView];
}

-(void)setHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [headView setBackgroundColor:[UIColor clearColor]];
    
    [payTypeTableView setTableHeaderView:headView];
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[self setNavBarWithTitle:@"选择支付方式" hasLeftItem:YES hasRightItem:YES leftIcon:nil rightIcon:@"btn-close.png"]];
    
}

-(void)goForward{
    //NSLog(@"weweqeqeq");
    ShowOrderViewController *showOrder = [[ShowOrderViewController alloc]init];
    passValelegate = showOrder;
    [passValelegate passValue:orderId];
    [self.navigationController pushViewController:showOrder animated:YES];     
}

-(void)passValue:(NSString *)val{
    orderId = val;
    NSLog(@"val==%@",val);
}

-(void)passDicValue:(NSDictionary *)vals{
    NSLog(@"vals==%@",vals);
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
    return 2;
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
    }else{
        NSLog(@"网银支付！");
    }
    
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
    
    payCell.selectionStyle =UITableViewCellSelectionStyleNone;
    payCell.backgroundColor = [UIColor clearColor];
    
    payCell.conBgView.layer.masksToBounds = YES;
    payCell.conBgView.layer.cornerRadius = 5.0;
    
    if(indexPath.section==0){
        [payCell.payTitleView setText:@"使用支付宝支付"];
        [payCell.payIconView setImage:[UIImage imageNamed:@"logo-alipay.png"]];
    }else{
        [payCell.payTitleView setText:@"使用网银支付"];
        [payCell.payIconView setImage:[UIImage imageNamed:@"logo-unionpay.png"]];
    }
    
    return payCell;
}




@end
