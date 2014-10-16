//
//  userAddressTableViewCell.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-10.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "userAddressTableViewCell.h"

@implementation userAddressTableViewCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)drawRect:(CGRect)rect
{
    NSString *labelString = self.lblAddress.text;
    //评论内容自适应
    [self.lblAddress setNumberOfLines:0];
    UIFont *font = [UIFont systemFontOfSize:14];
    [self.lblAddress setLineBreakMode:NSLineBreakByCharWrapping];
    CGSize size = CGSizeMake( self.lblAddress.frame.size.width,2000);
    CGSize labelsize = [labelString sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByTruncatingTail];
    if (labelsize.height > 20) {
        self.lblAddress.frame = CGRectMake(self.lblAddress.frame.origin.x,self.lblAddress.frame.origin.y, self.lblAddress.frame.size.width, labelsize.height);
    }
    
}

@end
