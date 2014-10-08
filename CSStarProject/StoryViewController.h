//
//  StoryViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CommonViewController.h" 
#import "StoryTableViewBigCell.h"
#import "StoryTableViewSmallCell.h"
#import "ViewPassValueDelegate.h"
#import "common.h"
#import "MBProgressHUD.h"

@interface StoryViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *HUD; 
    NSObject<ViewPassValueDelegate> *delegate;
}

#pragma mark 星城故事 表格视图
@property (weak, nonatomic) IBOutlet UITableView *storyTableView;

#pragma mark 星城故事数据
@property(nonatomic,retain)NSMutableArray *storyDataList;

@end
