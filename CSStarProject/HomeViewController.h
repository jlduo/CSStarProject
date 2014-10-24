//
//  HomeViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//
#import "CommonViewController.h"
#import "FFScrollView.h"
#import "UserViewController.h"
#import "GirlsVideoViewController.h"
#import "PicTableViewCell.h"
#import "VideoTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UILabel+VerticalAlign.h"
#import "ViewPassValueDelegate.h"
#import "StoryDetailViewController.h"
#import "PeopleDetailViewController.h"
#import "UIViewController+HUD.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "XHFriendlyLoadingView.h"

@interface HomeViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate>{
    // 声明一个参数传递代理
    NSObject<ViewPassValueDelegate> *passValelegate;
}

#pragma mark 表格视图对象
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (nonatomic, strong) UIRefreshControl* refreshControl;

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

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;


@end
