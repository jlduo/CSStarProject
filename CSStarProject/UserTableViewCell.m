//
//  UserTableViewCell.m
//  CSStarProject
//
//  Created by jialiduo on 14-8-30.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //上分割线，
    CGContextSetStrokeColorWithColor(context, [StringUitl colorWithHexString:@"ffffff"].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, [StringUitl colorWithHexString:@"e2e2e2"].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width - 10, 1));
}

- (IBAction)arrowClick:(id)sender {
}
@end
