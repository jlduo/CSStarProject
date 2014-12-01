//
//  ReturnTableViewCell.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-15.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "ReturnTableViewCell.h"

@implementation ReturnTableViewCell

- (void)awakeFromNib
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

//- (void)drawRect:(CGRect)rect{
//    
//    NSString *labelString = self.returnText.text;
//    [self.returnText setNumberOfLines:0];
//    UIFont *font = [UIFont systemFontOfSize:12];
//    [self.returnText setLineBreakMode:NSLineBreakByCharWrapping];
//    CGSize size = CGSizeMake( self.returnText.frame.size.width,2000);
//    CGSize labelsize = [labelString sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
//    if (labelsize.height > 20) {
//        
//        
//        self.returnText.frame = CGRectMake(self.returnText.frame.origin.x,
//                                         self.returnText.frame.origin.y,
//                                         self.returnText.frame.size.width,
//                                         labelsize.height+20);
//        
//        CGRect tempFrame = CGRectMake(self.descText.frame.origin.x,
//                                      self.descText.frame.origin.y+labelsize.height-45,
//                                      self.descText.frame.size.width,
//                                      self.descText.frame.size.height);
//        [self.descText setFrame:tempFrame];
//        
//    }else{
//  
//        
//        CGRect tempFrame = CGRectMake(self.descText.frame.origin.x,
//                                      self.descText.frame.origin.y-30,
//                                      self.descText.frame.size.width,
//                                      self.descText.frame.size.height);
//        [self.descText setFrame:tempFrame];
//    }
//}


@end
