//
//  AppDelegate.m
//  CSStarProject
//  Created by jialiduo on 14-8-27.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//
#import "common.h"
#import "StringUitl.h"
#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import "InitTabBarViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"ssss2");
    
    [StringUitl setSessionVal:nil withKey:FORWARD_TYPE];
    
    //[StringUitl printSystemFont];
    
    // 监测网络情况
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reachabilityChanged:)
//                                                 name: kReachabilityChangedNotification
//                                               object: nil];
//    hostReach = [Reachability reachabilityWithHostName:@"http://i.0731zhongchou.com"];
//    [hostReach startNotifier];
    
    
    [ShareSDK registerApp:@"40014af2ac66"];
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wx62525cff8e6d3279"
                           wechatCls:[WXApi class]];
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"4198865960"
                               appSecret:@"b6f8900bd5e30b42fc61da1c650ab95f"
                             redirectUri:@"http://www.0731zhongchou.com"];
    
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"4198865960"
                                appSecret:@"b6f8900bd5e30b42fc61da1c650ab95f"
                              redirectUri:@"http://www.0731zhongchou.com"
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
    [ShareSDK connectTencentWeiboWithAppKey:@"801550717"
                                  appSecret:@"68e175193aede829a6aa727a15f68b43"
                                redirectUri:@"http://www.0731zhongchou.com"];
    
    [ShareSDK ssoEnabled:NO];
    
    
    //重新加载本地数据
    //[self loadUserInfo:[StringUitl getSessionVal:LOGIN_USER_NAME]];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    return YES;
}

//获取用户信息
-(void)loadUserInfo:(NSString *)userName{
    if([StringUitl isNotEmpty:userName]){
        
        NSString *getUserUrl = [NSString stringWithFormat:@"%@%@?username=%@",REMOTE_URL,USER_CENTER_URL,userName];
        
        [HttpClient GET:getUserUrl
             parameters:nil
                 isjson:TRUE
                success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSDictionary *jsonDic = (NSDictionary *)responseObject;
             if([[jsonDic valueForKey:@"status"] isEqualToString:@"error"]){//获取信息失败
                 [StringUitl clearUserInfo];
             }
             if([[jsonDic valueForKey:@"status"] isEqualToString:@"success"]){//获取信息成功
                 
                 //存储用户信息
                 [StringUitl setSessionVal:[jsonDic valueForKey:USER_NICK_NAME] withKey:USER_NICK_NAME];
                 [StringUitl setSessionVal:[jsonDic valueForKey:USER_ADDRESS] withKey:USER_ADDRESS];
                 [StringUitl setSessionVal:[jsonDic valueForKey:PROVINCE_ID] withKey:PROVINCE_ID];
                 [StringUitl setSessionVal:[jsonDic valueForKey:CITY_ID] withKey:CITY_ID];
                 [StringUitl setSessionVal:[jsonDic valueForKey:USER_SEX] withKey:USER_SEX];
                 [StringUitl setSessionVal:[jsonDic valueForKey:USER_LOGO] withKey:USER_LOGO];
                 
             }
             
         }
                failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"error=%@",error);
             NSLog(@"初始化用户数据失败.....!");
             
         }];
        
    }
}


- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if(_isFull){
        
        return UIInterfaceOrientationMaskAll;
        
    }else{
        
        return UIInterfaceOrientationMaskPortrait;
        
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {
 
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    //如果极简SDK不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}



@end
