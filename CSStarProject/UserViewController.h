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
#import "myCommentViewController.h"
#import "ViewPassValueDelegate.h"
#import "MyProjectListViewController.h"
#import "ReciverAddressViewController.h"


@interface UserViewController:CommonViewController<UITableViewDataSource,UITableViewDelegate,ViewPassValueDelegate>{
    // 声明一个参数传递代理
    NSObject<ViewPassValueDelegate> *passValelegate;
}

#pragma mark  用户数据
@property(nonatomic,retain)NSMutableArray *userDataList;
@property(nonatomic,retain) NSMutableDictionary * userProjectNums;

@end
