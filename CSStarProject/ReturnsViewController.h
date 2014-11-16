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
#import "OrderInfoViewController.h"
#import "InitTabBarViewController.h"

@interface ReturnsViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,ViewPassValueDelegate>{
    // 声明一个参数传递代理
    __weak NSObject<ViewPassValueDelegate> *passValelegate;
}

#pragma mark 回填数据
@property(nonatomic,retain)NSMutableArray *peopleReturnList;
@property (weak, nonatomic) IBOutlet UITableView *returnListTable;

@end
