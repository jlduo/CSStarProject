//
//  UserViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "UserViewController.h"

@interface UserViewController ()

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)loadView{
    
    UIView *baseView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]applicationFrame]];
    baseView.backgroundColor = [UIColor redColor];
    self.view = baseView;
    
    self.navigationController.navigationBarHidden = YES;
    
    UINavigationBar *navgationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    [navgationBar setBackgroundImage:[UIImage imageNamed:@"navline.png"] forBarMetrics:UIBarMetricsDefault];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    //设置左边按钮
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btnback.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    navItem.leftBarButtonItem = leftBtnItem;
    
    //设置右边边按钮
    UIButton *item = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [item setTitle:@"test" forState:UIControlStateNormal];
    [item setFrame:CGRectMake(0, 0, 60, 35)];
    [item addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:item];
    navItem.rightBarButtonItem = rightBtnItem;
    
    UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 160, 50, 44)];
    [titleLabel setText:@"首页"];
    
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    
    [navItem setTitleView:titleLabel];
    
    [navgationBar pushNavigationItem:navItem animated:YES];
    [self.view addSubview:navgationBar];
    
    
    
}

-(void)back{
    NSLog(@"back");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)go{
    NSLog(@"go");
    UserViewController *userView = [[UserViewController alloc] init];
    [self.navigationController pushViewController:userView animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
