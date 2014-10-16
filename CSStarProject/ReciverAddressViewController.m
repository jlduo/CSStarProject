//
//  ReciverAddressViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-15.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "ReciverAddressViewController.h"

@interface ReciverAddressViewController (){
    UITableView *addressTableView;
    NSDictionary *cellDic;
    NSString *dataId;
}

@end

@implementation ReciverAddressViewController

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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initLoadData];
    [self loadTableList];
}

-(void)initLoadData{
    //计算高度
    CGRect tframe = CGRectMake(0, 64, SCREEN_WIDTH,MAIN_FRAME_H-49);
    
    addressTableView = [[UITableView alloc] initWithFrame:tframe];
    addressTableView.delegate = self;
    addressTableView.dataSource = self;
    
    addressTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
    addressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //隐藏多余的行
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [addressTableView setTableFooterView:view];
    addressTableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:addressTableView];
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[self setNavBarWithTitle:@"收货地址" hasLeftItem:YES hasRightItem:NO leftIcon:nil rightIcon:nil]];
    
}

-(void)loadTableList{
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_ADDRESS_LIST_URL,[StringUitl getSessionVal:LOGIN_USER_ID]];
    NSArray *returnArr = (NSArray *)[convertJson requestData:url];
    if(returnArr!=nil && returnArr.count>0){
        _orderAddressList = [NSMutableArray arrayWithArray:returnArr];
    }
    NSLog(@"_orderAddressList====%@",_orderAddressList);
}

//传递过来的参数
-(void)passValue:(NSString *)val{
    dataId = val;
    NSLog(@"dataId====%@",dataId);
}

-(void)passDicValue:(NSDictionary *)vals{
    NSLog(@"vals====%@",vals);
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
        
        reciverCell.reciverAddress.editable = NO;
        reciverCell.reciverText.text = [cellDic valueForKey:@"userName"];
        reciverCell.reciverAddress.text = [cellDic valueForKey:@"address"];
        reciverCell.phoneNum.text = [cellDic valueForKey:@"phone"];
        
        reciverCell.editBtn.layer.masksToBounds = YES;
        reciverCell.editBtn.layer.cornerRadius = 5.0;
        
        reciverCell.contentBgView.layer.masksToBounds = YES;
        reciverCell.contentBgView.layer.cornerRadius = 5.0;
    }
    return reciverCell;
}


@end
