//
//  GirlsPhotosViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-20.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
#import "UIImageView+WebCache.h"
#import "StringUitl.h"
#import "CommonViewController.h"
#import "ViewPassValueDelegate.h"
#import "InitTabBarViewController.h"
#import "StoryCommentViewController.h"
#import "StoryDetailViewController.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface GirlsPhotosViewController : UIViewController<UIScrollViewDelegate,ViewPassValueDelegate,UITextViewDelegate>{
    // 声明一个参数传递代理
    NSObject<ViewPassValueDelegate> *passValelegate;
}

@end
