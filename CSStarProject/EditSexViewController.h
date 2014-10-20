//
//  EditSexViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-18.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
#import "UIViewController+HUD.h"
#import "CommonViewController.h"

@interface EditSexViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *boyRadio;
@property (weak, nonatomic) IBOutlet UISwitch *bmRadio;
@property (weak, nonatomic) IBOutlet UISwitch *girlRadio;
- (IBAction)boyClick:(id)sender;
- (IBAction)girlClick:(id)sender;
- (IBAction)bmClick:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *boyBg;
@property (weak, nonatomic) IBOutlet UIView *girlBg;
@property (weak, nonatomic) IBOutlet UIView *bmBg;

@property (copy,nonatomic) NSString *sexValue;


@end
