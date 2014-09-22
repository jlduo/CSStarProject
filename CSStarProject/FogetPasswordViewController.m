//
//  FogetPasswordViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-9-20.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "FogetPasswordViewController.h"

@interface FogetPasswordViewController ()

@end

@implementation FogetPasswordViewController

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
    [self.fogetView.layer setCornerRadius:6.0];
    [self.fogetView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [self.forgetBgView.layer setCornerRadius:6.0];
    [self.forgetBtnView.layer setCornerRadius:6.0];
}

-(void)setNavgationBar{
    //处理导航开始
    self.navigationController.navigationBarHidden = YES;
    UINavigationBar *navgationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_TITLE_HEIGHT+20)];
    [navgationBar setBackgroundImage:[UIImage imageNamed:NAVBAR_BG_ICON] forBarMetrics:UIBarMetricsDefault];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:nil];
    //处理标题
    UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 160, 50, 44)];
    [titleLabel setText:@"找回密码"];
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
}

- (IBAction)clickForgetBtn:(id)sender {
    
    [self getPassword];
}

-(void)getPassword{
    
    NSString *phoneNum = self.forgetText.text;
    NSRange phoneRange = [phoneNum rangeOfString:@"输入"];
    BOOL isNameNull = FALSE;
    if([StringUitl isEmpty:phoneNum]||phoneRange.location!=NSNotFound){
        isNameNull = TRUE;
    }
    if(isNameNull==TRUE){
        [StringUitl alertMsg:@"对不起，请先输入手机号码！"withtitle:@"错误提示"];
        return;
    }
    
    //开始处理
    NSURL *edit_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REMOTE_URL,GET_PASSWORD_URL]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:edit_url];
    [ASIHTTPRequest setSessionCookies:nil];
    
    [request setUseCookiePersistence:YES];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setStringEncoding:NSUTF8StringEncoding];
    [request setPostValue:phoneNum forKey:USER_NAME];
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
        [StringUitl alertMsg:[jsonDic valueForKey:@"info"] withtitle:@"提示信息"];
        
    }
    
}

- (void)editInfoFailed:(ASIHTTPRequest *)req
{
    
    [StringUitl alertMsg:@"请求数据失败！" withtitle:@"错误提示"];
}

//关闭键盘
-(void)dismissKeyBoard{
    [self.forgetText resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismissKeyBoard];
}


@end
