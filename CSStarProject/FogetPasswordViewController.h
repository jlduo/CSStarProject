//
//  FogetPasswordViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-20.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
#import "StringUitl.h"
#import "CommonViewController.h"

@interface FogetPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *fogetView;
@property (weak, nonatomic) IBOutlet UITextField *forgetText;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtnView;
- (IBAction)clickForgetBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *forgetBgView;

@end
