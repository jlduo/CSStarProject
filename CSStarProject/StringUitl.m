//
//  StringUitl.m
//  CSStarProject
//
//  Created by jialiduo on 14-9-4.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "StringUitl.h"

@implementation StringUitl



+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


+(BOOL)validateMobile:(NSString *)mobileNum{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }else{
        return NO;
    }
}

+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

//设置用户信息
+(void)setSessionVal:(NSString*)val withKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults]setValue:val forKey:key];
    NSLog(@"设置【%@=%@】成功",key,val);
}

//读取用户信息
+(NSString *)getSessionVal:(NSString*)key{ 
    NSString *val = [[NSString alloc] initWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:key]];
    NSLog(@"获取%@的值为:%@",key,val);
    return val;
}

//检查登陆
+(BOOL)checkLogin{
    NSString * isLogin = [self getSessionVal:USER_IS_LOGINED];
    if([self isNotEmpty:isLogin]&&[isLogin isEqual:@"1"]){
        return TRUE;
    }else{
        return FALSE;
    }
}

+(void)clearUserInfo{
    NSLog(@"清空用户信息成功.....");
    [StringUitl setSessionVal:Nil withKey:LOGIN_USER_ID];
    [StringUitl setSessionVal:Nil withKey:LOGIN_USER_NAME];
    [StringUitl setSessionVal:Nil withKey:LOGIN_USER_PSWD];
    [StringUitl setSessionVal:Nil withKey:USER_IS_LOGINED];
}

//判断字符串为空
+(BOOL)isEmpty:(NSString *)str{
    if(Nil==str||0==str.length){
        return true;
    }else{
        return false;
    }
}

//判断字符串不为空
+(BOOL)isNotEmpty:(NSString *)str{
    if(![self isEmpty:str]){
        return true;
    }else{
        return false;
    }
}

//提示信息
+(void)alertMsg:(NSString *)msg withtitle:(NSString *)title{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确 定"
                                          otherButtonTitles:nil,nil];
    [alert show];
}



@end


