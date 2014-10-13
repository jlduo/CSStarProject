//
//  userAddressTableViewCell.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-10.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface userAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
@property (weak, nonatomic) IBOutlet UILabel *lblLink;
@property (weak, nonatomic) IBOutlet UILabel *lblphoto;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@end
