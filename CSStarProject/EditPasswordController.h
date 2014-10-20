//
//  EditPasswordController.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-17.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
#import "ASIHTTPRequest.h"
#import "UIViewController+HUD.h"
#import "ASIFormDataRequest.h"
#import "CommonViewController.h"
#import "LoginViewController.h"

@interface EditPasswordController : UIViewController<MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UIView *passBg;
@property (weak, nonatomic) IBOutlet UITextField *passText;

@property (nonatomic, weak) id delegate;
@end
