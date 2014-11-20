//
//  AddAddressViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-16.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "AddAddressViewController.h"

@interface AddAddressViewController (){
    NSString *dataId;
    NSString *cityID;
    NSString *cityStr;
    NSDictionary *params;
    NSString *otype;
}

@end

@implementation AddAddressViewController

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
    [self.view setBackgroundColor:[StringUitl colorWithHexString:@"#F5F5F5"]];
    
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self changeTFrame:0];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self changeTFrame:1];
    [self dismissKeyBoard];
    return YES;
}

-(void)changeTFrame:(int)flag{
    float ft = 0.0;
    if(flag==1){
        ft += IPHONE4S ? 95 : 40;
    }else{
        ft -= IPHONE4S ? 95 : 40;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect tempFrame = self.addressBackView.frame;
        [self.addressBackView setFrame:CGRectMake(tempFrame.origin.x, tempFrame.origin.y+ft, tempFrame.size.width, tempFrame.size.height)];
    }];
    
}


-(void)loadView{
    [super loadView];
    [self initBackView];
    [self setNavgationBar];
    if(![otype isEqualToString:@"edit"]){//修改动作
       [self setFooterView];
    }
    
}

-(void)initBackView{
    
    self.remarkText.delegate = self;
    
    [StringUitl setCornerRadius:self.addressBackView withRadius:5.0f];
    [StringUitl setViewBorder:self.addressBackView withColor:@"#F5F5F5" Width:0.5f];
    
    [StringUitl setCornerRadius:self.deleteBtnView withRadius:5.0f];
    [StringUitl setViewBorder:self.deleteBtnView withColor:@"#F5F5F5" Width:0.5f];
    
    [self.areaNameTxt addTarget:self action:@selector(goAreaSelect) forControlEvents:UIControlEventTouchDown];
    
}

-(void)goPreviou{
    [super goPreviou];
    [self dismissViewControllerAnimated:YES completion:^{
        [self clearAddress];
    }];
}

-(void)setNavgationBar{
    //处理导航开始
    self.navigationController.navigationBarHidden = YES;
    UINavigationBar *navgationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_TITLE_HEIGHT+20)];
    [navgationBar setBackgroundImage:[UIImage imageNamed:NAVBAR_BG_ICON] forBarMetrics:UIBarMetricsDefault];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:nil];
    //处理标题
    UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 160, 50, 44)];
    [titleLabel setText:@"收货地址"];
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
    
    //设置右侧按钮
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rbtn setFrame:CGRectMake(0, 0, 45, 45)];
    [rbtn setTitle:@"完 成" forState:UIControlStateNormal];
    [rbtn setTitle:@"完 成" forState:UIControlStateHighlighted];
    [rbtn setTintColor:[UIColor whiteColor]];
    //[rbtn setFont:Font_Size(18)];
    rbtn.titleLabel.font=main_font(18);
    
    //[rbtn setBackgroundImage:[UIImage imageNamed:NAVBAR_RIGHT_ICON] forState:UIControlStateNormal];
    [rbtn addTarget:self action:@selector(saveAddress) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rbtn];
    
    navItem.titleView = titleLabel;
    navItem.leftBarButtonItem = leftBtnItem;
    navItem.rightBarButtonItem = rightBtnItem;
    [navgationBar pushNavigationItem:navItem animated:YES];
    
    [self.view addSubview:navgationBar];
    
}


//关闭键盘
-(void) dismissKeyBoard{
    [self.recPeopleTxt resignFirstResponder];
    [self.phoneNumTxt resignFirstResponder];
    [self.areaCodeTxt resignFirstResponder];
    [self.areaNameTxt resignFirstResponder];
    [self.remarkText resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismissKeyBoard];
}



-(void)goAreaSelect{
    EditCityViewController *cityController = [[EditCityViewController alloc]init];
    _passValelegate = cityController;
    [_passValelegate passValue:@"address_city"];
    [self presentViewController:cityController animated:YES completion:nil];
}

//传递过来的参数
-(void)passValue:(NSString *)val{
    dataId = val;
    NSLog(@"dataId====%@",dataId);
}
-(void)passDicValue:(NSDictionary *)vals{
    NSLog(@"vals====%@",vals);
    otype = [vals valueForKey:@"oType"];
    if([otype isEqualToString:@"edit"]){//修改动作
        params = vals;
        cityID = [vals valueForKey:@"cityId"];
        cityStr = [vals valueForKey:@"areaName"];
    }else{
        cityID = [vals valueForKey:ADDRESS_CITY_ID];
        cityStr = [vals valueForKey:ADDRESS_INFO];
    }
    self.areaNameTxt.text = cityStr;
    //NSLog(@"cityId=%@",cityID);
    //NSLog(@"str=%@",cityStr);
}

