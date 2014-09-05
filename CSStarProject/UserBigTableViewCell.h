//
//  UserBigTableViewCell.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-4.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserBigTableViewCell : UITableViewCell

#pragma mark 头像行
@property (weak, nonatomic) IBOutlet UIImageView *bigCellPic;
@property (weak, nonatomic) IBOutlet UILabel *bigCellTitle;
@property (weak, nonatomic) IBOutlet UIButton *bigCellArrow;

@end
