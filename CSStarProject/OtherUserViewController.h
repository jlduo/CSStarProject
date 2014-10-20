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
#import "PeopleProListViewController.h"
#import "ViewPassValueDelegate.h"
#import "InitTabBarViewController.h"

@interface OtherUserViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,ViewPassValueDelegate>{
    // 声明一个参数传递代理
    NSObject<ViewPassValueDelegate> *passValelegate;
}

@property(nonatomic,retain) NSDictionary * userData;
@property(nonatomic,retain) NSMutableDictionary * userProjectNums;

@end
