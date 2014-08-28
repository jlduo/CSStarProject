//
//  HomeViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CommonViewController.h"

@interface HomeViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource>

#pragma mark 表格视图对象
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;

#pragma mark 分组标题数据
@property(nonatomic,retain)NSMutableArray *headTitleArray;
#pragma mark 美女私房数据
@property(nonatomic,retain)NSMutableArray *girlsDataList;
#pragma mark 星城故事数据
@property(nonatomic,retain)NSMutableArray *storyDataList;
#pragma mark 活动众筹数据
@property(nonatomic,retain)NSMutableArray *peopleDataList;
#pragma mark 朋友圈数据
@property(nonatomic,retain)NSMutableArray *friendDataList;

@end
