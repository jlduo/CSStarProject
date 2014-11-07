//
//  StoryDetailViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-11.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "CommonViewController.h"
#import "InitTabBarViewController.h"
#import "StoryViewController.h"
#import "ASIHTTPRequest.h"
#import <ShareSDK/ShareSDK.h>
#import "UIViewController+HUD.h"
#import "ASIFormDataRequest.h"
#import "LoginViewController.h"
#import "StoryCommentViewController.h"

@interface StoryDetailViewController : CommonViewController<ViewPassValueDelegate,UITextViewDelegate,
UIGestureRecognizerDelegate,MWPhotoBrowserDelegate>{
    // 声明一个参数传递代理
    NSObject<ViewPassValueDelegate> *delegate;
    
}

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@end
