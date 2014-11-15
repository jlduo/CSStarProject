//
//  ProjectCommentViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-14.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//
#import "DateUtil.h"
#import "UIViewController+HUD.h"
#import "UILabel+ContentSize.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "CommonViewController.h"
#import "ViewPassValueDelegate.h"
#import "ProjectCommentTableCell.h"

@interface ProjectCommentViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,
ViewPassValueDelegate,UITextViewDelegate>

#pragma mark 回填数据
@property(nonatomic,retain)NSMutableArray *proCommentList;
@property (weak, nonatomic) IBOutlet UITableView *projectCommentTable;
@property (weak, nonatomic) IBOutlet UILabel *commentDate;
@property (weak, nonatomic) IBOutlet UILabel *commentNum;
@property (weak, nonatomic) IBOutlet UILabel *comentTitle;

@end
