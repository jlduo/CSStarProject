//
//  EditSexViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-9-18.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "EditSexViewController.h"

@interface EditSexViewController ()

@end

@implementation EditSexViewController

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
    [self setNavgationBar];
    [self.boyBg setAlpha:0.8f];
    [self.boyBg.layer setCornerRadius:22.5f];
    [self.boyBg.layer setBorderWidth:0.5f];
    [self.boyBg.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [self.girlBg setAlpha:0.8f];
    [self.girlBg.layer setCornerRadius:22.5f];
    [self.girlBg.layer setBorderWidth:0.5f];
    [self.girlBg.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [self.bmBg setAlpha:0.8f];
    [self.bmBg.layer setCornerRadius:22.5f];
    [self.bmBg.layer setBorderWidth:0.5f];
    [self.bmBg.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    _boyRadio.on = YES;
    _girlRadio.on = NO;
    _bmRadio.on = NO;
    _sexValue = [StringUitl getSessionVal:USER_SEX];
    if([StringUitl isEmpty:_sexValue] || [_sexValue isEqual:@"保密"]){
        _bmRadio.on = YES;
        _boyRadio.on = NO;
        _girlRadio.on = NO;
    }
    
    if([_sexValue isEqual:@"男"]){
        _bmRadio.on = NO;
        _boyRadio.on = YES;
        _girlRadio.on = NO;
    }
    
    if([_sexValue isEqual:@"女"]){
        _bmRadio.on = NO;
        _boyRadio.on = NO;
        _girlRadio.on = YES;
    }
    
    
    
}


-(void)setNavgationBar{
    //处理导航开始
    self.navigationController.navigationBarHidden = YES;
    UINavigationBar *navgationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_TITLE_HEIGHT+20)];
    [navgationBar setBackgroundImage:[UIImage imageNamed:NAVBAR_BG_ICON] forBarMetrics:UIBarMetricsDefault];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:nil];
    //处理标题
    UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 160, 50, 44)];
    [titleLabel setText:@"修改性别"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    [titleLabel setFont:Font_Size(20)];
    
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
    [rbtn setFont:Font_Size(18)];
    
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
    [self dismissViewControllerAnimated:YES completion:^{
        //关闭时候到操作
    }];
}

-(void)saveUserInfo{
    
    NSString *pwd = _sexValue;
    if([StringUitl isEmpty:pwd]){
        [StringUitl alertMsg:@"对不起，请先选择性别！"withtitle:@"错误提示"];
        return;
    }
    
    //开始处理
    NSURL *edit_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REMOTE_URL,EDIT_USER_URL]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:edit_url];
    [ASIHTTPRequest setSessionCookies:nil];
    
    [request setUseCookiePersistence:YES];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setStringEncoding:NSUTF8StringEncoding];
    [request setPostValue:[StringUitl getSessionVal:LOGIN_USER_NAME] forKey:USER_NAME];
    [request setPostValue:_sexValue forKey:USER_SEX];
    [request buildPostBody];
    
    [request startAsynchronous];
    [request setDidFailSelector:@selector(editInfoFailed:)];
    [request setDidFinishSelector:@selector(editFinished:)];
    
    
}

- (void)editFinished:(ASIHTTPRequest *)req
{
    NSLog(@"login info->%@",[req responseString]);
    NSData *respData = [req responseData];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"error"]){//修改失败
        [StringUitl alertMsg:[jsonDic valueForKey:@"info"] withtitle:@"错误提示"];
    }
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"success"]){//修改成功
        //[StringUitl alertMsg:[jsonDic valueForKey:@"info"] withtitle:@"提示信息"];
        [StringUitl setSessionVal:_sexValue withKey:USER_SEX];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

- (void)editInfoFailed:(ASIHTTPRequest *)req
{
    
    [StringUitl alertMsg:@"请求数据失败！" withtitle:@"错误提示"];
}


- (IBAction)boyClick:(id)sender {
    _boyRadio.on = YES;
    _girlRadio.on = NO;
    _bmRadio.on = NO;
    _sexValue = @"男";
    
}

- (IBAction)girlClick:(id)sender {
    _boyRadio.on = NO;
    _bmRadio.on = NO;
    _girlRadio.on = YES;
    _sexValue = @"女";
}

- (IBAction)bmClick:(id)sender {
    _boyRadio.on = NO;
    _bmRadio.on = YES;
    _girlRadio.on = NO;
    _sexValue = @"保密";
}
@end
