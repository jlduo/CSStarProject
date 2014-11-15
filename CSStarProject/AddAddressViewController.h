//
//  AddAddressViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-16.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CommonViewController.h"
#import "ViewPassValueDelegate.h"
#import "UIViewController+HUD.h"
#import "UIViewController+DismissKeyboard.h"
#import "EditCityViewController.h"

@interface AddAddressViewController : CommonViewController<ViewPassValueDelegate,UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property(nonatomic,weak)NSObject<ViewPassValueDelegate> *passValelegate;
@property (weak, nonatomic) IBOutlet UIView *addressBackView;
@property (weak, nonatomic) IBOutlet UITextField *recPeopleTxt;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTxt;
@property (weak, nonatomic) IBOutlet UITextField *areaCodeTxt;
@property (weak, nonatomic) IBOutlet UITextField *areaNameTxt;
@property (weak, nonatomic) IBOutlet UITextView *remarkText;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtnView;
- (IBAction)clickDeleteBtn:(id)sender;

@end
