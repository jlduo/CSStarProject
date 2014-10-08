//
//  PhotoScrollViewCell.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-23.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoScrollViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *cellBgView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UIScrollView *photoScroll;

@end
