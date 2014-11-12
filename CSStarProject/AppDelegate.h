//
//  AppDelegate.h
//  CSStarProject
//
//  Created by jialiduo on 14-8-27.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "PartnerConfig.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <CoreData/CoreData.h>
#import "STSystemUtils.h"

@class Reachability;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    BOOL _isFull; // 是否全屏
    Reachability  *hostReach;
}


@property (nonatomic)BOOL isFull;
@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

