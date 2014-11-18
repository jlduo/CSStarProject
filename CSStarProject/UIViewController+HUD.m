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
#import "common.h"
#import <objc/runtime.h>
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "XHFriendlyLoadingView.h"

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (HUD)

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)showOk:(NSString *)okMsg{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    if(TIPS_TYPE==1){
        [MBProgressHUD showSuccess:okMsg toView:view];
    }else{
        [self showCAlert:okMsg widthType:SUCCESS_LOGO];
    }
}

-(void)showNo:(NSString *)noMsg{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    if(TIPS_TYPE==1){
       [MBProgressHUD showError:noMsg toView:view];
    }else{
        [self showCAlert:noMsg widthType:ERROR_LOGO];
    }
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.labelText = hint;
    HUD.removeFromSuperViewOnHide = YES;
    [view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
}

- (void)showHint:(NSString *)hint {
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = IS_IPHONE_5?200.f:150.f;
    hud.removeFromSuperViewOnHide = YES;
    [self setHUD:hud];
    [hud hide:YES afterDelay:1];
}

- (void)showHint:(NSString *)hint yOffset:(float)yOffset {
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = IS_IPHONE_5?200.f:150.f;
    hud.yOffset += yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [self setHUD:hud];
    [hud hide:YES afterDelay:1.0];
}

-(void)showCAlert:(NSString *)msg widthType:(NSString *)tp{
    
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:tp]];
    [imgView setFrame:CGRectMake(0, 0, 48, 48)];
    hud.customView = imgView;
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = msg;
    hud.alpha = 0.5;
    hud.dimBackground = YES;
	[self setHUD:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:1.0];
    
}

-(void)showLoading:(NSString *)msg{
    
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = msg;
    hud.dimBackground = YES;
    hud.alpha = 0.5;
	[self setHUD:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:2.0];
}


- (void)hideHud{
    [[self HUD] hide:YES];
}


- (UIViewController *)findViewController:(UIViewController *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}



@end
