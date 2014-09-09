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
	CGSize contentSize;
	if([[[UIDevice currentDevice]  systemVersion] floatValue]<= 7.0)
	{
		[self setNumberOfLines:0];
		[self setLineBreakMode:NSLineBreakByWordWrapping];
		
		CGSize maximumLabelSize = CGSizeMake(self.frame.size.width,9999);
		contentSize = [[self text] sizeWithFont:[self font] constrainedToSize:maximumLabelSize lineBreakMode:[self lineBreakMode]];
	}
	else
	{
		NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
		paragraphStyle.lineBreakMode = self.lineBreakMode;
		paragraphStyle.alignment = self.textAlignment;
		NSDictionary * attributes = @{NSFontAttributeName : self.font,
									  NSParagraphStyleAttributeName : paragraphStyle};
        contentSize = [self.text boundingRectWithSize:self.frame.size
                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                           attributes:attributes
                                              context:nil].size;
	}
    return contentSize;
}

@end
