//
//  VideoTableViewCell.h
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsynImageView.h"

@interface VideoTableViewCell : UITableViewCell

#pragma mark 视频截图
@property (weak, nonatomic) IBOutlet AsynImageView *videoPic;

#pragma mark 视频按钮
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
#pragma mark 视频底部
@property (weak, nonatomic) IBOutlet UILabel *videoBanner;
#pragma mark 视频时长
@property (weak, nonatomic) IBOutlet UILabel *videoTime;
#pragma mark 视频标题
@property (weak, nonatomic) IBOutlet UILabel *videoTitle;
#pragma mark 视频点击数
@property (weak, nonatomic) IBOutlet UILabel *clickNum;
#pragma mark 小箭头
@property (weak, nonatomic) IBOutlet UIButton *videoArrow;
#pragma mark 视频描述
@property (weak, nonatomic) IBOutlet UILabel *videoDesc;



@end
