//
//  UIViewController+ShareMessage.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "UIViewController+ShareMessage.h"

@implementation UIViewController (ShareMessage)


//显示分享菜单
-(void)showShareAlert:(NSMutableDictionary *)contentDic{
    
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:self];
    
    NSArray *shareList = [ShareSDK getShareListWithType:
                          ShareTypeWeixiSession,
                          ShareTypeWeixiTimeline,
                          ShareTypeSinaWeibo,
                          ShareTypeQQSpace,
                          ShareTypeTencentWeibo,
                          ShareTypeQQ,
                          nil];
    
    id<ISSContent> publishContent = nil;
    
    NSString *showTitle = [contentDic valueForKey:@"showTitle"];
    NSString *contentString = [contentDic valueForKey:@"contentString"];
    NSString *titleString   = [contentDic valueForKey:@"titleString"];
    NSString *urlString     = [contentDic valueForKey:@"urlString"];
    NSString *description   = [contentDic valueForKey:@"description"];
    NSString *defaultContent = [contentDic valueForKey:@"defaultContent"];
    
    publishContent = [ShareSDK content:contentString
                        defaultContent:defaultContent
                                 image:nil
                                 title:titleString
                                   url:urlString
                           description:description
                             mediaType:SSPublishContentMediaTypeText];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:showTitle
                                                              oneKeyShareList:shareList
                                                           cameraButtonHidden:YES
                                                          mentionButtonHidden:NO
                                                            topicButtonHidden:NO
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:nil
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                                scopes:nil
                                                         powerByHidden:YES
                                                        followAccounts:nil
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:NO
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type,
                                     SSResponseState state,
                                     id<ISSPlatformShareInfo> statusInfo,
                                     id<ICMErrorInfo> error, BOOL end)
     {
         NSString *name = nil;
         switch (type)
         {
             case ShareTypeQQ:
                 name = @"QQ";
                 break;
             case ShareTypeSinaWeibo:
                 name = @"新浪微博";
                 break;
             case ShareTypeWeixiSession:
                 name = @"微信好友";
                 break;
             case ShareTypeQQSpace:
                 name = @"QQ空间";
                 break;
             case ShareTypeTencentWeibo:
                 name = @"腾讯微博";
                 break;
             case ShareTypeWeixiTimeline:
                 name = @"微信朋友圈";
                 break;
                 
             default:
                 name = @"某个平台";
                 break;
         }
         
         NSString *notice = nil;
         if (state == SSPublishContentStateSuccess)
         {
             notice = [NSString stringWithFormat:@"分享到%@成功！", name];
             NSLog(@"%@",notice);
             
             UIAlertView *view =
             [[UIAlertView alloc] initWithTitle:@"提示"
                                        message:notice
                                       delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles: nil];
             [view show];
         }
         else if (state == SSPublishContentStateFail)
         {
             notice = [NSString stringWithFormat:@"分享到%@失败,错误码:%d,错误描述:%@", name, [error errorCode], [error errorDescription]];
             NSLog(@"%@",notice);
             
             UIAlertView *view =
             [[UIAlertView alloc] initWithTitle:@"提示"
                                        message:notice
                                       delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles: nil];
             [view show];
         }
     }];
    
}


@end
