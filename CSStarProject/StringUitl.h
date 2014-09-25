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
#import <CommonCrypto/CommonDigest.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ConvertJSONData.h"


@interface StringUitl : NSObject
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

+(BOOL)isEmpty:(NSString *)str;
+(BOOL)isNotEmpty:(NSString *)str;

+(void)alertMsg:(NSString *)msg withtitle:(NSString *)title;
+(BOOL)validateMobile:(NSString *)mobileNum;
+(NSString *)md5:(NSString *)str;
//设置用户信息
+(void)setSessionVal:(NSString*)val withKey:(NSString *)key;
//读取用户信息
+(NSString *)getSessionVal:(NSString*)key;

//检查登录
+(BOOL)checkLogin;
+(void)clearUserInfo;
//获取用户信息
+(void)loadUserInfo:(NSString *)userName;
+(NSMutableDictionary *)getUserData;

+(NSString *)getFileExtName:(NSString *)fileName;
+(void)setCornerRadius:(UIView *)cview withRadius:(CGFloat)radius;
+(void)setViewBorder:(UIView *)bview withColor:(NSString *)color Width:(CGFloat)width;

//打印系统字体
+(void)printSystemFont;

@end

