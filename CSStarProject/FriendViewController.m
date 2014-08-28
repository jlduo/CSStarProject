//
//  FriendViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "FriendViewController.h"

@interface FriendViewController ()

@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"朋友圈" hasLeftItem:NO hasRightItem:YES]];
}

@end
