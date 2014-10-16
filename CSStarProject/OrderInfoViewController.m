//
//  OrderInfoViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-15.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "OrderInfoViewController.h"

@interface OrderInfoViewController (){
    UITableView *orderTableView;
    NSDictionary *cellDic;
    NSString *dataId;
    
    int sectionNum;
    int selectedNum;
    BOOL firstFlag;
    NSMutableArray *titleArr;
    OrderMoneyTableCell *orderCell;
    ChangeNumTableCell *numberCell;
    
    UITextField *numTextField;
    UITextField *remarkTextField;
}

@end

@implementation OrderInfoViewController

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
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    firstFlag = TRUE;
    selectedNum = 1;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    titleArr = [[NSMutableArray alloc]initWithArray:@[ @"收货人信息",@"回报信息",@"支付数量",@"备注",@"支付金额"]];
    
    [self initLoadData];
    [self setHeadView];
    [self setFooterView];
    
    [self initNotice];
    
}

-(void)initLoadData{
    //计算高度
    CGRect tframe = CGRectMake(0, 64, SCREEN_WIDTH,MAIN_FRAME_H-49);
    
    orderTableView = [[UITableView alloc] initWithFrame:tframe];
    orderTableView.delegate = self;
    orderTableView.dataSource = self;
    orderTableView.rowHeight = 180;
    
    orderTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
    orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //隐藏多余的行
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [orderTableView setTableFooterView:view];
    orderTableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:orderTableView];
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[self setNavBarWithTitle:@"确认信息" hasLeftItem:YES hasRightItem:NO leftIcon:nil rightIcon:nil]];
    
}

-(void)initNotice{
    //增加监听，当键盘出现或改变时收出消息
    //[[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//关闭键盘
-(void) dismissKeyBoard{
    [numTextField resignFirstResponder];
    [remarkTextField resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismissKeyBoard];
}


//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    int sl_num = [numTextField.text intValue];
    selectedNum = sl_num;
    double pay_money = [[self.orderInfoData valueForKey:@"amount"] doubleValue];
    double send_money = [[self.orderInfoData valueForKey:@"freight"] doubleValue];
    
    double total_money =pay_money * sl_num + send_money;
    orderCell.payMoney.text = [NSString  stringWithFormat:@"￥%.2f",pay_money * sl_num];
    orderCell.sendMoney.text = [NSString  stringWithFormat:@"￥%.2f",send_money];
    orderCell.totalMoney.text = [NSString  stringWithFormat:@"￥%.2f",total_money];
}

#pragma mark 控制滚动头部一起滚动
- (void)scrollViewDidScroll:(UIScrollView *)sclView{
    [self dismissKeyBoard];
    CGFloat sectionHeaderHeight = 30;
    //固定section 随着cell滚动而滚动
    if (sclView.contentOffset.y<=sectionHeaderHeight && sclView.contentOffset.y>=0) {
        sclView.contentInset = UIEdgeInsetsMake(-sclView.contentOffset.y, 0, 0, 0);
    } else if (sclView.contentOffset.y>=sectionHeaderHeight) {
        //sclView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

//传递过来的参数
-(void)passValue:(NSString *)val{
    dataId = val;
    NSLog(@"dataId====%@",dataId);
}

-(void)passDicValue:(NSDictionary *)vals{
    self.orderInfoData = vals;
    NSLog(@"orderInfo====%@",vals);
}

-(void)setHeadView{
    sectionNum = 5;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    UIButton *checkBox = [[UIButton alloc]initWithFrame:CGRectMake(0, 8, 32, 32)];
    [checkBox setBackgroundImage:[UIImage imageNamed:@"iconnochecked.png"] forState:UIControlStateNormal];
    [checkBox setBackgroundImage:[UIImage imageNamed:@"iconnochecked.png"] forState:UIControlStateSelected];
    [checkBox setTag:99];
    [checkBox addTarget:self action:@selector(hidenReback:) forControlEvents:UIControlEventTouchDown];
    
    UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(32, 16, SCREEN_WIDTH, 16)];
    tagLabel.font = main_font(13);
    tagLabel.text = @"不要给我回报，无私奉献";
    
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, SCREEN_WIDTH,25)];
    descLabel.font = main_font(13);
    descLabel.text = @"(选择此项目，项目成功后发人将不会给您发送回报)";
    
    [headView addSubview:checkBox];
    [headView addSubview:tagLabel];
    [headView addSubview:descLabel];
    
    [headView setBackgroundColor:[UIColor whiteColor]];
    [orderTableView setTableHeaderView:headView];
    
}

