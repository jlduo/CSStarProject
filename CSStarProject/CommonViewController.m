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
    
    UINavigationBar *navgationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, STATU_BAR_HEIGHT, SCREEN_WIDTH, NAV_TITLE_HEIGHT)];
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
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goForward{
    NSLog(@"go");
    UserViewController *userView = [[UserViewController alloc] init];
    [self.navigationController pushViewController:userView animated:YES];
    
}

#pragma mark 获取下拉刷新组件
-(UIRefreshControl *)getUIRefreshControl:(SEL)action withTarget:(id)target{
    //初始化UIRefreshControl
    UIRefreshControl *rc = [[UIRefreshControl alloc] init];
    rc.attributedTitle = [[NSAttributedString alloc]initWithString:REFRESH_TITLE];
    [rc addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    rc.tintColor = [UIColor lightGrayColor];
    rc.alpha = 0.5f;
    return rc;
}

- (UIButton *)getCustomLoadMoreButton {
    UIButton *_loadMoreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,40)];
    [_loadMoreButton setTitle:@"加载更多" forState:UIControlStateNormal];
    _loadMoreButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_loadMoreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_loadMoreButton setBackgroundColor:[UIColor colorWithWhite:0.922 alpha:1.000]];
    [_loadMoreButton.layer setMasksToBounds:YES];
    //[_loadMoreButton.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
    return _loadMoreButton;
}


-(void) alignLabelWithTop:(UILabel *)label {
    CGSize maxSize = CGSizeMake(label.frame.size.width, 999);
    label.adjustsFontSizeToFitWidth = NO;
    CGSize actualSize = [label.text sizeWithFont:label.font constrainedToSize:maxSize lineBreakMode:label.lineBreakMode];
    CGRect rect = label.frame;
    rect.size.height = actualSize.height;
    label.frame = rect;
}



@end
