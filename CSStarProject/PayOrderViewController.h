//
//  PayOrderViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-17.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CommonViewController.h"
#import "PayTableViewCell.h"
#import "ShowOrderViewController.h"
#import "ViewPassValueDelegate.h"
#import "AlixLibService.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"

@interface PayOrderViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource,ViewPassValueDelegate>{
    // 声明一个参数传递代理
    NSObject<ViewPassValueDelegate> *passValelegate;
    SEL _result;
}

@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。
-(void)paymentResult:(NSString *)result;

@end