-(void)hidenReback:(UIButton *)sender{
    
    if (sender.tag==99) {
        sectionNum--;
        [titleArr removeObjectAtIndex:0];
        [sender setBackgroundImage:[UIImage imageNamed:@"iconchecked.png"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"iconchecked.png"] forState:UIControlStateSelected];
        [sender setTag:100];
    }else{
        sectionNum++;
        titleArr = [[NSMutableArray alloc]initWithArray:@[ @"收货人信息",@"回报信息",@"支付数量",@"备注",@"支付金额"]];
        [sender setBackgroundImage:[UIImage imageNamed:@"iconnochecked.png"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"iconnochecked.png"] forState:UIControlStateSelected];
        [sender setTag:99];
    }
    [orderTableView reloadData];
    NSLog(@"sectionNum=%d",sectionNum);
}

-(void)setFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH-30, 45)];
    descLabel.font = main_font(13);
    descLabel.numberOfLines = 2;
    descLabel.text = @"如果没有达到筹款目标，您支付的金额将返还到您的支付账户。";
    
    UIButton *submitBox = [[UIButton alloc]initWithFrame:CGRectMake(15, 55, SCREEN_WIDTH-30, 40)];
    [submitBox setBackgroundColor:[UIColor redColor]];
    [submitBox setTitle:@"确认支付" forState:UIControlStateNormal];
    [submitBox setTitle:@"确认支付" forState:UIControlStateSelected];
    submitBox.titleLabel.font = main_font(18);
    [submitBox.layer setCornerRadius:5.0];
    [submitBox.layer setMasksToBounds:YES];

    [footerView addSubview:descLabel];
    [footerView addSubview:submitBox];
    [orderTableView setTableFooterView:footerView];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGRect headFrame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    UIView *sectionHeadView = [[UIView alloc]initWithFrame:headFrame];
    sectionHeadView.backgroundColor = [StringUitl colorWithHexString:@"#F5F5F5"];
    //设置每组的标题
    UILabel *headtitle = [[UILabel alloc]initWithFrame:CGRectMake(10, -5, 100, 30)];
    headtitle.text = titleArr[section];
    headtitle.textColor = [UIColor darkGrayColor];
    headtitle.font = main_font(14);

    [sectionHeadView addSubview:headtitle];

    return sectionHeadView;
}

#pragma mark 设置组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sectionNum;
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
    [self dismissKeyBoard];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==sectionNum-1){
        
       return 120;
        
    }if(indexPath.section==sectionNum-4){
        static NSString *CustomCellIdentifier = @"SReturnCell";
        ReturnTableViewCell *returnCell =  (ReturnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        
        if (returnCell == nil) {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"ReturnTableViewCell" owner:self options:nil] ;
            returnCell = [nib objectAtIndex:0];
        }
        
        NSString *returnContent = [self.orderInfoData valueForKey:@"description"];
        UIFont *font = [UIFont systemFontOfSize:12];
        CGSize size = CGSizeMake(returnCell.returnText.frame.size.width,2000);
        CGSize labelsize = [returnContent sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        if(labelsize.height>20){
            return 20 +labelsize.height;
        }else{
            return 80;
        }
        
    }else{
        
    return 80;
    }
}

