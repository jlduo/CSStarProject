//
//  UserViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
#import "CommonViewController.h"

@interface UserViewController:CommonViewController

#pragma mark  用户数据
@property(nonatomic,retain)NSMutableArray *userDataList;

@end
