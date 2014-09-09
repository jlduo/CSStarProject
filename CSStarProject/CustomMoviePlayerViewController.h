//
//  CustomMoviePlayerViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-9.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface CustomMoviePlayerViewController : UIViewController
{
    MPMoviePlayerController *mp;
    NSURL *movieURL;                        //视频地址
    UIActivityIndicatorView *loadingAni;    //加载动画
    UILabel *label;                            //加载提醒
}
@property (nonatomic,retain) NSURL *movieURL;

//准备播放
- (void)readyPlayer;@end
