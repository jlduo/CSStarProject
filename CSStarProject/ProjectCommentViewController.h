//
//  ProjectCommentViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-14.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//
#import "DateUtil.h"
#import "MBProgressHUD.h"
#import "UILabel+ContentSize.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "CommonViewController.h"
#import "ViewPassValueDelegate.h"
#import "ProjectCommentTableCell.h"

@interface ProjectCommentViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,
ViewPassValueDelegate,UITextViewDelegate,MBProgressHUDDelegate>

#pragma mark 回填数据
@property(nonatomic,retain)NSMutableArray *proCommentList;

@end
