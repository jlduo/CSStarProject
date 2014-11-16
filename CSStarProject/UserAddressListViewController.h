//
//  UserAddressListViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-11-14.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CommonViewController.h"
#import "ReciverTableViewCell.h"
#import "OrderInfoViewController.h"
#import "AddAddressViewController.h"
#import "UIViewController+HUD.h"
#import "ViewPassValueDelegate.h"

@interface UserAddressListViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,ViewPassValueDelegate>{
    // 声明一个参数传递代理
    __weak NSObject<ViewPassValueDelegate> *passValelegate;
}

@property(nonatomic,retain)NSMutableArray *orderAddressList;
@property (weak, nonatomic) IBOutlet UITableView *orderAddressTable;

@end
