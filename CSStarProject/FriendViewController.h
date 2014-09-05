//
//  FriendViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CommonViewController.h"

@interface FriendViewController : CommonViewController

#pragma mark 朋友圈表格视图
@property (weak, nonatomic) IBOutlet UITableView *friendTableView;

#pragma mark 朋友圈数据
@property(nonatomic,retain)NSMutableArray *friendDataList;

@end
