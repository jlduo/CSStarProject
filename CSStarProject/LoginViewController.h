//
//  LoginViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-12.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "common.h"
#import "UserViewController.h"
#import "HomeViewController.h"
#import "UIViewController+HUD.h"
#import "FogetPasswordViewController.h"
#import "CommonViewController.h"
#import "ViewPassValueDelegate.h"

@interface LoginViewController : CommonViewController<UITextFieldDelegate,ViewPassValueDelegate>{
    __weak NSObject<ViewPassValueDelegate> *passDelegate;
}

@property (weak, nonatomic) IBOutlet UIView *loginBgView;

@property (weak, nonatomic) IBOutlet UIView *userNameView;
@property (weak, nonatomic) IBOutlet UIView *passWordView;

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *lognBtn;

- (IBAction)clickLognBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;


- (IBAction)clickForgetBtn:(UIButton *)sender;

@property (nonatomic, weak) id delegate;

@end
