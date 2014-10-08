//
//  LoginViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-12.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "common.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "UserViewController.h"
#import "HomeViewController.h"
#import "MBProgressHUD.h"
#import "FogetPasswordViewController.h"
#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate>

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
