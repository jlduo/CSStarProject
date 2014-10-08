//
//  RegisterViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-9-12.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController (){
    MBProgressHUD *HUD;
}

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.passwordVal.delegate = self;
    
    [self.registerView.layer setCornerRadius:6.0];
    [self.phoneNumView.layer setCornerRadius:6.0];
    [self.passwordView.layer setCornerRadius:6.0];
    [self.checkNumView.layer setCornerRadius:6.0];
    [self.checkNumBtn.layer setCornerRadius:6.0];
    [self.registerBtn.layer setCornerRadius:6.0];
    
    [self setNavgationBar];
    
    
    
}

-(void)setNavgationBar{
    //处理导航开始
    self.navigationController.navigationBarHidden = YES;
    UINavigationBar *navgationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_TITLE_HEIGHT+20)];
    [navgationBar setBackgroundImage:[UIImage imageNamed:NAVBAR_BG_ICON] forBarMetrics:UIBarMetricsDefault];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:nil];
    //处理标题
    UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 160, 50, 44)];
    [titleLabel setText:@"注册"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    
    //设置左边箭头
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [lbtn setFrame:CGRectMake(0, 0, 32, 32)];
    [lbtn setBackgroundImage:[UIImage imageNamed:NAVBAR_LEFT_ICON] forState:UIControlStateNormal];
    [lbtn addTarget:self action:@selector(goPreviou) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:lbtn];

    
    navItem.titleView = titleLabel;
    navItem.leftBarButtonItem = leftBtnItem;
    [navgationBar pushNavigationItem:navItem animated:YES];
    
    [self.view addSubview:navgationBar];
    
}

-(void)goPreviou{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        //关闭时候到操作
    }];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField.tag==2){//处理密码
        [self.passwordVal setSecureTextEntry:YES];
    }
}


-(void)showCustomAlert:(NSString *)msg widthType:(NSString *)tp{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:tp]];
    //[imgView setFrame:CGRectMake(0, 0, 48, 48)];
    HUD.customView = imgView;
    
    HUD.mode = MBProgressHUDModeCustomView;
	
    HUD.delegate = self;
    HUD.labelText = msg;
    HUD.dimBackground = YES;
    
	[self dismissKeyBoard];
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
}


//发送验证码
- (IBAction)clickCheckBtn:(id)sender {
    NSLog(@"get verifycode......");
    BOOL isRegiNameNull = FALSE;

    NSString * phoneNum = _phoneNum.text;
    NSRange phoneRange = [phoneNum rangeOfString:@"请输入"];
    
    if([StringUitl isEmpty:phoneNum]||phoneRange.location!=NSNotFound){
        isRegiNameNull = TRUE;
    }
    
    if(isRegiNameNull==TRUE){
        //[StringUitl alertMsg:@"请输入接收验证码的手机号！" withtitle:@"错误提示"];
        [self showCustomAlert:@"请输入接收验证码的手机号" widthType:WARNN_LOGO];
        return;
    }
    
    //开始获取验证码
    NSURL *reg_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REMOTE_URL,CHECK_CODE_URL]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:reg_url];
    [ASIHTTPRequest setSessionCookies:nil];
    
    [request setUseCookiePersistence:YES];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setStringEncoding:NSUTF8StringEncoding];
    [request setPostValue:phoneNum forKey:@"mobile"];
    [request buildPostBody];
    
    [request startAsynchronous];
    [request setDidFailSelector:@selector(requestRegFailed:)];
    [request setDidFinishSelector:@selector(requestCodeFinished:)];

    
    
}

