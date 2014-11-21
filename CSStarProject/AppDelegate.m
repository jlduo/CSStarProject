//
//  AppDelegate.m
//  CSStarProject
//  Created by jialiduo on 14-8-27.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//
#import "common.h"
#import "StringUitl.h"
#import "AppDelegate.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
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
    [self loadUserInfo:[StringUitl getSessionVal:LOGIN_USER_NAME]];
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
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CSStarProject" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CSStarProject.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


//独立客户端回调函数
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    [self parse:url application:application];
    return YES;
}

- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    //结果处理
    AlixPayResult* result = [self handleOpenURL:url];
    
    if (result)
    {
        
        if (result.statusCode == 9000)
        {
            /*
             *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
             */
            
            //交易成功
            NSString* key = AlipayPubKey;
            id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);

            if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"showPageInfo" object:nil];
            }
            
        }else{
            //交易失败
        }
    }else{
        //失败
    }
    
}

- (AlixPayResult *)resultFromURL:(NSURL *)url {
    NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
    return [[[AlixPayResult alloc] initWithString:query] autorelease];
#else
    return [[AlixPayResult alloc] initWithString:query];
#endif
}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
    AlixPayResult * result = nil;
    
    if (url != nil && [[url host] compare:@"safepay"] == 0) {
        result = [self resultFromURL:url];
    }
    
    return result;
}




@end
