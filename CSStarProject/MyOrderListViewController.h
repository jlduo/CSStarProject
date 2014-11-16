//
//  MyOrderListViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-11-13.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CommonViewController.h"
#import "ViewPassValueDelegate.h"
#import "ShowOrderViewController.h"
#import "LASIImageView.h"

@interface MyOrderListViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,ViewPassValueDelegate>{
    // 声明一个参数传递代理
    __weak NSObject<ViewPassValueDelegate> *passValelegate;
}

@property (weak, nonatomic) IBOutlet UITableView *orderTableView;
@property(nonatomic,strong)NSMutableArray *peopleProList;

@end
