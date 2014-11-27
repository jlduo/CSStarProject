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
        self.tabBarController.hidesBottomBarWhenPushed = true;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showLoading:@"加载中..."];
    [self setNavgationBar];
    self.view.backgroundColor = [StringUitl colorWithHexString:@"#F5F5F5"];
    
    [self.boyBg setAlpha:0.8f];
    [StringUitl setViewBorder:self.boyBg withColor:@"#CCCCCC" Width:0.5f];
    
    [self.girlBg setAlpha:0.8f];
    [StringUitl setViewBorder:self.girlBg withColor:@"#CCCCCC" Width:0.5f];
    
    [self.bmBg setAlpha:0.8f];
    [StringUitl setViewBorder:self.bmBg withColor:@"#CCCCCC" Width:0.5f];
    
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
    titleLabel.font = main_font(20);
    
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
    rbtn.titleLabel.font=main_font(18);
    
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
    [super viewWillAppear:YES];
    [self hideHud];
}

-(void)saveUserInfo{

    NSString *sex = _sexValue;
    if([StringUitl isEmpty:sex]){
        [self showNo:@"对不起，请先选择性别！"];
        return;
    }
    
    [self showLoading:@"数据保存中..."];
    //开始处理
    NSString * username = [StringUitl getSessionVal:LOGIN_USER_NAME];
    NSDictionary *parameters = @{USER_NAME:username,USER_SEX:sex};
    [HttpClient updateUserInfo:parameters
                        isjson:FALSE
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           NSDictionary *jsonDic = [StringUitl getDicFromData:responseObject];
                           if([[jsonDic valueForKey:@"status"] isEqualToString:@"error"]){//修改失败
                               [self hideHud];
                               [self showNo:[jsonDic valueForKey:@"info"]];
                           }
                           if([[jsonDic valueForKey:@"status"] isEqualToString:@"success"]){//修改成功
                               [StringUitl setSessionVal:_sexValue withKey:USER_SEX];
                               [self hideHud];
                               [self showOk:[jsonDic valueForKey:@"info"]];
                               [self.navigationController popViewControllerAnimated:YES];
                               
                           }
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                           [self requestFaild:error];
                           
                       }
     ];
    
    
}

- (void)requestFaild:(NSError *)error
{
    [self hideHud];
    NSLog(@"error=%@",error);
    [self showNo:@"请求失败,网络错误!"];
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
