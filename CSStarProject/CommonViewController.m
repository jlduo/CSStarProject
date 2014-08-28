//
//  CommonViewController.m
//  CSStarProject
//  视图控制器基类 处理公用方法
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//
#import "common.h"
#import "CommonViewController.h"
#import "UserViewController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


-(void)loadView{
    [super loadView];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark 处理navgationbar
-(UINavigationBar *)setNavBarWithTitle:(NSString *)title hasLeftItem:(BOOL) lItem hasRightItem:(BOOL) rItem{
    
    UINavigationBar *navgationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, STATU_BAR_HEIGHT, SCREEN_WIDTH, TABBAR_HEIGHT)];
    [navgationBar setBackgroundImage:[UIImage imageNamed:NAVBAR_BG_ICON] forBarMetrics:UIBarMetricsDefault];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    if(lItem){//设置左边按钮
        navItem.leftBarButtonItem = [self getLeftUIBarButtonItemWithTarget:self];
    }
    
    if(rItem){//设置右边按钮
        navItem.rightBarButtonItem = [self getRightUIBarButtonItemWithTarget:self];
    }
    
    navItem.titleView = [self setTitleWithName:title];
    [navgationBar pushNavigationItem:navItem animated:YES];
    
    return navgationBar;
    
}

#pragma mark 设置左边按钮
-(UIBarButtonItem *)getLeftUIBarButtonItemWithTarget:(id)target{
    
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [lbtn setFrame:CGRectMake(0, 0, 32, 32)];
    [lbtn setBackgroundImage:[UIImage imageNamed:NAVBAR_LEFT_ICON] forState:UIControlStateNormal];
    [lbtn addTarget:target action:@selector(goPreviou) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:lbtn];
    return leftBtnItem;
}

#pragma mark 设置右边按钮
-(UIBarButtonItem *)getRightUIBarButtonItemWithTarget:(id)target{
    
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rbtn setFrame:CGRectMake(0, 0, 32, 32)];
    [rbtn setBackgroundImage:[UIImage imageNamed:NAVBAR_RIGHT_ICON] forState:UIControlStateNormal];
    [rbtn addTarget:target action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rbtn];
    return rightBtnItem;
}

#pragma mark 设置导航标题
-(UILabel *)setTitleWithName:(NSString *)titleName{
    
    UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 160, 50, 44)];
    [titleLabel setText:titleName];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    
    return titleLabel;
    
}




-(void)goPreviou{
    NSLog(@"back");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)goForward{
    NSLog(@"go");
    UserViewController *userView = [[UserViewController alloc] init];
    [self.navigationController pushViewController:userView animated:YES];
    
}

@end
