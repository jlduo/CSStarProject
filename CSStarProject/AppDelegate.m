//
//  AppDelegate.m
//  CSStarProject
//委屈委屈委屈委屈
//  Created by jialiduo on 14-8-27.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//
#import "common.h"
#import "StringUitl.h"
#import "AppDelegate.h"
#import "Reachability.h"
//#import "GirlsViewController.h"
//#import "FriendViewController.h"
//#import "StoryViewController.h"
//#import "PeopleViewController.h"
//#import "HomeViewController.h"
//#import "InitNavBarViewController.h"
//#import "InitTabBarViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
    //初始化系统整体页面
//    HomeViewController *view1 = [[HomeViewController alloc]init];//系统首页
//    GirlsViewController *view2 = [[GirlsViewController alloc]init];//美女私房
//    StoryViewController *view3 = [[StoryViewController alloc]init];//星城故事
//    PeopleViewController *view4 = [[PeopleViewController alloc]init];//活动众筹
//    FriendViewController *view5 = [[FriendViewController alloc]init];//朋友圈

//    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:view1];
//    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:view2];
//    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:view3];
//    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:view4];
//    UINavigationController *nav5 = [[UINavigationController alloc] initWithRootViewController:view5];
    
    //初始化导航
//    InitNavBarViewController *nav1 = [[InitNavBarViewController alloc]initWithRootViewController:view1];
//    InitNavBarViewController *nav2 = [[InitNavBarViewController alloc]initWithRootViewController:view2];
//    InitNavBarViewController *nav3 = [[InitNavBarViewController alloc]initWithRootViewController:view3];
//    InitNavBarViewController *nav4 = [[InitNavBarViewController alloc]initWithRootViewController:view4];
//    InitNavBarViewController *nav5 = [[InitNavBarViewController alloc]initWithRootViewController:view5];
//    
//    InitTabBarViewController *tabBar = [[InitTabBarViewController alloc] init];
//    tabBar.viewControllers = @[nav1,nav2,nav3,nav4,nav5];
//    
//    self.window.rootViewController = tabBar;
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
    
    [StringUitl setSessionVal:nil withKey:FORWARD_TYPE];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
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
    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
                           wechatCls:[WXApi class]];
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
    
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"568898243"
                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                              redirectUri:@"http://www.sharesdk.cn"
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
    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                  appSecret:@"2f4c933e889ff93a61adaa2d5d76ecd8"
                                redirectUri:@"http://www.sharesdk.cn"];
    
    [ShareSDK ssoEnabled:NO];
    
    
    //重新加载本地数据
    [self loadUserInfo:[StringUitl getSessionVal:LOGIN_USER_NAME]];
    
    return YES;
}

//获取用户信息
-(void)loadUserInfo:(NSString *)userName{
    if([StringUitl isNotEmpty:userName]){
        
        NSURL *getUserUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?username=%@",REMOTE_URL,USER_CENTER_URL,userName]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:getUserUrl];
        [ASIHTTPRequest setSessionCookies:nil];
        
        [request setUseCookiePersistence:YES];
        [request setDelegate:self];
        [request setRequestMethod:@"GET"];
        [request setStringEncoding:NSUTF8StringEncoding];
        [request startAsynchronous];
        
        [request setDidFailSelector:@selector(requestLoginFailed:)];
        [request setDidFinishSelector:@selector(getUserInfoFinished:)];
        
    }
}

- (void)getUserInfoFinished:(ASIHTTPRequest *)req
{
    
    //NSLog(@"getUserInfo->%@",[req responseString]);
    NSData *respData = [req responseData];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
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

- (void)requestLoginFailed:(ASIHTTPRequest *)req
{
    
    NSLog(@"初始化用户数据失败.....!");
}



- (void)reachabilityChanged:(NSNotification *)note {
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];

    NSString *msg = @"";
    switch (status) {
        case NotReachable:
            // 没有网络连接
            msg = @"当前网络不稳定!";
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            msg = @"正在使用3G/2G移动网络,会消耗流量哦!";
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            msg = @"正在使用WIFI网络,可以放心使用哦!";
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确 定" otherButtonTitles:nil];
    [alert show];
    
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

@end
