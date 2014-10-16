//
//  ChangeNumTableCell.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-15.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeNumTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *delNum;
@property (weak, nonatomic) IBOutlet UIButton *addNum;
@property (weak, nonatomic) IBOutlet UITextField *numTxt;

@end
