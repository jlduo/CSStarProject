//
//  ReciverTableViewCell.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-15.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReciverTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *reciverText;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIView *contentBgView;
@property (weak, nonatomic) IBOutlet UITextView *reciverAddress;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;


@end
