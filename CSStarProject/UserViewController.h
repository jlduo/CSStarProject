//
//  UserViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
#import "UIImageView+WebCache.h"
#import "CommonViewController.h"
#import "InitTabBarViewController.h"
#import "MyCommentsViewController.h"
#import "ViewPassValueDelegate.h"
#import "MyProjectListViewController.h"
#import "MyOrderListViewController.h"
#import "UserAddressListViewController.h"


@interface UserViewController:CommonViewController<UITableViewDataSource,UITableViewDelegate,ViewPassValueDelegate>

#pragma mark  用户数据
@property(nonatomic,strong)NSMutableArray *userDataList;
@property(nonatomic,strong)NSMutableDictionary * userProjectNums;
 // 声明一个参数传递代理
@property(nonatomic,weak)NSObject<ViewPassValueDelegate> *passValelegate;

@property (weak, nonatomic) IBOutlet UITableView *userCenterTable;

@end
