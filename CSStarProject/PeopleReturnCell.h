//
//  PeopleReturnCell.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-13.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleReturnCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *supportNum;
@property (weak, nonatomic) IBOutlet UILabel *descText;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end
