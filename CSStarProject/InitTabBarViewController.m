//
//  InitTabBarViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-8-27.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//
#import "common.h"
#import "InitTabBarViewController.h"

@interface InitTabBarViewController (){
    UIImageView *_tabBarBG;
    UIImageView *_selectView;
}

@end

@implementation InitTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTabarView];
    [self setSelectedIndex:0];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBar.hidden = YES;
    }
    return self;
}


//显示自定义滚动条
-(void)showDIYTaBar{
    [UIView animateWithDuration:0.3 animations:^{
        _tabBarBG.frame = CGRectMake(0, self.view.frame.size.height-TABBAR_HEIGHT, SCREEN_WIDTH, TABBAR_HEIGHT);
    }];
}

//隐藏自定义滚动条
-(void)hiddenDIYTaBar{
    [UIView animateWithDuration:0.3 animations:^{
        _tabBarBG.frame = CGRectMake(-SCREEN_WIDTH, self.view.frame.size.height-TABBAR_HEIGHT, SCREEN_WIDTH, TABBAR_HEIGHT);
    }];
}

#pragma mark 自定义tabbar
-(void)initTabarView{
   
    // 初始化自定义TabBar背景
    _tabBarBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-TABBAR_HEIGHT, SCREEN_WIDTH, TABBAR_HEIGHT)];
    _tabBarBG.userInteractionEnabled = YES;
    _tabBarBG.image = [UIImage imageNamed:TABR_BG_ICON];
    [self.view addSubview:_tabBarBG];
    
    // 初始化自定义选中背景
    _selectView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BTN_WIDTH, BTN_HEIGHT)];
    _selectView.image = [UIImage imageNamed:TABR_SBG_ICON];
    [_tabBarBG addSubview:_selectView];
    
    // 初始化自定义TabBarItem -> UIButton
    float coordinateX = 0;
    for (int index = 0; index < 5; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.tag = index;
        button.frame = CGRectMake(index*BTN_WIDTH, 0, BTN_WIDTH, BTN_HEIGHT);
        NSString *imageName = [NSString stringWithFormat:@"tabbar%d@2x.png", index];
        [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [_tabBarBG addSubview:button];
        [button addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchDown];
        coordinateX += 62;
    }
    
}

#pragma mark 监听按钮点击切换视图
- (void)changeViewController:(UIButton *)sender
{
    if([StringUitl checkLogin]){
        
         self.selectedIndex = sender.tag;
         [UIView animateWithDuration:0.2 animations:^{
             _selectView.frame = CGRectMake(sender.tag*BTN_WIDTH, 0, BTN_WIDTH, BTN_HEIGHT);
         }];
        
    }else{
        LoginViewController *loginView = [[LoginViewController alloc]init];
        [StringUitl setSessionVal:@"TAB" withKey:FORWARD_TYPE];
        //[self.tabBarController.navigationController pushViewController:loginView animated:YES];
        [self presentViewController:loginView animated:YES completion:nil];
    }
}


#pragma mark控制滑动条效果
-(void)changeTabsFrameWithAnimation:(UIButton *) sender{
    
    [UIView animateWithDuration:0.35 animations:^{
        //CGRect labelFrame = CGRectMake(self.selectedIndex * BTN_WIDTH, -1, BTN_WIDTH, SLIDER_HEIGHT);
        //[imageView setFrame:labelFrame];
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)changeTabsFrame{
    
    [UIView animateWithDuration:0.35 animations:^{
        //CGRect labelFrame = CGRectMake(0, -1, BTN_WIDTH, SLIDER_HEIGHT);
        //[imageView setFrame:labelFrame];
    } completion:^(BOOL finished) {
        
    }];
    
}

@end
