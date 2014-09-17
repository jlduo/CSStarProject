//
//  StoryCommentTableCell.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-16.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryCommentTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *commentImage;
@property (weak, nonatomic) IBOutlet UILabel *commentUsername;
@property (weak, nonatomic) IBOutlet UILabel *commentDateTime; 
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@end
