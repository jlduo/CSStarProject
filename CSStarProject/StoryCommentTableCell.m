//
//  StoryCommentTableCell.m
//  CSStarProject
//
//  Created by jialiduo on 14-9-16.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "StoryCommentTableCell.h"

@implementation StoryCommentTableCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{ 
    self.commentImage.layer.masksToBounds = YES;
    self.commentImage.layer.cornerRadius = 25;
    
    NSString *labelString = self.commentTextView.text; 
    //评论内容自适应
    [self.commentTextView setNumberOfLines:0];
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize size = CGSizeMake( self.commentTextView.frame.size.width,2000);
    CGSize labelsize = [labelString sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByTruncatingTail];
    if (labelsize.height > self.commentTextView.frame.size.height) {
        self.commentTextView.frame = CGRectMake(self.commentTextView.frame.origin.x,self.commentTextView.frame.origin.y, self.commentTextView.frame.size.width, labelsize.height);
    }
}
@end
