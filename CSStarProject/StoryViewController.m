//
//  StoryViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "StoryViewController.h"

@interface StoryViewController ()

@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"星城故事" hasLeftItem:NO hasRightItem:YES]];
}

@end
