//
//  HomeViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "HomeViewController.h"
#import "UserViewController.h"
#import "ConvertJSONData.h"
#import "ConvertXMLData.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"首 页" hasLeftItem:NO hasRightItem:YES]];
}



#pragma mark 测试请求数据
- (IBAction)requestData:(id)sender {
    
    NSLog(@"requestData....");
//
//    ConvertJSONData *convert = [[ConvertJSONData alloc] init];
//    NSDictionary *weatherInfo = [convert convertJsonDataWithURL:@"http://m.weather.com.cn/data/101180601.html" withDataKey:@"weatherinfo"];
//    _textField.text = [NSString stringWithFormat:@"今天是 %@  %@  %@  的天气状况是：%@  %@ ",[weatherInfo objectForKey:@"date_y"],[weatherInfo objectForKey:@"week"],[weatherInfo objectForKey:@"city"], [weatherInfo objectForKey:@"weather1"], [weatherInfo objectForKey:@"temp1"]];
//    NSLog(@"weatherInfo字典里面的内容为--》%@", weatherInfo);
    
    ConvertXMLData *xmldata = [[ConvertXMLData alloc]init];
    //NSString *url = @"http://www.ibiblio.org/xml/examples/shakespeare/all_well.xml";
    NSDictionary * mydata = [xmldata convertXMLDataWithFileName:@"student"];
    NSLog(@"xmldata==%@",[[mydata valueForKey:@"student"] valueForKey:@"name"]);
    _textField.text = @"解析远程xml数据成功啦";
    
}


@end
