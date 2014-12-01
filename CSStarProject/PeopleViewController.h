//
//  PeopleViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//
#import "DateUtil.h"
#import "MarqueeLabel.h"
#import "CommonViewController.h"
#import "SubCollectionViewCell.h"
#import "PeopleTableViewCell.h"
#import "InitTabBarViewController.h"
#import "PeopleDetailViewController.h"
#import "ViewPassValueDelegate.h"
#import "XHFriendlyLoadingView.h"
#import "PeopleFilterProjectController.h"

@interface PeopleViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>{
    // 声明一个参数传递代理
    NSObject<ViewPassValueDelegate> *passValelegate;
}

#pragma mark 活动众筹 表格视图
@property (weak, nonatomic) IBOutlet UITableView *peopleTableView;

#pragma mark 活动众筹数据
@property(nonatomic,retain)NSMutableArray *peopleDataList;
@property (weak, nonatomic) IBOutlet UIView *subContentBackView;

@property(nonatomic,retain)NSMutableArray *subClloectionList;
@property (weak, nonatomic) IBOutlet UICollectionView *subClloectionView;

@end
