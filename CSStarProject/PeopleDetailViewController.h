//
//  PeopleDetailViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-10.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"
#import "CommonViewController.h"
#import "PeopleTableDetailCell.h"
#import "PeopleCenterCell.h"
#import "PeopleCommentCell.h"
#import "UIViewController+HUD.h"
#import "OtherUserViewController.h"
#import "ReturnsViewController.h"
#import "InitTabBarViewController.h"
#import "ContentDetailViewController.h"
#import "ProjectCommentViewController.h"
#import "ViewPassValueDelegate.h"


@interface PeopleDetailViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,
ViewPassValueDelegate>{
    // 声明一个参数传递代理
    __weak NSObject<ViewPassValueDelegate> *passValelegate;
}

#pragma mark 活动众筹数据
@property(nonatomic,retain)NSDictionary *peopleData;
@property (weak, nonatomic) IBOutlet UITableView *peopleDetailTable;

@end
