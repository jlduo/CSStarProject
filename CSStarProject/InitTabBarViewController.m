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
    UIButton * _previousBtn;//记录上次选择的按钮
    NSMutableArray *btnArray;
    UIView *_tBarView;
    NSString *ctitle;
    UILabel *btnLabel;
    NSMutableArray *titleArray;
    UIImageView *imageView;
}

@end

@implementation InitTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //首先隐藏自带tabbar
    self.tabBar.hidden=YES;
    [self initCoustomBtnTabar];
    [self setSelectedIndex:0];
    
}


//隐藏自定义滚动条
-(void)hiddenDIYTaBar{
    _tBarView.hidden = YES;
}

//显示自定义滚动条
-(void)showDIYTaBar{
    _tBarView.hidden = NO;
}

#pragma mark 自定义tabbar
-(void)initCoustomBtnTabar{
    CGRect viewRect = CGRectMake(0, self.view.frame.size.height-TABBAR_HEIGHT, SCREEN_WIDTH, TABBAR_HEIGHT);
    _tBarView = [[UIView alloc] initWithFrame:viewRect];
    //设置背景
    //_tBarView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"tbarbg.png"]];
    
    //初始化滑动条
    btnLabel = [[UILabel alloc]init];
    //[btnLabel setBackgroundColor:[UIColor greenColor]];
    //[btnLabel setFrame:CGRectMake(0, -1, BTN_WIDTH, SLIDER_HEIGHT)];
    
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navline.png"]];
    [imageView setFrame:CGRectMake(0, -1, BTN_WIDTH, SLIDER_HEIGHT)];
    
    [_tBarView addSubview:imageView];
    [self.view addSubview:_tBarView];
    
    
    btnArray = [NSMutableArray array];
    titleArray = [NSMutableArray array];
    for (NSInteger i=0; i<5; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*BTN_WIDTH, 0, BTN_WIDTH, BTN_HEIGHT);
        btn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"con_bg@2x.jpg"]];
        btn.titleLabel.font = Font_Size(10);
        
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabbar%lu@2x.png",(unsigned long)i]] forState:UIControlStateNormal];
        //[btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabbar%lu@2x.png",(unsigned long)i]] forState:UIControlStateHighlighted];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
        
        [btn setImageEdgeInsets:UIEdgeInsetsMake(4, (BTN_WIDTH-30)/2, 16, (BTN_HEIGHT-24)/2)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(40, -50, 8, 0)];
        
        btn.tag = i+11;
        //监听按钮点击切换视图
        [btn addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchDown];
        switch (i) {
            case 0:
                ctitle = @"首 页";
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(40, -50, 8, 0)];
                break;
            case 1:
                ctitle = @"美女私房";
                break;
            case 2:
                ctitle = @"星城故事";
                break;
            case 3:
                ctitle = @"活动众筹";
                break;
            case 4:
                ctitle = @"朋友圈";
                break;
            default:
                break;
        }
        
        [btn setTitle:ctitle forState:UIControlStateNormal];
        [btnArray addObject:btn];
        [titleArray addObject:ctitle];
        [_tBarView addSubview:btn];
        
    }
    
}


#pragma mark 监听按钮点击切换视图
- (void)changeViewController:(UIButton *)sender {
    //根据按钮到tag属性来确定点击切换到对应视图
    self.selectedIndex = (sender.tag-11);
    sender.enabled = YES;
    //    if(_previousBtn!=sender){
    //        sender.enabled = YES;
    //    }
    _previousBtn = sender;
    [self changeTabsFrameWithAnimation:sender];
    sender.selected = YES;
    
}

#pragma mark控制滑动条效果
-(void)changeTabsFrameWithAnimation:(UIButton *) sender{
    
    [UIView animateWithDuration:0.35 animations:^{
        CGRect labelFrame = CGRectMake(self.selectedIndex * BTN_WIDTH, -1, BTN_WIDTH, SLIDER_HEIGHT);
        [imageView setFrame:labelFrame];
        
        
        //NewNavViewController *selectedController = (NewNavViewController *)self.selectedViewController;
        //[self selectedController setItemTitleName:[titleArray objectAtIndex:self.selectedIndex]];
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)changeTabsFrame{
    
    [UIView animateWithDuration:0.35 animations:^{
        CGRect labelFrame = CGRectMake(0, -1, BTN_WIDTH, SLIDER_HEIGHT);
        [imageView setFrame:labelFrame];
    } completion:^(BOOL finished) {
        
    }];
    
}

@end
