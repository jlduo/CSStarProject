//
//  CommonViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//
#import "common.h"
#import "StringUitl.h"
#import "MBProgressHUD.h"
#import <UIKit/UIKit.h>
#import "ConvertJSONData.h"
#import "AllAroundPullView.h"

@interface CommonViewController : UIViewController

@property (nonatomic, strong) UIRefreshControl* refreshControl;


- (UIButton *)getCustomLoadMoreButton;

-(void) alignLabelWithTop:(UILabel *)label;

-(UIRefreshControl *)getUIRefreshControl:(SEL)action withTarget:(id)target;

-(UINavigationBar *)setNavBarWithTitle:(NSString *)title hasLeftItem:(BOOL) lItem hasRightItem:(BOOL) rItem leftIcon:(NSString *)leftIcon rightIcon:(NSString *)rightIcon;

-(void)goPreviou;
-(void)goForward;

-(BOOL)isEmpty:(NSString *)str;
-(BOOL)isNotEmpty:(NSString *)str;

-(void)alertMsg:(NSString *)msg withtitle:(NSString *)title;
-(UIStoryboard *)getStoryBoard:(NSString *)sbName;
-(UIViewController *)getVCFromSB:(NSString *)vname;
@end
