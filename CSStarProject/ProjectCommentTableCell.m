//
//  ProjectCommentTableCell.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-14.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "ProjectCommentTableCell.h"

@implementation ProjectCommentTableCell

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

    NSString *labelString = self.contentTextView.text;
    //评论内容自适应
    [self.contentTextView setNumberOfLines:0];
    UIFont *font = [UIFont systemFontOfSize:12];
    [self.contentTextView setLineBreakMode:NSLineBreakByCharWrapping];
    CGSize size = CGSizeMake( self.contentTextView.frame.size.width,2000);
    CGSize labelsize = [labelString sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    if (labelsize.height > 20) {
        
        self.contentTextView.frame = CGRectMake(self.contentTextView.frame.origin.x,
                                                self.contentTextView.frame.origin.y,
                                                self.contentTextView.frame.size.width,
                                                labelsize.height);
        
        CGRect tempFrame = CGRectMake(self.commentDate.frame.origin.x,
                                      self.commentDate.frame.origin.y+labelsize.height,
                                      self.commentDate.frame.size.width,
                                      self.commentDate.frame.size.height);
        [self.commentDate setFrame:tempFrame];
        
    }
    
    
    
}

@end