//注册账号
- (IBAction)clickRegisterBtn:(id)sender {
    
    NSLog(@"user register......");
    NSString * user_name = _phoneNum.text;
    NSString *pass_word = _passwordVal.text;
    NSString *checkNum = _checkNum.text;
    
    NSRange name_range = [user_name rangeOfString:@"请输入"];
    NSRange pass_range = [pass_word rangeOfString:@"设置"];
    NSRange check_range = [checkNum rangeOfString:@"请输入"];
    
    BOOL isRegiNameNull = FALSE;
    BOOL isRegiPaswNull = FALSE;
    BOOL isCheckNumNull = FALSE;
    
    if([StringUitl isEmpty:user_name]||name_range.location!=NSNotFound){
        isRegiNameNull = TRUE;
    }
    
    if([StringUitl isEmpty:pass_word]||pass_range.location!=NSNotFound){
        isRegiPaswNull = TRUE;
    }
    
    if([StringUitl isEmpty:checkNum]||check_range.location!=NSNotFound){
        isCheckNumNull = TRUE;
    }
    
    if(isRegiNameNull==TRUE){
        //[StringUitl alertMsg:@"对不起，请先输入手机号码！" withtitle:@"错误提示"];
        [self showCustomAlert:@"请先输入手机号码" widthType:WARNN_LOGO];
        return;
    }
    
    if(isRegiPaswNull==TRUE){
        //[StringUitl alertMsg:@"对不起，请设置您的密码！" withtitle:@"错误提示"];
        [self showCustomAlert:@"请设置您的密码" widthType:WARNN_LOGO];
        return;
    }
    
    if(isCheckNumNull==TRUE){
        //[StringUitl alertMsg:@"对不起，请先输入接收的验证码！" withtitle:@"错误提示"];
        [self showCustomAlert:@"请先输入接收的验证码" widthType:WARNN_LOGO];
        return;
    }
    
    //验证手机号码
    if(![StringUitl validateMobile:user_name]){
        //[StringUitl alertMsg:@"对不起，您输入的手机号码有误！" withtitle:@"错误提示"];
        [self showCustomAlert:@"您输入的手机号码有误" widthType:WARNN_LOGO];
        return;
    }
    
    //验证码密码
    if(pass_word.length<6||pass_word.length>14){
        //[StringUitl alertMsg:@"对不起，密码长度只能设置6-14位字符！" withtitle:@"错误提示"];
        [self showCustomAlert:@"密码长度只能设置6-14位字符" widthType:WARNN_LOGO];
        return;
    }
    
    //检查验证码
    if(checkNum.length!=4){
        //[StringUitl alertMsg:@"对不起，验证码只能为4位！" withtitle:@"错误提示"];
        [self showCustomAlert:@"验证码只能为4位" widthType:WARNN_LOGO];
        return;
    }
    
    //开始提交注册

    NSURL *reg_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REMOTE_URL,REGISTER_URL]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:reg_url];
    [ASIHTTPRequest setSessionCookies:nil];

    [request setUseCookiePersistence:YES];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setStringEncoding:NSUTF8StringEncoding];
    [request setPostValue:user_name forKey:@"username"];
    [request setPostValue:[StringUitl md5:pass_word] forKey:@"password"];
    [request setPostValue:checkNum forKey:@"verifycode"];
    [request buildPostBody];

    [request startAsynchronous];
    [request setDidFailSelector:@selector(requestRegFailed:)];
    [request setDidFinishSelector:@selector(requestRegFinished:)];

}

- (IBAction)clickAgreen:(id)sender {
    
    UserAgreenViewController *agreenView = [[UserAgreenViewController alloc] init];
    [self presentViewController:agreenView animated:YES completion:nil];
    
}

- (void)requestCodeFinished:(ASIHTTPRequest *)req
{
    NSLog(@"register info->%@",[req responseString]);
    NSData *respData = [req responseData];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"error"]){//获取失败
        //[StringUitl alertMsg:[jsonDic valueForKey:@"info"] withtitle:@"错误提示"];
        [self showCustomAlert:[jsonDic valueForKey:@"info"] widthType:ERROR_LOGO];
    }
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"success"]){//获取成功
        //[StringUitl alertMsg:[jsonDic valueForKey:@"info"] withtitle:@"提示信息"];
        [self showCustomAlert:[jsonDic valueForKey:@"info"] widthType:SUCCESS_LOGO];
        [self startTime];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    

}

