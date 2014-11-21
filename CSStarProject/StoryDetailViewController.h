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
#import <ShareSDK/ShareSDK.h>
#import "UIViewController+HUD.h"
#import "LoginViewController.h"
#import "StoryCommentViewController.h"

@interface StoryDetailViewController : CommonViewController<ViewPassValueDelegate,UITextViewDelegate,
UIGestureRecognizerDelegate,MWPhotoBrowserDelegate,UIWebViewDelegate>

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, weak) NSObject<ViewPassValueDelegate> *delegate;
@property (weak, nonatomic) IBOutlet UIWebView *detailContentView;
@property (weak, nonatomic) IBOutlet UILabel *contentTitle;
@property (weak, nonatomic) IBOutlet UILabel *contentDate;
@property (weak, nonatomic) IBOutlet UILabel *columnTitle;
@property (weak, nonatomic) IBOutlet UIImageView *likeImgView;
@property (weak, nonatomic) IBOutlet UILabel *clickNum;
@property (weak, nonatomic) IBOutlet UIView *contentBackView;

@end
