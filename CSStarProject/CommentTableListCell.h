//
//  CommentTableListCell.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-12.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *addressTime;
@property (weak, nonatomic) IBOutlet UILabel *commenInfo;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;

@end
