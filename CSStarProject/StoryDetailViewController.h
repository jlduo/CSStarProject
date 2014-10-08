//
//  StoryDetailViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-11.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CommonViewController.h"
#import "InitTabBarViewController.h"
#import "StoryViewController.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "LoginViewController.h"
#import "StoryCommentViewController.h"

@interface StoryDetailViewController : CommonViewController<ViewPassValueDelegate,UITextViewDelegate,MBProgressHUDDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate>{
    // 声明一个参数传递代理
    NSObject<ViewPassValueDelegate> *delegate;
    MBProgressHUD *HUD;
}
@end
