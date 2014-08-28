//
//  ConvertJSONData.m
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "ConvertJSONData.h"
#import "CJSONDeserializer.h"

#pragma mark json数据解析封装
@implementation ConvertJSONData

#pragma mark 通过URL请求json数据并解析［自带方法］
-(NSDictionary*)convertJsonDataWithURL:(NSString*)nurl withDataKey:(NSString *)dataKey{
    if(nurl==nil) return nil;
    //加载一个NSURL对象
    NSError *errorMsg;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:nurl]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error: &errorMsg];
    //自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&errorMsg];
    NSDictionary *jsonData = [jsonDic objectForKey:dataKey];
    
    if(errorMsg!=nil){
        NSLog(@"[自带方法]请求远程数据失败：%@",errorMsg);
    }else{
        NSLog(@"[自带方法]请求远程数据成功啦");
    }
    
    return jsonData;
}


#pragma mark 通过URL请求json数据并解析［TouchJson方法］
-(NSDictionary*)convertCJsonDataWithURL:(NSString*)nurl withDataKey:(NSString *)dataKey{
    if(nurl==nil) return nil;
    //加载一个NSURL对象
    NSError *errorMsg;
    NSURL *reqURL = [NSURL URLWithString:nurl];
    NSData *response = [NSData dataWithContentsOfURL:reqURL];
    //自带解析类NSJSONSerialization从解析出数据放到字典中
    NSDictionary *jsonDic  = [[CJSONDeserializer deserializer] deserialize:response error:&errorMsg];
    NSDictionary *jsonData = [jsonDic objectForKey:dataKey];
    
    if(errorMsg!=nil){
        NSLog(@"[组件方法]请求远程数据失败：%@",errorMsg);
    }else{
        NSLog(@"[组件方法]请求远程数据成功啦.....");
    }
    
    return jsonData;
}

@end