-(void)viewWillAppear:(BOOL)animated{
    otype = [params valueForKey:@"oType"];
    if([otype isEqualToString:@"edit"]){//修改动作
        self.recPeopleTxt.text = [params valueForKey:@"userName"];
        self.phoneNumTxt.text = [params valueForKey:@"phone"];
        self.areaCodeTxt.text = [params valueForKey:@"zipCode"];
        self.areaNameTxt.text = cityStr;
        self.remarkText.text = [params valueForKey:@"address"];
        [StringUitl setSessionVal:cityID withKey:ADDRESS_CITY_ID];
        [StringUitl setSessionVal:cityStr withKey:ADDRESS_INFO];
    }else{
        [self clearAddress];
        [StringUitl setSessionVal:@"1" withKey:ADDRESS_CITY_ID];
        [StringUitl setSessionVal:@"35" withKey:ADDRESS_PROVINCE_ID];
        [StringUitl setSessionVal:@"北京市,北京市" withKey:ADDRESS_INFO];
    }
}


-(void)setFooterView{
    [self.deleteBtnView removeFromSuperview];
}

-(void)delAddress:(UIButton *)sender{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"确认提示" message:@"确定删除收货地址？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"index=%d",buttonIndex);
    if(buttonIndex==0){
        [self delAddress2:nil];
    }
}


-(void)delAddress2:(UIButton *)sender{
    [self showLoading:@"数据删除中..."];
    NSString *cid = [params valueForKey:@"id"];
    //开始处理
    NSString *edit_url = [NSString stringWithFormat:@"%@%@",REMOTE_URL,DEL_ADDRESS_URL];
    NSDictionary *param = @{@"id":cid};
    [HttpClient POST:edit_url
          parameters:param
              isjson:TRUE
             success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self hideHud];
         NSDictionary *jsonDic = (NSDictionary *)responseObject;
         if([[jsonDic valueForKey:@"status"] isEqualToString:@"false"]){//修改失败
             [self showNo:[jsonDic valueForKey:@"info"]];
         }
         if([[jsonDic valueForKey:@"status"] isEqualToString:@"true"]){//修改成功
             [self showOk:[jsonDic valueForKey:@"info"]];
             [self dismissViewControllerAnimated:YES completion:^{
                 [self clearAddress];
             }];
             
         }
         
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

-(void)saveAddress{
    
    NSString *username = self.recPeopleTxt.text;
    NSString *phone = self.phoneNumTxt.text;
    NSString *code = self.areaCodeTxt.text;
    NSString *area = self.areaNameTxt.text;
    NSString *address = self.remarkText.text;
    
    
    if([StringUitl isEmpty:username]){
        [self showNo:@"收件人为空"];
        return;
    }
    if([StringUitl isEmpty:phone]){
        [self showNo:@"手机号码为空"];
        return;
    }
    if([StringUitl isEmpty:code]){
        [self showNo:@"邮编为空"];
        return;
    }
    if([StringUitl isEmpty:area]){
        [self showNo:@"所在地区为空"];
        return;
    }
    if([StringUitl isEmpty:address]){
        [self showNo:@"详细地址为空"];
        return;
    }

    [self dismissKeyBoard];
    [self showLoading:@"数据保存中..."];
    //开始处理
    NSString *edit_url = [NSString stringWithFormat:@"%@%@",REMOTE_URL,ADD_ADDRESS_URL];
    if([otype isEqualToString:@"edit"]){//修改动作
         edit_url = [NSString stringWithFormat:@"%@%@",REMOTE_URL,EDIT_ADDRESS_URL];
    }
    
    NSDictionary *param;
    NSMutableDictionary * parameters;
    if([otype isEqualToString:@"edit"]){//修改动作
        param =@{@"isDefault":[params valueForKey:@"isDefault"],@"id":[params valueForKey:@"id"]};
    }else{
        param =@{@"isDefault":@"0",USER_ID:[StringUitl getSessionVal:LOGIN_USER_ID]};
    }
    parameters = [NSMutableDictionary dictionaryWithDictionary:param];
    [parameters setObject:cityID forKey:CITY_ID];
    [parameters setObject:address forKey:USER_ADDRESS];
    [parameters setObject:phone forKey:USER_PHONE];
    [parameters setObject:code forKey:USER_ZIPCODE];
    [parameters setObject:username forKey:USER_NAME];
    
    [HttpClient POST:edit_url
          parameters:parameters
              isjson:FALSE
             success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *jsonDic = [StringUitl getDicFromData:responseObject];
         if([[jsonDic valueForKey:@"status"] isEqualToString:@"false"]){//失败
             [self showNo:[jsonDic valueForKey:@"info"]];
         }
         if([[jsonDic valueForKey:@"status"] isEqualToString:@"true"]){//成功
             [self showOk:[jsonDic valueForKey:@"info"]];
             [self dismissViewControllerAnimated:YES completion:^{
                 [self clearAddress];
             }];
             
         }
         
     }
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [self requestFailed:error];
         
     }];
    
    
}

-(void)clearAddress{
    
    [StringUitl setSessionVal:@"" withKey:ADDRESS_INFO];
    [StringUitl setSessionVal:@"" withKey:ADDRESS_CITY_ID];
    [StringUitl setSessionVal:@"" withKey:ADDRESS_PROVINCE_ID];
    
}

- (IBAction)clickDeleteBtn:(id)sender {
    [self delAddress:sender];
}
@end
