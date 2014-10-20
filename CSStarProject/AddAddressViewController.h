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
#import "EditCityViewController.h"

@interface AddAddressViewController : CommonViewController<ViewPassValueDelegate,UITextFieldDelegate,UIAlertViewDelegate>{
    // 声明一个参数传递代理
    NSObject<ViewPassValueDelegate> *passValelegate;
}

@end
