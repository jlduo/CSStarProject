//
//  UserTableViewCell.h
//  CSStarProject
//
//  Created by jialiduo on 14-8-30.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringUitl.h"

@interface UserTableViewCell : UITableViewCell

#pragma mark 行头图标
@property (weak, nonatomic) IBOutlet UIButton *cellPic;
#pragma mark 新消息数目
@property (weak, nonatomic) IBOutlet UILabel *dataNum;
#pragma mark 标题
@property (weak, nonatomic) IBOutlet UILabel *dataTitle;
#pragma mark 箭头图标
@property (weak, nonatomic) IBOutlet UIButton *arrowPic;
#pragma mark 整个cell视图
@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UILabel *tagNum;
@property (weak, nonatomic) IBOutlet UIButton *tagBgView;

#pragma mark 点击事件
- (IBAction)arrowClick:(id)sender;

@end
