//
//  OrderTableViewCell.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-17.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)drawRect:(CGRect)rect{
//    
//    NSString *labelString = self.titleValue.text;
//    [self.titleValue setNumberOfLines:0];
//    UIFont *font = [UIFont systemFontOfSize:12];
//    [self.titleValue setLineBreakMode:NSLineBreakByCharWrapping];
//    CGSize size = CGSizeMake( self.titleValue.frame.size.width,2000);
//    CGSize labelsize = [labelString sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
//    if (labelsize.height > 20) {
//        
//        
//        self.titleValue.frame = CGRectMake(self.titleValue.frame.origin.x,
//                                         self.titleValue.frame.origin.y,
//                                         self.titleValue.frame.size.width,
//                                         labelsize.height);
//    }
//}

@end
