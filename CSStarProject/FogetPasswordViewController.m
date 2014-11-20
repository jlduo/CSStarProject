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
        self.tabBarController.hidesBottomBarWhenPushed = TRUE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavgationBar];
    self.view.backgroundColor = [StringUitl colorWithHexString:@"#F5F5F5"];
    
    [StringUitl setCornerRadius:self.fogetView withRadius:5.0f];
    [StringUitl setCornerRadius:self.forgetBgView withRadius:5.0f];
    [StringUitl setCornerRadius:self.forgetBtnView withRadius:5.0f];
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
    titleLabel.font = TITLE_FONT;
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
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickForgetBtn:(id)sender {
    [self dismissKeyBoard];
    [self getPassword];
}

-(void)resetFBtn:(int) flag{
    if(flag==0){
        [self.forgetBtnView setEnabled:TRUE];
        [self.forgetBtnView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.forgetBtnView setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.forgetBtnView setBackgroundColor:[UIColor redColor]];
    }else{
        [self.forgetBtnView setEnabled:FALSE];
        [self.forgetBtnView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.forgetBtnView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [self.forgetBtnView setBackgroundColor:[UIColor grayColor]];
    }
}

-(void)getPassword{
    
    NSString *phoneNum = self.forgetText.text;
    NSRange phoneRange = [phoneNum rangeOfString:@"输入"];
    BOOL isNameNull = FALSE;
    if([StringUitl isEmpty:phoneNum]||phoneRange.location!=NSNotFound){
        isNameNull = TRUE;
    }
    if(isNameNull==TRUE){
        [self showNo:@"请先输入手机号码"];
        return;
    }
    
    [self resetFBtn:1];
    //开始处理
    [HttpClient findPassword:phoneNum
                      isjson:TRUE
                    success:^(AFHTTPRequestOperation *operation, id responseObject)
                    {
                        
                        NSDictionary *jsonDic = (NSDictionary *)responseObject;
                        if([[jsonDic valueForKey:@"status"] isEqualToString:@"error"]){//修改失败
                            
                            [self resetFBtn:0];
                            [self showNo:[jsonDic valueForKey:@"info"]];
                            
                        }
                        if([[jsonDic valueForKey:@"status"] isEqualToString:@"success"]){//修改成功
                            
                            [self resetFBtn:0];
                            [self showOk:@"新的密码已发送!"];
                            
                        }
                        
                    }
     
                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
                    {
                        
                        [self requestFailed:error];
                        
                    }
     ];
    
    
}

- (void)requestFailed:(NSError *)error
{
    NSLog(@"error=%@",error);
    [self hideHud];
    [self resetFBtn:0];
    [self showNo:@"请求失败,网络错误!"];
}

//关闭键盘
-(void)dismissKeyBoard{
    [self.forgetText resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismissKeyBoard];
}


@end
