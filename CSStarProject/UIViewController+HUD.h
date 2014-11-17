/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>
#import "common.h"

@interface UIViewController (HUD)

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;

-(void)showOk:(NSString *)okMsg;
-(void)showNo:(NSString *)noMsg;
- (void)showHint:(NSString *)hint;
-(void)showLoading:(NSString *)msg;
// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;
-(void)showCAlert:(NSString *)msg widthType:(NSString *)tp;
- (UIViewController *)findViewController:(UIViewController *)sourceView;

@end
