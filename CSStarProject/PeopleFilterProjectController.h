//
//  PeopleFilterProjectController.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-25.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//
#import "MarqueeLabel.h"
#import "CommonViewController.h"
#import "PeopleTableViewCell.h"
#import "InitTabBarViewController.h"
#import "ViewPassValueDelegate.h"
#import "XHFriendlyLoadingView.h"

@interface PeopleFilterProjectController : CommonViewController<UITableViewDelegate,UITableViewDataSource,ViewPassValueDelegate>{
    // 声明一个参数传递代理
    __weak NSObject<ViewPassValueDelegate> *passValelegate;
}


#pragma mark 活动众筹数据
@property(nonatomic,retain)NSMutableArray *peopleDataList;
@property (weak, nonatomic) IBOutlet UITableView *peopleFilterTable;

@end
