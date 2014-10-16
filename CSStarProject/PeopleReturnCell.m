//
//  PeopleReturnCell.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-13.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "PeopleReturnCell.h"

@implementation PeopleReturnCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)drawRect:(CGRect)rect{
    
    NSString *labelString = self.descText.text;
    [self.descText setNumberOfLines:0];
    UIFont *font = [UIFont systemFontOfSize:12];
    [self.descText setLineBreakMode:NSLineBreakByCharWrapping];
    CGSize size = CGSizeMake( self.descText.frame.size.width,2000);
    CGSize labelsize = [labelString sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    if (labelsize.height > 20) {

        
        self.descText.frame = CGRectMake(self.descText.frame.origin.x,
                                                self.descText.frame.origin.y,
                                                self.descText.frame.size.width,
                                                labelsize.height);
        
        CGRect tempFrame = CGRectMake(self.saveBtn.frame.origin.x,
                                      self.saveBtn.frame.origin.y+labelsize.height-60,
                                      self.saveBtn.frame.size.width,
                                      self.saveBtn.frame.size.height);
        [self.saveBtn setFrame:tempFrame];
        
    }
}

@end
