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
    UITextField *recText;
    UITextField *phoneText;
    UITextField *codeText;
    UITextField *areaText;
    UITextField *addressText;
    
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
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view setBackgroundColor:[StringUitl colorWithHexString:@"#F5F5F5"]];
    
}

-(void)loadView{
    [super loadView];
    [self setAddView];
    [self setNavgationBar];
    if([otype isEqualToString:@"edit"]){//修改动作
       [self setFooterView];
    }
    
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


-(void)setAddView{
    
    UIView *addAddressView = [[UIView alloc] initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH-20, 225)];
    [addAddressView setBackgroundColor:[UIColor whiteColor]];
    [addAddressView.layer setCornerRadius:5.0];
    [addAddressView.layer setMasksToBounds:YES];
    
    UILabel *recLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 45)];
    recLabel.font = main_font(13);
    recLabel.text = @"收件人：";
    
    recText = [[UITextField alloc]initWithFrame:CGRectMake(65, 0, SCREEN_WIDTH-85, 45)];
    recText.font = main_font(13);
    recText.clearButtonMode = UITextFieldViewModeWhileEditing;
    //recText.borderStyle = UITextBorderStyleLine;
    //recText.text = @"22222";
    
    UILabel *recLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH-20, 1)];
    recLine.backgroundColor = [StringUitl colorWithHexString:@"#F5F5F5"];
    
    [addAddressView addSubview:recLabel];
    [addAddressView addSubview:recText];
    [addAddressView addSubview:recLine];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 80, 45)];
    phoneLabel.font = main_font(13);
    phoneLabel.text = @"手机号码：";
    
    phoneText = [[UITextField alloc]initWithFrame:CGRectMake(85, 45, SCREEN_WIDTH-105, 45)];
    phoneText.font = main_font(13);
    phoneText.keyboardType = UIKeyboardTypePhonePad;
    phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    //phoneText.text = @"13787047370";
    //phoneText.borderStyle = UITextBorderStyleLine;
    
    UILabel *phoneLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH-20, 1)];
    phoneLine.backgroundColor = [StringUitl colorWithHexString:@"#F5F5F5"];
    
    [addAddressView addSubview:phoneLabel];
    [addAddressView addSubview:phoneText];
    [addAddressView addSubview:phoneLine];
    
    UILabel *codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, 60, 45)];
    codeLabel.font = main_font(13);
    codeLabel.text = @"邮  编：";
    
    codeText = [[UITextField alloc]initWithFrame:CGRectMake(65, 90, SCREEN_WIDTH-85, 45)];
    codeText.font = main_font(13);
    codeText.clearButtonMode = UITextFieldViewModeWhileEditing;
    codeText.keyboardType = UIKeyboardTypeNumberPad;
    //codeText.borderStyle = UITextBorderStyleLine;
    //codeText.text = @"410000";
    
    UILabel *codeLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 135, SCREEN_WIDTH-20, 1)];
    codeLine.backgroundColor = [StringUitl colorWithHexString:@"#F5F5F5"];
    
    [addAddressView addSubview:codeLabel];
    [addAddressView addSubview:codeText];
    [addAddressView addSubview:codeLine];
    
    
    UILabel *areaLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 135, 80, 45)];
    areaLabel.font = main_font(13);
    areaLabel.text = @"所在地区：";
    
    areaText = [[UITextField alloc]initWithFrame:CGRectMake(85, 135, SCREEN_WIDTH-105, 45)];
    areaText.font = main_font(13);
    areaText.clearButtonMode = UITextFieldViewModeWhileEditing;
    //areaText.borderStyle = UITextBorderStyleLine;
    //areaText.text = @"410000";
    
    [areaText addTarget:self action:@selector(goAreaSelect) forControlEvents:UIControlEventTouchDown];
    
    UILabel *areaLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 180, SCREEN_WIDTH-20, 1)];
    areaLine.backgroundColor = [StringUitl colorWithHexString:@"#F5F5F5"];
    
    [addAddressView addSubview:areaLabel];
    [addAddressView addSubview:areaText];
    [addAddressView addSubview:areaLine];
    
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 180, 80, 45)];
    addressLabel.font = main_font(13);
    addressLabel.text = @"详细地址：";
    
    addressText = [[UITextField alloc]initWithFrame:CGRectMake(85, 180, SCREEN_WIDTH-105, 45)];
    addressText.font = main_font(13);
    addressText.clearButtonMode = UITextFieldViewModeWhileEditing;
    //addressText.borderStyle = UITextBorderStyleLine;
    //addressText.text = @"湖南长沙23123123";
    
    [addAddressView addSubview:addressLabel];
    [addAddressView addSubview:addressText];
    
    
    [self.view addSubview:addAddressView];

}


//关闭键盘
-(void) dismissKeyBoard{
    [recText resignFirstResponder];
    [phoneText resignFirstResponder];
    [codeText resignFirstResponder];
    [areaText resignFirstResponder];
    [addressText resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismissKeyBoard];
}



-(void)goAreaSelect{
    EditCityViewController *cityController = [[EditCityViewController alloc]init];
    passValelegate = cityController;
    [passValelegate passValue:@"address_city"];
    [self presentViewController:cityController animated:YES completion:nil];
}

