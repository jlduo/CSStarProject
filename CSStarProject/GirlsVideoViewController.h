//
//  GirlsVideoViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-5.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "common.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UILabel+ContentSize.h"
#import "AllAroundPullView.h"
#import "UIViewController+HUD.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoTableViewCell.h"
#import "CommonViewController.h"
#import "ViewPassValueDelegate.h"
#import "ConvertJSONData.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "UIViewController+ShareMessage.h"
#import "DirectionMPMoviePlayerViewController.h"

@interface GirlsVideoViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,
ViewPassValueDelegate,UITextViewDelegate> {
    
    MPMoviePlayerController *moviePlayer;
    UIActivityIndicatorView *loadingAni;    //加载动画
    UILabel *loadingLabel;                  //加载提醒
    
    NSMutableDictionary *bannerData;//导航初始数据
    NSMutableArray *topVideoArray;//推荐视频数据
    
    // 声明一个参数传递代理
    NSObject<ViewPassValueDelegate> *passValelegate;
}

@end