//关闭键盘
-(void)dismissKeyBoard{
    [self.phoneNum resignFirstResponder];
    [self.passwordVal resignFirstResponder];
    [self.checkNum resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismissKeyBoard];
}



-(void)startTime{
    __block int timeout=30; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                _randomNum.text = @"";
                [_checkNumBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                _checkNumBtn.userInteractionEnabled = YES;
            });
        }else{
            //int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                _randomNum.text = [NSString stringWithFormat:@"%@",strTime];
                [_checkNumBtn setTitle:@"秒后重发" forState:UIControlStateNormal];
                _checkNumBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}

//获取用户信息
-(void)loadUserInfo:(NSString *)userName{
    if([StringUitl isNotEmpty:userName]){
        
        NSURL *getUserUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?username=%@",REMOTE_URL,USER_CENTER_URL,userName]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:getUserUrl];
        [ASIHTTPRequest setSessionCookies:nil];
        
        [request setUseCookiePersistence:YES];
        [request setDelegate:self];
        [request setRequestMethod:@"GET"];
        [request setStringEncoding:NSUTF8StringEncoding];
        [request startAsynchronous];
        
        [request setDidFailSelector:@selector(requestRegFailed:)];
        [request setDidFinishSelector:@selector(getUserInfoFinished:)];
        
    }
}

- (void)getUserInfoFinished:(ASIHTTPRequest *)req
{
    
    NSLog(@"getUserInfo->%@",[req responseString]);
    NSData *respData = [req responseData];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"error"]){//获取信息失败
        [StringUitl alertMsg:[jsonDic valueForKey:@"info"] withtitle:@"错误提示"];
    }
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"success"]){//获取信息成功
        
        //存储用户信息
        [StringUitl setSessionVal:[jsonDic valueForKey:@"userid"] withKey:LOGIN_USER_ID];
        [StringUitl setSessionVal:_phoneNum.text withKey:LOGIN_USER_NAME];
        [StringUitl setSessionVal:_passwordVal.text withKey:LOGIN_USER_PSWD];
        [StringUitl setSessionVal:@"1" withKey:USER_IS_LOGINED];
        
        [StringUitl setSessionVal:[jsonDic valueForKey:USER_NICK_NAME] withKey:USER_NICK_NAME];
        [StringUitl setSessionVal:[jsonDic valueForKey:USER_ADDRESS] withKey:USER_ADDRESS];
        [StringUitl setSessionVal:[jsonDic valueForKey:PROVINCE_ID] withKey:PROVINCE_ID];
        [StringUitl setSessionVal:[jsonDic valueForKey:CITY_ID] withKey:CITY_ID];
        [StringUitl setSessionVal:[jsonDic valueForKey:USER_SEX] withKey:USER_SEX];
        [StringUitl setSessionVal:[jsonDic valueForKey:USER_LOGO] withKey:USER_LOGO];
        
    }
    
}

- (void)requestRegFinished:(ASIHTTPRequest *)req
{
    NSLog(@"register info->%@",[req responseString]);
    NSData *respData = [req responseData];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"error"]){//注册失败
        
        //[StringUitl alertMsg:[jsonDic valueForKey:@"info"] withtitle:@"错误提示"];
        [self showCustomAlert:[jsonDic valueForKey:@"info"] widthType:ERROR_LOGO];
    }
    
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"success"]){//注册成功
        
        [self loadUserInfo:_phoneNum.text];
    }

}



- (void)requestRegFailed:(ASIHTTPRequest *)req
{
    
    //[StringUitl alertMsg:@"请求数据失败！" withtitle:@"错误提示"];
    [self showCustomAlert:@"请求数据失败！" widthType:ERROR_LOGO];
}


@end
