//
//  InitTabBarViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-8-27.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
#import "StringUitl.h"
#import "LoginViewController.h"
#import "GirlsViewController.h"

@interface InitTabBarViewController : UITabBarController


-(void)hiddenDIYTaBar;
-(void)showDIYTaBar;
-(void)changeTabsFrame;

@end
