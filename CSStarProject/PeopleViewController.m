//
//  PeopleViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "PeopleViewController.h"

@interface PeopleViewController ()

@end

@implementation PeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[self setNavBarWithTitle:@"活动众筹" hasLeftItem:NO hasRightItem:YES leftIcon:nil rightIcon:nil]];
}

@end
