//
//  GirlsViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "GirlsViewController.h"

@interface GirlsViewController ()

@end

@implementation GirlsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"美女私房" hasLeftItem:NO hasRightItem:YES]];
}


@end
