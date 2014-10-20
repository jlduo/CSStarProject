//
//  PayOrderViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-17.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CommonViewController.h"
#import "PayTableViewCell.h"
#import "ShowOrderViewController.h"
#import "ViewPassValueDelegate.h"

@interface PayOrderViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource,ViewPassValueDelegate>{
    // 声明一个参数传递代理
    NSObject<ViewPassValueDelegate> *passValelegate;
}

@end
