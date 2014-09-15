//
//  StoryDetailViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-9-11.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "StoryDetailViewController.h"
#import "InitTabBarViewController.h"

@interface StoryDetailViewController (){
    NSString *detailId;
}
@end

@implementation StoryDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.tabBarController.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    InitTabBarViewController * customTabar = (InitTabBarViewController *)self.tabBarController;
    [customTabar hiddenDIYTaBar];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加WebView
    UIWebView *webDetail = [[UIWebView alloc] init];
    webDetail.frame = CGRectMake(0, 128, SCREEN_WIDTH, MAIN_FRAME_H-100);
    [self.view addSubview:webDetail];
    
    //标题
    UILabel *lblDetail=[[UILabel alloc] init];
    lblDetail.font = [UIFont fontWithName:@"Helvetica" size:24];
    lblDetail.frame = CGRectMake(5, 69, SCREEN_WIDTH - 5, 35);
    [self.view addSubview:lblDetail];
    
    //时间
    UILabel *lblTimeDetail = [[UILabel alloc] init];
    lblTimeDetail.font = [UIFont fontWithName:@"Helvetica" size:12];
    lblTimeDetail.textColor = [UIColor grayColor];
    lblTimeDetail.frame = CGRectMake(5, 104, 65, 30);
    [self.view addSubview:lblTimeDetail];
    
    //分割线
    UIImageView *imgHomeDetailOne=[[UIImageView alloc] init];
    imgHomeDetailOne.frame = CGRectMake(75, 111, 1, 14);
    imgHomeDetailOne.image = [UIImage imageNamed:@"homeplaynumbg.png"];
    [self.view addSubview:imgHomeDetailOne];
    
    //栏目名称
    UILabel *lblCategoryDetail = [[UILabel alloc] init];
    lblCategoryDetail.font = [UIFont fontWithName:@"Helvetica" size:12];
    lblCategoryDetail.textColor = [UIColor grayColor];
    lblCategoryDetail.frame = CGRectMake(85, 104, 50, 30);
    lblCategoryDetail.text =@"星城故事";
    [self.view addSubview:lblCategoryDetail];
    
    //分割线
    UIImageView *imgHomeDetailTwo=[[UIImageView alloc] init];
    imgHomeDetailTwo.frame = CGRectMake(145, 111, 1, 14);
    imgHomeDetailTwo.image = [UIImage imageNamed:@"homeplaynumbg.png"];
    [self.view addSubview:imgHomeDetailTwo];
    
    //点击图标
    UIImageView *imgCategoryDetail=[[UIImageView alloc] init];
    imgCategoryDetail.frame = CGRectMake(155, 112, 16, 14);
    imgCategoryDetail.image = [UIImage imageNamed:@"heartgray.png"];
    [self.view addSubview:imgCategoryDetail];
    
    //点击量
    UILabel *lblNumberDetail = [[UILabel alloc] init];
    lblNumberDetail.font = [UIFont fontWithName:@"Helvetica" size:12];
    lblNumberDetail.textColor = [UIColor grayColor];
    lblNumberDetail.frame = CGRectMake(175, 104, 100, 30);
    [self.view addSubview:lblNumberDetail];
    
    
    ConvertJSONData *jsonData = [[ConvertJSONData alloc] init];
    NSString *requestUrl = [[NSString alloc] initWithFormat:@"http://192.168.1.210:8888/cms/GetArticle/%@",detailId];
    NSDictionary *dicContent = (NSDictionary *)[jsonData requestData:requestUrl];
    lblDetail.text = [dicContent valueForKey:@"_title"];
    lblTimeDetail.text = [[dicContent valueForKey:@"_add_time"] substringToIndex:10];
    NSString *call_index = [[NSString alloc] initWithFormat:@"%@",[dicContent valueForKey:@"_call_index"]];
    if (call_index.length > 0) {
            lblCategoryDetail.text = call_index;
    }
    NSString *click = [[NSString alloc] initWithFormat:@"%@",[dicContent valueForKey:@"_click"]];
    lblNumberDetail.text = click;
    
    
    NSString *url = [[NSString alloc] initWithFormat:@"http://192.168.1.210:888/newsConte.aspx?newsid=%@",detailId];
    NSURL *nsUrl = [[NSURL alloc] initWithString:url];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:nsUrl];
    [webDetail loadRequest:request];
}

-(void)passValue:(NSString *)val{
    detailId = val; 
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"星城故事" hasLeftItem:NO hasRightItem:YES leftIcon:nil rightIcon:nil]];
}
-(void)goPreviou{
    [super goPreviou];
}
@end
