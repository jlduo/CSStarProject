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
    
    int current_index;
    
    NSMutableArray *btnArray;
}

@end

@implementation InitTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTabarView];
    [self setSelectedIndex:0];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTabSelect) name:@"changeTabar" object:nil];
    
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
    UIButton *button;
    btnArray = [[NSMutableArray alloc]init];
    for (int index = 0; index < 5; index++) {
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.tag = index;
        button.frame = CGRectMake(index*BTN_WIDTH, 0, BTN_WIDTH, BTN_HEIGHT);
        NSString *imageName = [NSString stringWithFormat:@"tabbar%d@2x.png", index];
        [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [_tabBarBG addSubview:button];
        [button addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchDown];
        coordinateX += 62;
        [btnArray addObject:button];
        
    }
    
    self.selectedIndex = 0;
    [self changeSelectedBtn:0];
    
}


-(void)changeTabSelect{
    self.selectedIndex = current_index;
    [self changeSelectedBtn:current_index];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showContent" object:nil];

}

-(void)changeSelectedBtn:(int)sender{
    
    for (int i=0; i<btnArray.count; i++) {
        UIButton *sbtn = (UIButton *)btnArray[i];
        if(sbtn.tag == sender){
            NSString *imageName = [NSString stringWithFormat:@"tabbar%don@2x.png", i];
            [sbtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [sbtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
            [sbtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
            [self changTBarBgFrame:i];
        }else{
            NSString *imageName = [NSString stringWithFormat:@"tabbar%d@2x.png", i];
            [sbtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [sbtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
        }
    }
}

-(void)changTBarBgFrame:(int)index{

    [UIView animateWithDuration:0.2 animations:^{
       _selectView.frame = CGRectMake(index*BTN_WIDTH, 0, BTN_WIDTH, BTN_HEIGHT);
    } completion:nil];
    
}

#pragma mark 监听按钮点击切换视图
- (void)changeViewController:(UIButton *)sender
{
    current_index = sender.tag;
    //NSLog(@"index=%d",current_index);
    if(sender.tag==0){
        
        self.selectedIndex = 0;
        [self changeSelectedBtn:current_index];
        
    }else{
        
        if([StringUitl checkLogin]){
            self.selectedIndex = sender.tag;
            [self changeSelectedBtn:current_index];
        }else{
            if(sender.tag!=0){
                [StringUitl setSessionVal:@"TAB" withKey:FORWARD_TYPE];
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LoginViewController *loginView =  [storyBoard instantiateViewControllerWithIdentifier:@"userLogin"];
                passDelegate = loginView;
                [passDelegate passValue:[NSString stringWithFormat:@"%d",current_index]];
                [self presentViewController:loginView animated:YES completion:nil];
            }
        }
        
    }
    
}



-(void)passValue:(NSString *)val{
    NSLog(@"val=%@",val);
    int sl_index = [val intValue];
    self.selectedIndex = sl_index;
    _selectView.frame = CGRectMake(sl_index*BTN_WIDTH, 0, BTN_WIDTH, BTN_HEIGHT);
    [self changeSelectedBtn:sl_index];
}

-(void)passDicValue:(NSDictionary *)vals{
    
    
}

@end
