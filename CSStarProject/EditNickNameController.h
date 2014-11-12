//
//  EditNickNameController.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-17.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "UIViewController+HUD.h"
#import "ASIFormDataRequest.h"
#import "CommonViewController.h"
#import "UserInfoViewController.h"

@interface EditNickNameController : UIViewController<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UIView *nickNameBg;

@end
