//
//  GirlsViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CommonViewController.h"
#import "FFScrollView.h"
#import "UserViewController.h"
#import "PicTableViewCell.h"
#import "CustomTableCell.h"
#import "VideoTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "GirlsPhotosViewController.h"
#import "ViewPassValueDelegate.h"

@interface GirlsViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableDictionary *bannerData;//导航初始数据
    // 声明一个参数传递代理
    NSObject<ViewPassValueDelegate> *passValelegate;
    
}

#pragma mark 美女私房表格视图
@property (weak, nonatomic) IBOutlet UITableView *girlsTableView;

#pragma mark 美女私房数据
@property(nonatomic,retain)NSMutableArray *girlsDataList;


@end
