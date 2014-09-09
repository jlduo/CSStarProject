//
//  GirlsVideoViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-5.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "common.h"
#import <UIKit/UIKit.h>
#import "UILabel+ContentSize.h"
#import "AllAroundPullView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoTableViewCell.h"
#import "CommonViewController.h"

@interface GirlsVideoViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate> {
    
    MPMoviePlayerController *moviePlayer;
    UIActivityIndicatorView *loadingAni;    //加载动画
    UILabel *loadingLabel;                         //加载提醒
}

@end
