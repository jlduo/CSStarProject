//
//  OrderTableViewCell.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-17.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *conBgView;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *titleValue;

@end
