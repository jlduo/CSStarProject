//
//  PeopleTableDetailCell.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-10.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleTableDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *cellContentView;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *pecentView;
@property (weak, nonatomic) IBOutlet UILabel *dateView;
@property (weak, nonatomic) IBOutlet UILabel *moneyView;
@property (weak, nonatomic) IBOutlet UITextView *descView;
@property (weak, nonatomic) IBOutlet UIButton *seeDetailBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *supportBtn;
@property (weak, nonatomic) IBOutlet UIImageView *blackProgressView;
@property (weak, nonatomic) IBOutlet UIImageView *redProgressView;
@property (weak, nonatomic) IBOutlet UIImageView *tagImgView;
@property (weak, nonatomic) IBOutlet UILabel *tagTitle;

@end
