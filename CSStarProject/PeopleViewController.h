//
//  PeopleViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CommonViewController.h"

@interface PeopleViewController : CommonViewController

#pragma mark 活动众筹 表格视图
@property (weak, nonatomic) IBOutlet UITableView *peopleTableView;

#pragma mark 活动众筹数据
@property(nonatomic,retain)NSMutableArray *peopleDataList;

@end
