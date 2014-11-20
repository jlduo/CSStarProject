//
//  EditPasswordController.m
//  CSStarProject
//
//  Created by jialiduo on 14-9-17.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "EditPasswordController.h"

@interface EditPasswordController ()

@end

@implementation EditPasswordController

@synthesize delegate=_delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarController.hidesBottomBarWhenPushed = TRUE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showLoading:@"加载中..."];
    self.view.backgroundColor = [StringUitl colorWithHexString:@"#F5F5F5"];
    [StringUitl setViewBorder:self.passBg withColor:@"#CCCCCC" Width:0.5f];
    
    self.passText.secureTextEntry = TRUE;
    [self.passText setText:[StringUitl getSessionVal:LOGIN_USER_PSWD]];
    
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
    [titleLabel setText:@"修改密码"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    titleLabel.font = main_font(22);
    
    //设置左边箭头
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [lbtn setFrame:CGRectMake(0, 0, 32, 32)];
    [lbtn setBackgroundImage:[UIImage imageNamed:NAVBAR_LEFT_ICON] forState:UIControlStateNormal];
    [lbtn addTarget:self action:@selector(goPreviou) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:lbtn];
    
    //设置右侧按钮
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rbtn setFrame:CGRectMake(0, 0, 45, 45)];
    [rbtn setTitle:@"保 存" forState:UIControlStateNormal];
    [rbtn setTitle:@"保 存" forState:UIControlStateHighlighted];
    [rbtn setTintColor:[UIColor whiteColor]];
    //[rbtn setFont:Font_Size(18)];
    rbtn.titleLabel.font=main_font(18);
    
    //[rbtn setBackgroundImage:[UIImage imageNamed:NAVBAR_RIGHT_ICON] forState:UIControlStateNormal];
    [rbtn addTarget:self action:@selector(saveUserInfo) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rbtn];
    
    navItem.titleView = titleLabel;
    navItem.leftBarButtonItem = leftBtnItem;
    navItem.rightBarButtonItem = rightBtnItem;
    [navgationBar pushNavigationItem:navItem animated:YES];
    
    [self.view addSubview:navgationBar];
    
}

-(void)goPreviou{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self hideHud];
}

-(void)saveUserInfo{
    [self.passText resignFirstResponder];
    
    NSString *pwd = self.passText.text;
    NSString * username = [StringUitl getSessionVal:LOGIN_USER_NAME];
    if([StringUitl isEmpty:pwd]){
        [self showNo:@"请先输入密码"];
        return;
    }
    
    if([[StringUitl getSessionVal:LOGIN_USER_PSWD] isEqual:pwd]){
        [self showNo:@"新密码不能和旧密码相同"];
        return;
    }
    
    [self showLoading:@"数据保存中..."];
    
    //开始处理
    NSDictionary *parameters = @{USER_NAME:username,USER_PASS:[StringUitl md5:pwd]};
    [HttpClient updateUserInfo:parameters isjson:FALSE success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDic = [StringUitl getDicFromData:responseObject];
        if([[jsonDic valueForKey:@"status"] isEqualToString:@"error"]){//修改失败
            [self hideHud];
            [self showNo:[jsonDic valueForKey:@"info"]];
        }
        if([[jsonDic valueForKey:@"status"] isEqualToString:@"success"]){//修改成功
            [self hideHud];
            [self showOk:@"修改成功,请重新登录!"];
            [StringUitl clearUserInfo];
            LoginViewController *loginView = (LoginViewController *)[self getVCFromSB:@"userLogin"];
            passDelegate = loginView;
            [passDelegate passValue:@"relogin"];
            [self.navigationController pushViewController:loginView animated:YES];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self requestFaild:error];
        
    }];
    
    
}

- (void)requestFaild:(NSError *)error
{
    [self hideHud];
    NSLog(@"error=%@",error);
    [self showNo:@"请求失败,网络错误!"];
}


-(UIStoryboard *)getStoryBoard:(NSString *)sbName{
    if([StringUitl isEmpty:sbName])sbName = @"Main";
    return [UIStoryboard storyboardWithName:sbName bundle:nil];
}

-(UIViewController *)getVCFromSB:(NSString *)vname{
    return [[self getStoryBoard:nil] instantiateViewControllerWithIdentifier:vname];
}

@end
