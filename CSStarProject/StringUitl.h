//
//  StringUitl.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-4.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "common.h"

@interface StringUitl : NSObject
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

+(BOOL)isEmpty:(NSString *)str;
+(BOOL)isNotEmpty:(NSString *)str;

+(void)alertMsg:(NSString *)msg withtitle:(NSString *)title;
+(BOOL)validateMobile:(NSString *)mobileNum;

@end