//传递过来的参数
-(void)passValue:(NSString *)val{
    dataId = val;
    //NSLog(@"dataId====%@",dataId);
}
-(void)passDicValue:(NSDictionary *)vals{
    //NSLog(@"vals====%@",vals);
    otype = [vals valueForKey:@"oType"];
    if([otype isEqualToString:@"edit"]){//修改动作
        params = vals;
        cityID = [vals valueForKey:@"cityId"];
        cityStr = [vals valueForKey:@"areaName"];
    }else{
        cityID = [vals valueForKey:ADDRESS_CITY_ID];
        cityStr = [vals valueForKey:ADDRESS_INFO];
    }
    areaText.text = cityStr;
    //NSLog(@"cityId=%@",cityID);
    //NSLog(@"str=%@",cityStr);
}

-(void)viewWillAppear:(BOOL)animated{
    otype = [params valueForKey:@"oType"];
    if([otype isEqualToString:@"edit"]){//修改动作
        recText.text = [params valueForKey:@"userName"];
        phoneText.text = [params valueForKey:@"phone"];
        codeText.text = [params valueForKey:@"zipCode"];
        areaText.text = cityStr;
        addressText.text = [params valueForKey:@"address"];
        [StringUitl setSessionVal:cityID withKey:ADDRESS_CITY_ID];
        [StringUitl setSessionVal:cityStr withKey:ADDRESS_INFO];
    }
}


-(void)setFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 70)];
    
    UIButton *submitBox = [[UIButton alloc]initWithFrame:CGRectMake(15, 35, SCREEN_WIDTH-30, 40)];
    [submitBox setBackgroundColor:[UIColor redColor]];
    [submitBox setTitle:@"删除收货地址" forState:UIControlStateNormal];
    [submitBox setTitle:@"删除收货地址" forState:UIControlStateSelected];
    submitBox.titleLabel.font = main_font(16);
    [submitBox.layer setCornerRadius:5.0];
    [submitBox.layer setMasksToBounds:YES];
    submitBox.tag = -1;
    [submitBox addTarget:self action:@selector(delAddress:) forControlEvents:UIControlEventTouchDown];
    
    [footerView addSubview:submitBox];
    [self.view addSubview:footerView];
    
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
    NSString *cid = [params valueForKey:@"id"];
    //开始处理
    NSURL *edit_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REMOTE_URL,DEL_ADDRESS_URL]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:edit_url];
    [ASIHTTPRequest setSessionCookies:nil];
    
    [request setUseCookiePersistence:YES];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setStringEncoding:NSUTF8StringEncoding];
    [request setPostValue:cid forKey:@"id"];
    
    [request buildPostBody];
    [request startAsynchronous];
    [request setDidFailSelector:@selector(addInfoFailed:)];
    [request setDidFinishSelector:@selector(addFinished:)];

}


-(void)saveAddress{
    
    NSString *username = recText.text;
    NSString *phone = phoneText.text;
    NSString *code = codeText.text;
    NSString *area = areaText.text;
    NSString *address = addressText.text;
    
    
    if([StringUitl isEmpty:username]){
        [self showCAlert:@"收件人为空" widthType:WARNN_LOGO];
        return;
    }
    if([StringUitl isEmpty:phone]){
        [self showCAlert:@"手机号码为空" widthType:WARNN_LOGO];
        return;
    }
    if([StringUitl isEmpty:code]){
        [self showCAlert:@"邮编为空" widthType:WARNN_LOGO];
        return;
    }
    if([StringUitl isEmpty:area]){
        [self showCAlert:@"所在地区为空" widthType:WARNN_LOGO];
        return;
    }
    if([StringUitl isEmpty:address]){
        [self showCAlert:@"详细地址为空" widthType:WARNN_LOGO];
        return;
    }

    
    //开始处理
    NSURL *edit_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REMOTE_URL,ADD_ADDRESS_URL]];
    if([otype isEqualToString:@"edit"]){//修改动作
         edit_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REMOTE_URL,EDIT_ADDRESS_URL]];
    }
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:edit_url];
    [ASIHTTPRequest setSessionCookies:nil];
    
    [request setUseCookiePersistence:YES];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setStringEncoding:NSUTF8StringEncoding];
     if([otype isEqualToString:@"edit"]){//修改动作
       [request setPostValue:[params valueForKey:@"isDefault"] forKey:@"isDefault"];
       [request setPostValue:[params valueForKey:@"id"] forKey:@"id"];
     }else{
       [request setPostValue:@"0" forKey:@"isDefault"];
       [request setPostValue:[StringUitl getSessionVal:LOGIN_USER_ID] forKey:USER_ID];
     }
    [request setPostValue:cityID forKey:CITY_ID];
    [request setPostValue:addressText.text forKey:USER_ADDRESS];
    [request setPostValue:phone forKey:USER_PHONE];
    [request setPostValue:code forKey:USER_ZIPCODE];
    [request setPostValue:username forKey:USER_NAME];
    
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
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"false"]){//修改失败
        [self showCAlert:[jsonDic valueForKey:@"info"] widthType:ERROR_LOGO];
    }
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"true"]){//修改成功
        [self showCAlert:[jsonDic valueForKey:@"info"] widthType:SUCCESS_LOGO];
        [self dismissViewControllerAnimated:YES completion:^{
            [self clearAddress];
        }];
        
    }
    
}

-(void)clearAddress{
    
    [StringUitl setSessionVal:@"" withKey:ADDRESS_INFO];
    [StringUitl setSessionVal:@"" withKey:ADDRESS_CITY_ID];
    [StringUitl setSessionVal:@"" withKey:ADDRESS_PROVINCE_ID];
    
}

- (void)addInfoFailed:(ASIHTTPRequest *)req
{
    [self showCAlert:@"处理数据失败！" widthType:ERROR_LOGO];
}

@end
