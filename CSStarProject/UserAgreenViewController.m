//
//  UserAgreenViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-9-20.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "UserAgreenViewController.h"

@interface UserAgreenViewController ()

@end

@implementation UserAgreenViewController

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
    [self setNavgationBar];
    [self setWebcontent];
    
}

-(void)setWebcontent{
    
    NSString *requestUrl = [[NSString alloc] initWithFormat:@"%@%@",REMOTE_URL,USER_AGREEMENT_URL];
    NSArray *agreenArray = (NSArray *)[ConvertJSONData requestData:requestUrl];
    NSString *detailId;
    NSDictionary * agreenDic;
    if (agreenArray!=nil&&agreenArray.count>0) {
        agreenDic = [agreenArray objectAtIndex:0];
        detailId = [agreenDic valueForKey:@"_id"];
        
        NSString *url = [[NSString alloc] initWithFormat:@"%@/newsConte.aspx?newsid=%@",REMOTE_ADMIN_URL,detailId];
        NSURL *nsUrl = [[NSURL alloc] initWithString:url];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:nsUrl];
        [self.agreenView loadRequest:request];
        
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
    [titleLabel setText:@"用户协议"];
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
