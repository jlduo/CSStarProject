//
//  ShowOrderViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-17.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "OrderTableViewCell.h"
#import "ViewPassValueDelegate.h"
#import "PeopleDetailViewController.h"

@interface ShowOrderViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,ViewPassValueDelegate,UIGestureRecognizerDelegate>{
    // 声明一个参数传递代理
    NSObject<ViewPassValueDelegate> *passValelegate;
}
#pragma mark 订单数据
@property(nonatomic,retain)NSDictionary *orderInfoData;
@end
