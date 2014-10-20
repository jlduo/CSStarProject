//
//  OrderInfoViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-15.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CommonViewController.h"
#import "ViewPassValueDelegate.h"
#import "OrderMoneyTableCell.h"
#import "ChangeNumTableCell.h"
#import "ReturnTableViewCell.h"
#import "AddressTableViewCell.h"
#import "PayOrderViewController.h"
#import "ReciverAddressViewController.h"

@interface OrderInfoViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,
ViewPassValueDelegate,UITextFieldDelegate>{
    // 声明一个参数传递代理
    NSObject<ViewPassValueDelegate> *passValelegate;
}

#pragma mark 订单数据
@property(nonatomic,retain)NSDictionary *orderInfoData;

@end
