//
//  StoryViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CommonViewController.h"
#import "StoryTableViewBigDescCell.h"
#import "StoryTableViewBigCell.h"
#import "StoryTableViewSmallCell.h"
#import "DateUtil.h"

@interface StoryViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate>

#pragma mark 星城故事 表格视图
@property (weak, nonatomic) IBOutlet UITableView *storyTableView;

#pragma mark 星城故事数据
@property(nonatomic,retain)NSMutableArray *storyDataList;

@end
