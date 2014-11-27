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
    NSString *passString;
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
    self.view.backgroundColor = [StringUitl colorWithHexString:@"#F5F5F5"];
    
    [self.loginBgView.layer setCornerRadius:6.0];
    [self.userNameView.layer setCornerRadius:6.0];
    [self.passWordView.layer setCornerRadius:6.0];
    [self.lognBtn.layer setCornerRadius:6.0];
    
    //处理导航开始
    [self setNavgationBar];
    //[self.userName setText:[StringUitl getSessionVal:LOGIN_USER_NAME]];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    InitTabBarViewController * customTabar = (InitTabBarViewController *)self.tabBarController;
    [customTabar hiddenDIYTaBar];
    
    self.userName.text = nil;
    self.passWord.text = nil;

}


-(void)passValue:(NSString *)val{
    
    passString = val;
    NSLog(@"passString=%@",passString);
}

-(void)passDicValue:(NSDictionary *)vals{
    
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
    titleLabel.font=TITLE_FONT;
    //设置左边箭头
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [lbtn setFrame:CGRectMake(0, 0, 32, 32)];
    [lbtn setBackgroundImage:[UIImage imageNamed:NAVBAR_LEFT_ICON] forState:UIControlStateNormal];
    [lbtn addTarget:self action:@selector(goPreviou) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:lbtn];
    
    //设置右侧按钮
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rbtn setFrame:CGRectMake(0, 0, 45, 45)];
    [rbtn setTitle:@"注册" forState:UIControlStateNormal];
    [rbtn setTitle:@"注册" forState:UIControlStateHighlighted];
    [rbtn setTintColor:[UIColor whiteColor]];
    rbtn.titleLabel.font=TITLE_FONT;
    
    //[rbtn setBackgroundImage:[UIImage imageNamed:NAVBAR_RIGHT_ICON] forState:UIControlStateNormal];
    [rbtn addTarget:self action:@selector(goRegister) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rbtn];
    
    navItem.titleView = titleLabel;
    if(![passString isEqualToString:@"relogin"]){//重新登录不能回退
       navItem.leftBarButtonItem = leftBtnItem;
    }
    
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
 
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
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

        [self presentViewController:getPassword animated:YES completion:nil];
        
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

-(void)resetLoginBtn:(int) flag{
    if(flag==0){
        [self.lognBtn setEnabled:TRUE];
        [self.lognBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.lognBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.lognBtn setBackgroundColor:[UIColor redColor]];
    }else{
        [self.lognBtn setEnabled:FALSE];
        [self.lognBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.lognBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [self.lognBtn setBackgroundColor:[UIColor grayColor]];
    }
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
        [self showNo:@"登录信息不完整"];
        return;
    }
    
    if(isLoginNameNull==TRUE && isLoginPaswNull == FALSE){
        [self showNo:@"登录账号不能为空"];
        return;
    }
    
    if(isLoginNameNull==FALSE && isLoginPaswNull == TRUE){
        [self showNo:@"登录密码不能为空"];
        return;
    }
    
    [self resetLoginBtn:1];
    //开始处理登录
    [self showLoading:@"正在登录..."];

    [HttpClient userLogin:user_name
                 password:[StringUitl md5:pass_word]
                   isjson:TRUE
                  success:^(AFHTTPRequestOperation *operation, id responseObject)
     {//登录成功
         
         NSLog(@"login info->%@",responseObject);
         NSDictionary *jsonDic = (NSDictionary *)responseObject;
         if([[jsonDic valueForKey:@"status"] isEqualToString:@"error"]){//登录失败
             [self hideHud];
             [StringUitl clearUserInfo];
             [self resetLoginBtn:0];
             [self showNo:[jsonDic valueForKey:@"info"]];
         }
         if([[jsonDic valueForKey:@"status"] isEqualToString:@"success"]){//登录成功
             //先清除信息
             [StringUitl clearUserInfo];
             //存储用户信息
             [StringUitl setSessionVal:[jsonDic valueForKey:@"userid"] withKey:LOGIN_USER_ID];
             [StringUitl setSessionVal:_userName.text withKey:LOGIN_USER_NAME];
             [StringUitl setSessionVal:_passWord.text withKey:LOGIN_USER_PSWD];
             [StringUitl setSessionVal:@"1" withKey:USER_IS_LOGINED];
             [self hideHud];
             [self resetLoginBtn:0];
             //通过用户名获取信息
             [self loadUserInfo:_userName.text];
         }
         
         
     }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {//登录失败
         
         [self requestFailed:error];
         
     }];
    
}

//获取用户信息
-(void)loadUserInfo:(NSString *)userName{
    if([StringUitl isNotEmpty:userName]){
        
        [HttpClient loadUserInfo:userName
                          isjson:TRUE
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             NSDictionary *jsonDic = (NSDictionary *)responseObject;
                             if([[jsonDic valueForKey:@"status"] isEqualToString:@"error"]){//获取信息失败
                                 [self showNo:[jsonDic valueForKey:@"info"]];
                             }
                             if([[jsonDic valueForKey:@"status"] isEqualToString:@"success"]){//获取信息成功
                                 
                                 //存储用户信息
                                 [StringUitl setSessionVal:[jsonDic valueForKey:USER_NICK_NAME] withKey:USER_NICK_NAME];
                                 [StringUitl setSessionVal:[jsonDic valueForKey:USER_ADDRESS] withKey:USER_ADDRESS];
                                 [StringUitl setSessionVal:[jsonDic valueForKey:PROVINCE_ID] withKey:PROVINCE_ID];
                                 [StringUitl setSessionVal:[jsonDic valueForKey:CITY_ID] withKey:CITY_ID];
                                 [StringUitl setSessionVal:[jsonDic valueForKey:USER_SEX] withKey:USER_SEX];
                                 [StringUitl setSessionVal:[jsonDic valueForKey:USER_LOGO] withKey:USER_LOGO];
                                 
                                 if ([[StringUitl getSessionVal:FORWARD_TYPE] isEqualToString:@"TAB"]) {
                                     
                                     UIViewController *viewController = self;
                                     while (viewController.presentingViewController){
                                         viewController = viewController.presentingViewController;
                                         if ([viewController isMemberOfClass:[InitTabBarViewController class]]) {
                                             passDelegate = (InitTabBarViewController *)viewController;
                                             [passDelegate passValue:passString];
                                             [viewController dismissViewControllerAnimated:YES completion:nil];
                                             break;
                                         }
                                     }
                                     
                                 }if ([[StringUitl getSessionVal:FORWARD_TYPE] isEqualToString:@"HTAB"]) {
                                     
                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"showContent" object:nil];
                                     [self dismissViewControllerAnimated:YES completion:nil];
                                     
                                     
                                 }else{
                                     
                                     UserViewController *userView = (UserViewController *)[self getVCFromSB:@"userCenter"];
                                     [self.navigationController pushViewController:userView animated:YES];
                                     
                                 }
                                 
                             }
                             
                             
                         }
         
                         failure:^(AFHTTPRequestOperation *operation, NSError *error){
                             
                             [self requestFailed:(NSError *)error];
                             
                         }];
        }
    
}


- (void)requestFailed:(NSError *)error
{
    NSLog(@"error=%@",error);
    [self hideHud];
    [self resetLoginBtn:0];
    [self showNo:@"请求失败,网络错误!"];
}
@end
