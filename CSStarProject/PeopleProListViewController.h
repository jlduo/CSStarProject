//
//  PeopleProListViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-13.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "CommonViewController.h"
#import "ProjectTableViewCell.h"
#import "ViewPassValueDelegate.h"
#import "PeopleDetailViewController.h"
@interface PeopleProListViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,ViewPassValueDelegate>
#pragma mark 回填数据
@property(nonatomic,strong)NSMutableArray *peopleProList;
@property (weak, nonatomic) IBOutlet UITableView *projectListTable;
@property(nonatomic,weak)NSObject<ViewPassValueDelegate> *passValelegate;
@end
