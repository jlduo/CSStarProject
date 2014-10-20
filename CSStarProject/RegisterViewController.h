//
//  RegisterViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-12.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "StringUitl.h"
#import "UIViewController+HUD.h"
#import "UserAgreenViewController.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *registerView;
@property (weak, nonatomic) IBOutlet UIView *phoneNumView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;

@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *passwordVal;
@property (weak, nonatomic) IBOutlet UIView *checkNumView;
@property (weak, nonatomic) IBOutlet UITextField *checkNum;
@property (weak, nonatomic) IBOutlet UILabel *randomNum;

@property (weak, nonatomic) IBOutlet UIButton *checkNumBtn;

- (IBAction)clickCheckBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

- (IBAction)clickRegisterBtn:(id)sender;

- (IBAction)clickAgreen:(id)sender;


@end
