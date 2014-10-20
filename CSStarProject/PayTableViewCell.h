//
//  PayTableViewCell.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-17.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *payIconView;
@property (weak, nonatomic) IBOutlet UILabel *payTitleView;
@property (weak, nonatomic) IBOutlet UIView *conBgView;

@end
