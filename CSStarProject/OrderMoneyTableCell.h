//
//  OrderMoneyTableCell.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-15.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderMoneyTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *payMoney;
@property (weak, nonatomic) IBOutlet UILabel *sendMoney;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;

@end
