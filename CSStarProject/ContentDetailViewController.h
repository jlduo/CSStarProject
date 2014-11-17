//
//  ContentDetailViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-13.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "CommonViewController.h"
#import "ViewPassValueDelegate.h"
#import "InitTabBarViewController.h"

@interface ContentDetailViewController : CommonViewController<ViewPassValueDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,MWPhotoBrowserDelegate,UIWebViewDelegate>


#pragma mark 活动众筹数据
@property(nonatomic,retain)NSDictionary *contentData;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (weak, nonatomic) IBOutlet MarqueeLabel *contentTitle;
@property (weak, nonatomic) IBOutlet UIWebView *contentView;
@property (weak, nonatomic) IBOutlet UIView *contentBackView;

@end
