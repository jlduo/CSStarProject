//
//  StoryCommentViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-16.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CommonViewController.h"
#import "InitTabBarViewController.h"
#import "ASIHTTPRequest.h"
#import "UIViewController+HUD.h"
#import "ASIFormDataRequest.h"
#import "ViewPassValueDelegate.h"
#import "LoginViewController.h"
#import "StoryCommentTableCell.h"
#import "XHFriendlyLoadingView.h"

@interface StoryCommentViewController : CommonViewController<ViewPassValueDelegate,UITextViewDelegate,
UITableViewDataSource,UITableViewDelegate>

@end
