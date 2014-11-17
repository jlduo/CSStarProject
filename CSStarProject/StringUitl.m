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
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"设置【%@=%@】成功",key,val);
}

//读取用户信息
+(NSString *)getSessionVal:(NSString*)key{ 
    NSString *val = [[NSString alloc] initWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:key]];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGIN_USER_ID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGIN_USER_NAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGIN_USER_PSWD];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_IS_LOGINED];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CITY_ID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_LOGO];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_NICK_NAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_SEX];
    
	[[NSUserDefaults standardUserDefaults] synchronize];
}

//判断字符串为空
+(BOOL)isEmpty:(NSString *)str{
    if(Nil==str||0==str.length||[str isEqualToString:@"(null)"]){
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"确 定" otherButtonTitles:nil,nil];
    [alert show];
}



+(void)loadUserInfo:(NSString *)userName{
    
    NSString *url = [NSString stringWithFormat:@"%@%@?username=%@",REMOTE_URL,USER_CENTER_URL,userName];
    NSMutableDictionary *jsonDic = (NSMutableDictionary *)[ConvertJSONData requestData:url];
    
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"error"]){//获取信息失败
        [StringUitl alertMsg:[jsonDic valueForKey:@"info"] withtitle:@"错误提示"];
    }
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"success"]){//获取信息成功
        NSLog(@"userInfo==%@",jsonDic);
        //存储用户信息
        [StringUitl setSessionVal:[jsonDic valueForKey:USER_NICK_NAME] withKey:USER_NICK_NAME];
        [StringUitl setSessionVal:[jsonDic valueForKey:USER_ADDRESS] withKey:USER_ADDRESS];
        [StringUitl setSessionVal:[jsonDic valueForKey:PROVINCE_ID] withKey:PROVINCE_ID];
        [StringUitl setSessionVal:[jsonDic valueForKey:CITY_ID] withKey:CITY_ID];
        [StringUitl setSessionVal:[jsonDic valueForKey:USER_SEX] withKey:USER_SEX];
        [StringUitl setSessionVal:[jsonDic valueForKey:USER_LOGO] withKey:USER_LOGO];
    }
}
//获取用户信息
+(void)loadUserInfo2:(NSString *)userName{
    if([StringUitl isNotEmpty:userName]){
        
        NSURL *getUserUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?username=%@",REMOTE_URL,USER_CENTER_URL,userName]];
        NSLog(@"getuser_url=%@",getUserUrl);
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:getUserUrl];
        [ASIHTTPRequest setSessionCookies:nil];
        
        [request setUseCookiePersistence:NO];
        [request setDelegate:self];
        [request setRequestMethod:@"GET"];
        [request setStringEncoding:NSUTF8StringEncoding];
        [request startAsynchronous];
        
        [request setDidFailSelector:@selector(getUserInfoFailed:)];
        [request setDidFinishSelector:@selector(getUserInfoFinished:)];
        
    }
}

- (void)getUserInfoFinished:(ASIHTTPRequest *)req
{
    
    NSLog(@"getUserInfo->%@",[req responseString]);
    NSData *respData = [req responseData];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"error"]){//获取信息失败
        [StringUitl alertMsg:[jsonDic valueForKey:@"info"] withtitle:@"错误提示"];
    }
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"success"]){//获取信息成功
        NSLog(@"userInfo==%@",jsonDic);
        //存储用户信息
        [StringUitl setSessionVal:[jsonDic valueForKey:USER_NICK_NAME] withKey:USER_NICK_NAME];
        [StringUitl setSessionVal:[jsonDic valueForKey:USER_ADDRESS] withKey:USER_ADDRESS];
        [StringUitl setSessionVal:[jsonDic valueForKey:PROVINCE_ID] withKey:PROVINCE_ID];
        [StringUitl setSessionVal:[jsonDic valueForKey:CITY_ID] withKey:CITY_ID];
        [StringUitl setSessionVal:[jsonDic valueForKey:USER_SEX] withKey:USER_SEX];
        [StringUitl setSessionVal:[jsonDic valueForKey:USER_LOGO] withKey:USER_LOGO];
        
    }
    
}

- (void)getUserInfoFailed:(ASIHTTPRequest *)req
{
    
    [StringUitl alertMsg:@"请求数据失败！" withtitle:@"错误提示"];
}


+(NSMutableDictionary *)getUserData{
    
    [self loadUserInfo:[StringUitl getSessionVal:LOGIN_USER_NAME]];
    
    NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
    [dic setValue:[StringUitl getSessionVal:LOGIN_USER_NAME] forKey:LOGIN_USER_NAME];
    [dic setValue:[StringUitl getSessionVal:LOGIN_USER_ID] forKey:LOGIN_USER_ID];
    [dic setValue:[StringUitl getSessionVal:USER_NICK_NAME] forKey:USER_NICK_NAME];
    [dic setValue:[StringUitl getSessionVal:CITY_ID] forKey:CITY_ID];
    [dic setValue:[StringUitl getSessionVal:PROVINCE_ID] forKey:PROVINCE_ID];
    [dic setValue:[StringUitl getSessionVal:USER_LOGO] forKey:USER_LOGO];
    [dic setValue:[StringUitl getSessionVal:USER_SEX] forKey:USER_SEX];
    return dic;
}

+(NSString *)getFileExtName:(NSString *)fileName{
    
    NSArray * rslt = [fileName componentsSeparatedByString:@"."];
    return  [rslt lastObject];
}

+(void)setCornerRadius:(UIView *)cview withRadius:(CGFloat)radius{
    if (cview!=nil) {
        cview.layer.cornerRadius = radius;
        cview.layer.masksToBounds = YES;
    }
}



+(void)setViewBorder:(UIView *)bview withColor:(NSString *)color Width:(CGFloat)width{
    if (bview!=nil) {
        bview.layer.borderColor = [StringUitl colorWithHexString:color].CGColor;
        bview.layer.borderWidth = width;
    }
}


//打印系统字体
+(void)printSystemFont{
    NSArray *familyNames = [UIFont familyNames];
    for( NSString *familyName in familyNames ){
        printf( "Family: %s \n", [familyName UTF8String] );
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for( NSString *fontName in fontNames ){
            printf( "\tFont: %s \n", [fontName UTF8String] );
        }
    }
}


@end


