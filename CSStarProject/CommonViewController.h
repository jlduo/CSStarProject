//
//  CommonViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//
#import "common.h"
#import <UIKit/UIKit.h>
#import "ConvertJSONData.h"
#import "AllAroundPullView.h"

@interface CommonViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIRefreshControl* refreshControl;


- (UIButton *)getCustomLoadMoreButton;

-(void) alignLabelWithTop:(UILabel *)label;

-(UIRefreshControl *)getUIRefreshControl:(SEL)action withTarget:(id)target;

-(UINavigationBar *)setNavBarWithTitle:(NSString *)title hasLeftItem:(BOOL) lItem hasRightItem:(BOOL) rItem;

-(void)goPreviou;
-(void)goForward;

-(BOOL)isEmpty:(NSString *)str;
-(BOOL)isNotEmpty:(NSString *)str;
@end
