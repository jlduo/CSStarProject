//
//  ReciverAddressViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-15.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CommonViewController.h"
#import "ViewPassValueDelegate.h"
#import "ReciverTableViewCell.h"
#import "OrderInfoViewController.h"
#import "AddAddressViewController.h"

@interface ReciverAddressViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource,ViewPassValueDelegate>{
    // 声明一个参数传递代理
    NSObject<ViewPassValueDelegate> *passValelegate;
}
#pragma mark 回填数据
@property(nonatomic,retain)NSMutableArray *orderAddressList;
@end
