//
//  OtherUserViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-13.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CommonViewController.h"
#import "UserTableViewCell.h"
#import "UIViewController+HUD.h"
#import "SDImageCache.h"
#import "PeopleProListViewController.h"
#import "ViewPassValueDelegate.h"
#import "InitTabBarViewController.h"

@interface OtherUserViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,ViewPassValueDelegate>

@property(nonatomic,strong) NSDictionary * userData;
@property(nonatomic,strong) NSMutableDictionary * userProjectNums;
@property(nonatomic,weak) NSObject<ViewPassValueDelegate> *passValelegate;
@property(weak, nonatomic) IBOutlet UITableView *otherUserCenterTable;

@end
