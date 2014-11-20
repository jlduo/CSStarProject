//
//  EditPasswordController.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-17.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
#import "UIViewController+HUD.h"
#import "CommonViewController.h"
#import "LoginViewController.h"
#import "UserViewController.h"
#import "ViewPassValueDelegate.h"

@interface EditPasswordController : UIViewController{
   __weak NSObject<ViewPassValueDelegate> *passDelegate;
}
@property (weak, nonatomic) IBOutlet UIView *passBg;
@property (weak, nonatomic) IBOutlet UITextField *passText;

@property (nonatomic, weak) id delegate;
@end