#pragma mark 加载数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cellDic = self.orderInfoData;
    if(indexPath.section==sectionNum-1){
        
        static NSString *CustomCellIdentifier = @"OrderMoney";
        orderCell=  (OrderMoneyTableCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        
        if (orderCell == nil) {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"OrderMoneyTableCell" owner:self options:nil] ;
            orderCell = [nib objectAtIndex:0];
        }
        
        orderCell.selectionStyle =UITableViewCellSelectionStyleNone;
        orderCell.backgroundColor = [UIColor whiteColor];
        
        double pay_money = [[cellDic valueForKey:@"amount"] doubleValue];
        double send_money = [[cellDic valueForKey:@"freight"] doubleValue];
        
        double total_money =pay_money * selectedNum + send_money;
        orderCell.payMoney.text = [NSString  stringWithFormat:@"￥%.2f",pay_money * selectedNum];
        orderCell.sendMoney.text = [NSString  stringWithFormat:@"￥%.2f",send_money];
        orderCell.totalMoney.text = [NSString  stringWithFormat:@"￥%.2f",total_money];
        return orderCell;
        
        
    }else if(indexPath.section==sectionNum-2){
        
        UITableViewCell *remarkCell = [[UITableViewCell alloc]init];
        remarkCell.selectionStyle =UITableViewCellSelectionStyleNone;
        remarkTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 60)];
        remarkTextField.backgroundColor = [StringUitl colorWithHexString:@"#F2F2F2"];
        remarkTextField.layer.cornerRadius = 5.0;
        remarkTextField.layer.masksToBounds = YES;
        remarkTextField.delegate = self;
        remarkTextField.borderStyle = UITextBorderStyleRoundedRect;
        [remarkCell addSubview:remarkTextField];
        return remarkCell;
        
    }else if(indexPath.section==sectionNum-3){
            
        static NSString *CustomCellIdentifier = @"NumberCell";
        numberCell=  (ChangeNumTableCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        
        if (numberCell == nil) {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"ChangeNumTableCell" owner:self options:nil] ;
            numberCell = [nib objectAtIndex:0];
        }
        
        numberCell.selectionStyle =UITableViewCellSelectionStyleNone;
        numberCell.backgroundColor = [UIColor whiteColor];
        
        numTextField = numberCell.numTxt;
        numberCell.numTxt.delegate = self;
        [numberCell.numTxt.layer setBackgroundColor:[UIColor whiteColor].CGColor];
        [numberCell.numTxt.layer setCornerRadius:5.0];
        [numberCell.numTxt.layer setMasksToBounds:YES];
        [numberCell.numTxt.layer setBorderWidth:0.5];
        [numberCell.numTxt.layer setBorderColor:[UIColor grayColor].CGColor];
    
        [numberCell.addNum setTag:11];
        [numberCell.delNum setTag:22];
        [numberCell.addNum addTarget:self action:@selector(changeTextVal:) forControlEvents:UIControlEventTouchDown];
        [numberCell.delNum addTarget:self action:@selector(changeTextVal:) forControlEvents:UIControlEventTouchDown];
    
        return numberCell;
        
    }else if(indexPath.section==sectionNum-4){
        
        static NSString *CustomCellIdentifier = @"SReturnCell";
        ReturnTableViewCell *returnCell =  (ReturnTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        
        if (returnCell == nil) {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"ReturnTableViewCell" owner:self options:nil] ;
            returnCell = [nib objectAtIndex:0];
        }
        
        returnCell.selectionStyle =UITableViewCellSelectionStyleNone;
        returnCell.backgroundColor = [UIColor whiteColor];
        
        returnCell.returnText.font = main_font(12);
        returnCell.returnText.text = [cellDic valueForKey:@"description"];
        
        return returnCell;
        
    }else{
        
        UITableViewCell *reciverCell = [[UITableViewCell alloc]init];
        reciverCell.selectionStyle =UITableViewCellSelectionStyleNone;
        UIView *reciverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        UIButton *addRecBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, 20, SCREEN_WIDTH-80, 40)];
        [addRecBtn setBackgroundColor:[UIColor clearColor]];
        [addRecBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [addRecBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        
        [addRecBtn setBackgroundImage:[UIImage imageNamed:@"dotaline.png"] forState:UIControlStateNormal];
        [addRecBtn setBackgroundImage:[UIImage imageNamed:@"dotaline.png"] forState:UIControlStateSelected];
        
        [addRecBtn setTitle:@"+ 添加收货人信息" forState:UIControlStateNormal];
        [addRecBtn setTitle:@"+ 添加收货人信息" forState:UIControlStateSelected];
        [addRecBtn addTarget:self action:@selector(addReciver:) forControlEvents:UIControlEventTouchDown];
        
        addRecBtn.titleLabel.font = main_font(14);
        [addRecBtn.layer setCornerRadius:5.0];
        [addRecBtn.layer setMasksToBounds:YES];
        
        [reciverView addSubview:addRecBtn];

        [reciverCell addSubview:reciverView];
        return reciverCell;
    }
}


-(void)addReciver:(UIButton *)sender{
    NSLog(@"add reciver!");
    ReciverAddressViewController *addressController = [[ReciverAddressViewController alloc]init];
    passValelegate = addressController;
    [passValelegate passValue:dataId];
    [self.navigationController pushViewController:addressController animated:YES];
}

-(void)changeTextVal:(UIButton *)sender{
    
    double pay_money = [[self.orderInfoData valueForKey:@"amount"] doubleValue];
    double send_money = [[self.orderInfoData valueForKey:@"freight"] doubleValue];

    double total_money;
    NSString *totalNum = numberCell.numTxt.text;
    int total_num = [totalNum intValue];
    if(sender.tag==11){//加法运算
        total_num++;
    }else{//减法运算
        if(total_num>1){
           total_num--;
        }else{
           total_num = 1;
        }
    }
    
    selectedNum = total_num;
    double nPayMoney = pay_money * total_num;
    total_money = nPayMoney + send_money;
    numberCell.numTxt.text = [NSString  stringWithFormat:@"%d",total_num];
    orderCell.payMoney.text = [NSString  stringWithFormat:@"￥%.2f",nPayMoney];
    orderCell.sendMoney.text = [NSString  stringWithFormat:@"￥%.2f",send_money];
    orderCell.totalMoney.text = [NSString  stringWithFormat:@"￥%.2f",total_money];
    
}



@end
