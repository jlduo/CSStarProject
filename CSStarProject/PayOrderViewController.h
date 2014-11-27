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
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "DataVerifier.h"

@interface PayOrderViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource,ViewPassValueDelegate>


@property(nonatomic,weak)NSObject<ViewPassValueDelegate> *passValelegate;
@property (weak, nonatomic) IBOutlet UITableView *payOrderTable;


@end
