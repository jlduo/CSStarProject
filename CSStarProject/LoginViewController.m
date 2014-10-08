//
//  LoginViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-9-12.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController (){
    
    MBProgressHUD *HUD;
}

@end

@implementation LoginViewController

@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;
    
    self.passWord.delegate = self;
    self.userName.delegate = self;
    
    [self.loginBgView.layer setCornerRadius:6.0];
    [self.userNameView.layer setCornerRadius:6.0];
    [self.passWordView.layer setCornerRadius:6.0];
    [self.lognBtn.layer setCornerRadius:6.0];
    
    //处理导航开始
    [self setNavgationBar];
    //[self.userName setText:[StringUitl getSessionVal:LOGIN_USER_NAME]];

}

-(void)viewWillAppear:(BOOL)animated{
    
    InitTabBarViewController * customTabar = (InitTabBarViewController *)self.tabBarController;
    [customTabar hiddenDIYTaBar];
    //CGRect temFrame = CGRectMake(0, 64, SCREEN_WIDTH,MAIN_FRAME_H-44);
    //[stableView setFrame:temFrame];

}


-(void)setNavgationBar{
    //处理导航开始
    self.navigationController.navigationBarHidden = YES;
    UINavigationBar *navgationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_TITLE_HEIGHT+20)];
    [navgationBar setBackgroundImage:[UIImage imageNamed:NAVBAR_BG_ICON] forBarMetrics:UIBarMetricsDefault];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:nil];
    //处理标题
    UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 160, 50, 44)];
    [titleLabel setText:@"登 录"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    
    //设置左边箭头
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [lbtn setFrame:CGRectMake(0, 0, 32, 32)];
    [lbtn setBackgroundImage:[UIImage imageNamed:NAVBAR_LEFT_ICON] forState:UIControlStateNormal];
    [lbtn addTarget:self action:@selector(goPreviou) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:lbtn];
    
    //设置右侧按钮
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rbtn setFrame:CGRectMake(0, 0, 32, 32)];
    [rbtn setTitle:@"注册" forState:UIControlStateNormal];
    [rbtn setTitle:@"注册" forState:UIControlStateHighlighted];
    [rbtn setTintColor:[UIColor whiteColor]];
    rbtn.titleLabel.font=Font_Size(16);
    
    //[rbtn setBackgroundImage:[UIImage imageNamed:NAVBAR_RIGHT_ICON] forState:UIControlStateNormal];
    [rbtn addTarget:self action:@selector(goRegister) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rbtn];
    
    navItem.titleView = titleLabel;
    navItem.leftBarButtonItem = leftBtnItem;
    navItem.rightBarButtonItem = rightBtnItem;
    [navgationBar pushNavigationItem:navItem animated:YES];
    
    [self.view addSubview:navgationBar];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self dismissKeyBoard];
}

-(void)dismissKeyBoard{
    
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
    
}


