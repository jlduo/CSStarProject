//
//  HomeViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CommonViewController.h"

@interface HomeViewController : CommonViewController

@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet UIButton *reqBtn;

- (IBAction)requestData:(id)sender;

@end
