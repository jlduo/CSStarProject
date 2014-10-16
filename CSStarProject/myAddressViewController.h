//
//  myAddressViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-10.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
#import "InitTabBarViewController.h"
#import "userAddressTableViewCell.h"
#import "MBProgressHUD.h"

@interface myAddressViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}

@end
