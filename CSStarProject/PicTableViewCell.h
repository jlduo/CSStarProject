//
//  PicTableViewCell.h
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface PicTableViewCell : UITableViewCell

#pragma mark 图片区域
@property (weak, nonatomic) IBOutlet UIImageView *picView;

#pragma mark 标题区域
@property (weak, nonatomic) IBOutlet UILabel *titleView;
#pragma mark 描述区域
@property (weak, nonatomic) IBOutlet UILabel *descView;
@property (weak, nonatomic) IBOutlet UIView *cellBgView;



@end
