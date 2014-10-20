//
//  AddressTableViewCell.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-16.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *reciverText;
@property (weak, nonatomic) IBOutlet UILabel *phoneText;
@property (weak, nonatomic) IBOutlet UILabel *addressText;

@end
