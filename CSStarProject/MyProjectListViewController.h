//
//  MyProjectListViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-20.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//
#import "ProjectTableViewCell.h"
#import "CommonViewController.h"
#import "ViewPassValueDelegate.h"
#import "PeopleDetailViewController.h"

@interface MyProjectListViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,ViewPassValueDelegate>{
    // 声明一个参数传递代理
    NSObject<ViewPassValueDelegate> *passValelegate;
}
#pragma mark 回填数据
@property(nonatomic,retain)NSMutableArray *peopleProList;

@end
