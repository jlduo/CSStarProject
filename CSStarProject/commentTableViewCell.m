//
//  commentTableViewCell.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-10.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "commentTableViewCell.h"

@implementation commentTableViewCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)drawRect:(CGRect)rect
{ 
    NSString *labelString = self.lblContent.text;
    //评论内容自适应
    [self.lblContent setNumberOfLines:0];
    UIFont *font = [UIFont systemFontOfSize:12];
    [self.lblContent setLineBreakMode:NSLineBreakByCharWrapping];
    CGSize size = CGSizeMake( self.lblContent.frame.size.width,2000);
    CGSize labelsize = [labelString sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByTruncatingTail];
    if (labelsize.height > 20) {
        self.lblContent.frame = CGRectMake(self.lblContent.frame.origin.x,self.lblContent.frame.origin.y, self.lblContent.frame.size.width, labelsize.height);
    }
}
@end