-(void)goPreviou{
 
    if ([[StringUitl getSessionVal:FORWARD_TYPE] isEqualToString:@"TAB"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

-(void)goRegister{
    RegisterViewController *userRegView = [[RegisterViewController alloc] init];
    if ([[StringUitl getSessionVal:FORWARD_TYPE] isEqualToString:@"TAB"]) {
    
        [self presentViewController:userRegView animated:YES completion:nil];
        
    }else{
        
        [self.navigationController pushViewController:userRegView animated:YES];
        
    }
}

-(void)getPassword{
    FogetPasswordViewController *getPassword = [[FogetPasswordViewController alloc] init];
    if ([[StringUitl getSessionVal:FORWARD_TYPE] isEqualToString:@"TAB"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        
        [self.navigationController pushViewController:getPassword animated:YES];
        
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField.tag==2){//处理密码
        [self.passWord setSecureTextEntry:YES];
    }
    
}


- (IBAction)clickForgetBtn:(UIButton *)sender {
    [self getPassword];
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



//用户登录方法
- (IBAction)clickLognBtn:(id)sender {
    NSLog(@"user login......");
    [self dismissKeyBoard];
    NSString * user_name = _userName.text;
    NSString *pass_word = _passWord.text;
    
    NSRange name_range = [user_name rangeOfString:@"请输入"];
    NSRange pass_range = [pass_word rangeOfString:@"请输入"];
    
    BOOL isLoginNameNull = FALSE;
    BOOL isLoginPaswNull = FALSE;
    
    if([StringUitl isEmpty:user_name]||name_range.location!=NSNotFound){
        isLoginNameNull = TRUE;
    }
    
    if([StringUitl isEmpty:pass_word]||pass_range.location!=NSNotFound){
        isLoginPaswNull = TRUE;
    }
    
    if(isLoginNameNull==TRUE && isLoginPaswNull == TRUE){
        //[StringUitl alertMsg:@"对不起，请先输入登录信息！" withtitle:@"错误提示"];
        [self showCustomAlert:@"登录信息不完整" widthType:WARNN_LOGO];
        return;
    }
    
    if(isLoginNameNull==TRUE && isLoginPaswNull == FALSE){
        //[StringUitl alertMsg:@"对不起，用户名不能为空！" withtitle:@"错误提示"];
        [self showCustomAlert:@"登录账号不能为空" widthType:WARNN_LOGO];
        return;
    }
    
    if(isLoginNameNull==FALSE && isLoginPaswNull == TRUE){
        //[StringUitl alertMsg:@"对不起，密码不能为空！" withtitle:@"错误提示"];
        [self showCustomAlert:@"登录密码不能为空" widthType:WARNN_LOGO];
        return;
    }
    
    //开始处理登录
    NSURL *login_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REMOTE_URL,LOGIN_URL]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:login_url];
    [ASIHTTPRequest setSessionCookies:nil];
    
    [request setUseCookiePersistence:YES];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setStringEncoding:NSUTF8StringEncoding];
    [request setPostValue:user_name forKey:@"username"];
    [request setPostValue:[StringUitl md5:pass_word] forKey:@"password"];
    [request buildPostBody];
    
    [request startAsynchronous];
    [request setDidFailSelector:@selector(requestLoginFailed:)];
    [request setDidFinishSelector:@selector(requestLoginFinished:)];
    
}

- (void)requestLoginFinished:(ASIHTTPRequest *)req
{
    NSLog(@"login info->%@",[req responseString]);
    NSData *respData = [req responseData];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"error"]){//登录失败
        //[StringUitl alertMsg:[jsonDic valueForKey:@"info"] withtitle:@"错误提示"];
        [self showCustomAlert:[jsonDic valueForKey:@"info"] widthType:ERROR_LOGO];
    }
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"success"]){//登录成功
        //[StringUitl alertMsg:[jsonDic valueForKey:@"info"] withtitle:@"提示信息"];
        //先清除信息
        [StringUitl clearUserInfo];
        //存储用户信息
        [StringUitl setSessionVal:[jsonDic valueForKey:@"userid"] withKey:LOGIN_USER_ID];
        [StringUitl setSessionVal:_userName.text withKey:LOGIN_USER_NAME];
        [StringUitl setSessionVal:_passWord.text withKey:LOGIN_USER_PSWD];
        [StringUitl setSessionVal:@"1" withKey:USER_IS_LOGINED];
        
        //通过用户名获取信息
        [self loadUserInfo:_userName.text];
        
        UserViewController *userView = [[UserViewController alloc]init];
        if ([[StringUitl getSessionVal:FORWARD_TYPE] isEqualToString:@"TAB"]) {

            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            [self.navigationController pushViewController:userView animated:YES];
            
        }
        
    }
    
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
        
        [request setDidFailSelector:@selector(requestLoginFailed:)];
        [request setDidFinishSelector:@selector(getUserInfoFinished:)];
        
    }
}

- (void)getUserInfoFinished:(ASIHTTPRequest *)req
{
    
    NSLog(@"getUserInfo->%@",[req responseString]);
    NSData *respData = [req responseData];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"error"]){//获取信息失败
        //[StringUitl alertMsg:[jsonDic valueForKey:@"info"] withtitle:@"错误提示"];
        [self showCustomAlert:[jsonDic valueForKey:@"info"] widthType:ERROR_LOGO];
    }
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"success"]){//获取信息成功
        
        //存储用户信息
        [StringUitl setSessionVal:[jsonDic valueForKey:USER_NICK_NAME] withKey:USER_NICK_NAME];
        [StringUitl setSessionVal:[jsonDic valueForKey:USER_ADDRESS] withKey:USER_ADDRESS];
        [StringUitl setSessionVal:[jsonDic valueForKey:PROVINCE_ID] withKey:PROVINCE_ID];
        [StringUitl setSessionVal:[jsonDic valueForKey:CITY_ID] withKey:CITY_ID];
        [StringUitl setSessionVal:[jsonDic valueForKey:USER_SEX] withKey:USER_SEX];
        [StringUitl setSessionVal:[jsonDic valueForKey:USER_LOGO] withKey:USER_LOGO];
    
    }

}

- (void)requestLoginFailed:(ASIHTTPRequest *)req
{
    
    //[StringUitl alertMsg:@"请求数据失败！" withtitle:@"错误提示"];
    [self showCustomAlert:@"请求数据失败" widthType:ERROR_LOGO];
}
@end
