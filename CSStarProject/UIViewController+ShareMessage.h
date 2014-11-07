//
//  UIViewController+ShareMessage.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>

@interface UIViewController (ShareMessage)
//显示分享菜单
-(void)showShareAlert:(NSMutableDictionary *)contentDic;
@end
