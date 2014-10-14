//
//  PeopleTableViewCell.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-9.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *cellContentView;
@property (weak, nonatomic) IBOutlet UIImageView *tagImgView;
@property (weak, nonatomic) IBOutlet UILabel *tagTitle;
@property (weak, nonatomic) IBOutlet UIImageView *bigCellImg;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *moneyTitle;
@property (weak, nonatomic) IBOutlet UILabel *dateTitle;
@property (weak, nonatomic) IBOutlet UILabel *percentView;
@property (weak, nonatomic) IBOutlet UIImageView *blackProgressView;
@property (weak, nonatomic) IBOutlet UIImageView *redProgressView;

@end
