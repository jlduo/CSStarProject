//
//  ProjectCommentTableCell.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-14.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectCommentTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userIconView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userAddress;
@property (weak, nonatomic) IBOutlet UILabel *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *commentDate;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet UIView *contentBackView;

@end
