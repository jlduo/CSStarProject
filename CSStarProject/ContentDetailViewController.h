//
//  ContentDetailViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-13.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "ViewPassValueDelegate.h"
#import "InitTabBarViewController.h"

@interface ContentDetailViewController : CommonViewController<ViewPassValueDelegate,UIWebViewDelegate>


#pragma mark 活动众筹数据
@property(nonatomic,retain)NSDictionary *contentData;

@end
