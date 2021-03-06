//
//  UserInfoViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-4.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
#import "UIViewController+HUD.h"
#import "CommonViewController.h"
#import "InitTabBarViewController.h"
#import "EditNickNameController.h"
#import "EditPasswordController.h"
#import "EditSexViewController.h"
#import "EditCityViewController.h"
@interface UserInfoViewController : CommonViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *userInfoTable;

@end
