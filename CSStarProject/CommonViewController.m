//
//  CommonViewController.m
//  CSStarProject
//  视图控制器基类 处理公用方法
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//
#import "CommonViewController.h"
#import "UserViewController.h"
#import "LoginViewController.h"

@interface CommonViewController (){
    
    NSString * leftIconName;
    NSString * rightIconName;
}

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
-(UINavigationBar *)setNavBarWithTitle:(NSString *)title hasLeftItem:(BOOL) lItem hasRightItem:(BOOL) rItem leftIcon:(NSString *)leftIcon rightIcon:(NSString *)rightIcon {
    
    UINavigationBar *navgationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_TITLE_HEIGHT+20)];
    [navgationBar setBackgroundImage:[UIImage imageNamed:NAVBAR_BG_ICON] forBarMetrics:UIBarMetricsDefault];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    if(lItem){//设置左边按钮
        navItem.leftBarButtonItem = [self getLeftUIBarButtonItemWithTarget:self withIconName:leftIcon];
    }
    
    if(rItem){//设置右边按钮
        navItem.rightBarButtonItem = [self getRightUIBarButtonItemWithTarget:self withIconName:rightIcon];
    }
    
    navItem.titleView = [self setTitleWithName:title];
    [navgationBar pushNavigationItem:navItem animated:YES];
    
    return navgationBar;
    
}

#pragma mark 设置左边按钮
-(UIBarButtonItem *)getLeftUIBarButtonItemWithTarget:(id)target withIconName:(NSString *)iconName{
    if([self isEmpty:iconName]){
        leftIconName = NAVBAR_LEFT_ICON;
    }else{
        leftIconName = iconName;
    }
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [lbtn setFrame:CGRectMake(0, 0, 32, 32)];
    [lbtn setBackgroundImage:[UIImage imageNamed:leftIconName] forState:UIControlStateNormal];
    [lbtn addTarget:target action:@selector(goPreviou) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:lbtn];
    return leftBtnItem;
}

#pragma mark 设置右边按钮
-(UIBarButtonItem *)getRightUIBarButtonItemWithTarget:(id)target withIconName:(NSString *)iconName{
    if([self isEmpty:iconName]){
        rightIconName = NAVBAR_RIGHT_ICON;
    }else{
        rightIconName = iconName;
    }
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rbtn setFrame:CGRectMake(0, 0, 32, 32)];
    [rbtn setBackgroundImage:[UIImage imageNamed:rightIconName] forState:UIControlStateNormal];
    [rbtn addTarget:target action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rbtn];
    return rightBtnItem;
}

#pragma mark 设置导航标题
-(UILabel *)setTitleWithName:(NSString *)titleName{
    
    UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 160, 50, 44)];
    [titleLabel setText:titleName];
    [titleLabel setTextColor:[StringUitl colorWithHexString:@"#FFFFFF"]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.font = BANNER_FONT;
    [titleLabel setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    
    return titleLabel;
    
}

-(void)goPreviou{
    NSLog(@"back");
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)goForward{
    NSLog(@"go");
    if([StringUitl checkLogin]==TRUE){

        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UserViewController *userView =  [storyBoard instantiateViewControllerWithIdentifier:@"userCenter"];
        [self.navigationController pushViewController:userView animated:YES];
        
    }else{
        
        [StringUitl setSessionVal:@"NAV" withKey:FORWARD_TYPE];
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginView =  [storyBoard instantiateViewControllerWithIdentifier:@"userLogin"];
        [self.navigationController pushViewController:loginView animated:YES];
        
    }
    
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

//判断字符串为空
-(BOOL)isEmpty:(NSString *)str{
    if(Nil==str||0==str.length){
        return true;
    }else{
        return false;
    }
}

//判断字符串不为空
-(BOOL)isNotEmpty:(NSString *)str{
    if(![self isEmpty:str]){
        return true;
    }else{
        return false;
    }
}

//提示信息
-(void)alertMsg:(NSString *)msg withtitle:(NSString *)title{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确 定"
                                          otherButtonTitles:nil,nil];
    [alert show];
}

-(UIStoryboard *)getStoryBoard:(NSString *)sbName{
    if([StringUitl isEmpty:sbName])sbName = @"Main";
    return [UIStoryboard storyboardWithName:sbName bundle:nil];
}

-(UIViewController *)getVCFromSB:(NSString *)vname{
    return [[self getStoryBoard:nil] instantiateViewControllerWithIdentifier:vname];
}


@end
