//
//  UserSmallTableViewCell.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-4.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSmallTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *smallCellTitle;
@property (weak, nonatomic) IBOutlet UILabel *smallCellValue;
@property (weak, nonatomic) IBOutlet UIButton *smallCellArrow;

@end
