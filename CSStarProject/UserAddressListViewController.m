//
//  UserAddressListViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-11-14.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "UserAddressListViewController.h"

@interface UserAddressListViewController (){
    NSDictionary *cellDic;
    NSString *dataId;
    int current_index;
    NSMutableDictionary *params;
}

@end

@implementation UserAddressListViewController

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
    [self loadTableList];
    [self setFooterView];
    
    _orderAddressTable.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
    _orderAddressTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loadTableList];
    [self.orderAddressTable reloadData];
}

-(void)loadView{
    [super loadView];
    
    [self.view addSubview:[self setNavBarWithTitle:@"收货地址" hasLeftItem:YES hasRightItem:NO leftIcon:nil rightIcon:nil]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)setFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    
    UIButton *submitBox = [[UIButton alloc]initWithFrame:CGRectMake(10, 16, SCREEN_WIDTH-20, 40)];
    [submitBox setBackgroundColor:[UIColor redColor]];
    [submitBox setTitle:@"添加收货地址" forState:UIControlStateNormal];
    [submitBox setTitle:@"添加收货地址" forState:UIControlStateSelected];
    submitBox.titleLabel.font = main_font(16);
    [submitBox.layer setCornerRadius:5.0];
    [submitBox.layer setMasksToBounds:YES];
    submitBox.tag = -1;
    [submitBox addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchDown];
    
    [footerView addSubview:submitBox];
    [_orderAddressTable setTableFooterView:footerView];
    
}

-(void)addAddress:(UIButton *)sender{
    
    //NSLog(@"add address!");
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(sender.tag!=-1){
        param = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)[self.orderAddressList objectAtIndex:sender.tag]];
        [param setObject:@"edit" forKey:@"oType"];
    }else{
        [param setObject:@"add" forKey:@"oType"];
    }
    AddAddressViewController *addAddressController = (AddAddressViewController *)[self getVCFromSB:@"addAddress"];
    passValelegate = addAddressController;
    [passValelegate passDicValue:param];
    [self presentViewController:addAddressController animated:YES completion:nil];
    
}

-(void)loadTableList{
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_ADDRESS_LIST_URL,[StringUitl getSessionVal:LOGIN_USER_ID]];
    [self requestDataByUrl:url withType:1];
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
    NSMutableArray *returnArr = (NSMutableArray *)jsonDic;
    if(returnArr!=nil && returnArr.count>0){
        _orderAddressList = returnArr;
    }else{
        _orderAddressList = [[NSMutableArray alloc]init];
    }
    
    [_orderAddressTable reloadData];
    [self hideHud];
    
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    [self hideHud];
    NSError *error = [request error];
    NSLog(@"jsonDic->%@",error);
    
}

//传递过来的参数
-(void)passValue:(NSString *)val{
    dataId = val;
    NSLog(@"dataId====%@",dataId);
}

-(void)passDicValue:(NSDictionary *)vals{
    params = [[NSMutableDictionary alloc] initWithDictionary:vals];
    //NSLog(@"values====%@",vals);
}

#pragma mark 设置组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 设置行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _orderAddressList.count;
}

#pragma mark 行选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([StringUitl isEmpty:dataId]){
        passValelegate = (OrderInfoViewController *)[params valueForKey:@"controller"];
        [passValelegate passDicValue:[self.orderAddressList objectAtIndex:indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150;
    
}

#pragma mark 数据加载
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ReciverTableViewCell *reciverCell;
    cellDic = [self.orderAddressList objectAtIndex:indexPath.row];
    if(cellDic!=nil){
        
        static NSString *CustomCellIdentifier = @"ReciverCell";
        reciverCell=  (ReciverTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        
        if (reciverCell == nil) {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"ReciverTableViewCell" owner:self options:nil] ;
            reciverCell = [nib objectAtIndex:0];
        }
        
        reciverCell.selectionStyle =UITableViewCellSelectionStyleNone;
        reciverCell.backgroundColor = [UIColor clearColor];
        
        NSString *isDefault =[[cellDic valueForKey:@"isDefault"] stringValue];
        //NSLog(@"isDefault=%@",isDefault);
        if([isDefault isEqualToString:@"1"]){
            [reciverCell.checkBtn setImage:[UIImage imageNamed:@"btncheck.png"] forState:UIControlStateNormal];
            [reciverCell.checkBtn setImage:[UIImage imageNamed:@"btncheck.png"] forState:UIControlStateSelected];
        }else{
            [reciverCell.checkBtn setImage:[UIImage imageNamed:@"btnnocheck.png"] forState:UIControlStateNormal];
            [reciverCell.checkBtn setImage:[UIImage imageNamed:@"btnnocheck.png"] forState:UIControlStateSelected];
        }
        
        reciverCell.reciverAddress.editable = NO;
        reciverCell.reciverText.text = [cellDic valueForKey:@"userName"];
        reciverCell.reciverAddress.text = [cellDic valueForKey:@"address"];
        reciverCell.phoneNum.text = [cellDic valueForKey:@"phone"];
        
        [StringUitl setCornerRadius:reciverCell.editBtn withRadius:5.0];
        reciverCell.editBtn.tag = indexPath.row;
        [reciverCell.editBtn addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchDown];
        
        [StringUitl setCornerRadius:reciverCell.contentBgView withRadius:5.0];
        [StringUitl setViewBorder:reciverCell.contentBgView withColor:@"#cccccc" Width:0.5];
        
        reciverCell.checkBtn.tag = indexPath.row;
        [reciverCell.checkBtn addTarget:self action:@selector(checkAddress:) forControlEvents:UIControlEventTouchDown];
    }
    return reciverCell;
}

-(void)goEditInfo{
    
    
}


//设为默认地址
-(void)checkAddress:(UIButton *)sender{
    current_index = sender.tag;
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"系统提示"message:@"是否设置该地址为默认收货地址？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSDictionary *dic = [_orderAddressList objectAtIndex:current_index];
        NSString *url = [[NSString alloc] initWithFormat:@"%@/CF/setDefaultDelivery/%@",REMOTE_URL,[dic valueForKey:@"id"]];
        dic = (NSDictionary *)[ConvertJSONData requestData:url];
        if ([[dic valueForKey:@"status"] isEqualToString:@"true"]) {
            [self loadTableList];
            [_orderAddressTable reloadData];
            [self showCAlert:@"设置成功！" widthType:WARNN_LOGO];
        }else{
            [self showCAlert:@"设置失败！" widthType:WARNN_LOGO];
        }
    }
}

@end
