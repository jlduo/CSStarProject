//
//  myAddressViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-10.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "myAddressViewController.h"

@interface myAddressViewController ()

@end

@implementation myAddressViewController{
    UITableView *addressTable;
    NSMutableArray *tableArray;
    NSInteger currentIndex;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getAddressList];
    
    //地址列表
    addressTable = [[UITableView alloc] init];
    addressTable.delegate = self;
    addressTable.dataSource = self;
    addressTable.frame = CGRectMake(0, STATU_BAR_HEIGHT + NAV_TITLE_HEIGHT , SCREEN_WIDTH, MAIN_FRAME_H -  NAV_TITLE_HEIGHT + STATU_BAR_HEIGHT);
    [self.view addSubview:addressTable]; 

    //注册单元格
    UINib *nibCell = [UINib nibWithNibName:@"userAddressTableViewCell" bundle:nil];
    [addressTable registerNib:nibCell forCellReuseIdentifier:@"addressCell"];
}

-(void)getAddressList{
    NSString *userId = [StringUitl getSessionVal:LOGIN_USER_ID];
    ConvertJSONData *jsonData = [[ConvertJSONData alloc] init];
    //NSString *url = [[NSString alloc] initWithFormat:@"%@/CF/getDeliverys/%@",REMOTE_URL,userId];
    NSString *url = [[NSString alloc] initWithFormat:@"%@/CF/getDeliverys/45",REMOTE_URL];
    tableArray = (NSMutableArray *)[jsonData requestData:url];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    userAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
    NSDictionary *dic = [tableArray  objectAtIndex:indexPath.row];
    
    NSString *isDefault = [[NSString alloc] initWithFormat:@"%@",[dic valueForKey:@"isDefault"]];
    if ([isDefault isEqualToString:@"1"]) {
        cell.btnCheck.imageView.image = [UIImage imageNamed:@"btncheck.png"];
    }else{
        cell.btnCheck.imageView.image = [UIImage imageNamed:@"btnnocheck.png"];
    }
    cell.lblLink.text = [dic valueForKey:@"userName"];
    cell.lblphoto.text = [dic valueForKey:@"phone"];
    NSString *address = [[NSString alloc] initWithFormat:@"%@%@",[dic valueForKey:@"areaName"],[dic valueForKey:@"address"]];
    cell.lblAddress.text = address; 
    
    [cell.btnCheck addTarget:self action:@selector(checkAddress:) forControlEvents:UIControlEventTouchDown];
    cell.btnCheck.tag = indexPath.row;
    [cell.btnEdit addTarget:self action:@selector(editAddress:) forControlEvents:UIControlEventTouchDown];
    cell.btnEdit.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//设为默认地址
-(void)checkAddress:(UIButton *)sender{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"系统提示"message:@"是否设置该地址为默认收货地址？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消",nil];
    currentIndex = sender.tag;
    [alert show];
}

//编辑
-(void)editAddress:(UIButton *)sender{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSDictionary *dic = [tableArray objectAtIndex:currentIndex];
        ConvertJSONData *jsonData = [[ConvertJSONData alloc] init];
        NSString *url = [[NSString alloc] initWithFormat:@"%@/CF/setDefaultDelivery/%@",REMOTE_URL,[dic valueForKey:@"id"]];
        dic = (NSDictionary *)[jsonData requestData:url];
        if ([[dic valueForKey:@"status"] isEqualToString:@"true"]) {
            [self getAddressList];
            [addressTable reloadData];
            [self showCustomAlert:@"设置成功！" widthType:WARNN_LOGO];
        }else{
            [self showCustomAlert:@"设置失败！" widthType:WARNN_LOGO];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableArray .count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    userAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
    NSDictionary *dic = [tableArray  objectAtIndex:indexPath.row];
    NSString *address = [[NSString alloc] initWithFormat:@"%@%@",[dic valueForKey:@"areaName"],[dic valueForKey:@"address"]];
    //评论内容自适应
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize size = CGSizeMake(cell.lblAddress.frame.size.width,2000);
    CGSize labelsize = [address sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    if (labelsize.height > 20) {
        return  79 + labelsize.height;
    }
    else{
        return 99;
    }
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"收货地址" hasLeftItem:YES hasRightItem:NO  leftIcon:nil rightIcon:nil]];
}

-(void)goPreviou{
    [super goPreviou];
}

//提示框
-(void)showCustomAlert:(NSString *)msg widthType:(NSString *)tp{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:tp]];
    HUD.customView = imgView;
    
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.labelText = msg;
    HUD.dimBackground = YES;
	 
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
}
@end
