//
//  userMessageCommentNewTableViewCell.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-20.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface userMessageCommentNewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;


@end
