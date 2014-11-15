//
//  myCommentViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-9.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
#import "InitTabBarViewController.h"
#import "ASIHTTPRequest.h"
#import "UIViewController+HUD.h"
#import "ASIFormDataRequest.h" 
#import "ViewPassValueDelegate.h"
#import "PeopleDetailViewController.h"
#import "userMessageCommentNewTableViewCell.h"

@interface myCommentViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)NSObject<ViewPassValueDelegate> *passValelegate;
@end
