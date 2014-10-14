//
//  ReturnsViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-13.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CommonViewController.h"
#import "ViewPassValueDelegate.h"
#import "PeopleReturnCell.h"
#import "InitTabBarViewController.h"

@interface ReturnsViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,ViewPassValueDelegate>

#pragma mark 回填数据
@property(nonatomic,retain)NSMutableArray *peopleReturnList;

@end
