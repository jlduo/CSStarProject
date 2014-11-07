//
//  UILabel+ContentSize.m
//  CSStarProject
//
//  Created by jialiduo on 14-9-9.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "UILabel+ContentSize.h"

@implementation UILabel (ContentSize)

- (CGSize)contentSize
{
    [self setNumberOfLines:0];
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    [self sizeToFit];
		
    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width,10000);
    CGSize contentSize = [[self text] sizeWithFont:[self font] constrainedToSize:maximumLabelSize lineBreakMode:[self lineBreakMode]];
	
    return contentSize;
}

@end
