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
+(NSDictionary*)convertJsonDataWithURL:(NSString*)nurl withDataKey:(NSString *)dataKey{
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
+(NSDictionary*)convertCJsonDataWithURL:(NSString*)nurl withDataKey:(NSString *)dataKey{
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


+(NSObject *)requestData:(NSString*)nurl{
    NSObject *jsonObj;
    NSError *errorMsg;
    NSURL *url = [NSURL URLWithString:nurl];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&errorMsg];
    //NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    if(received!=Nil){
       jsonObj = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:&errorMsg];
    }else{
       jsonObj = Nil;
    }
    
    if(errorMsg!=nil){
        NSLog(@"请求远程数据失败：%@",errorMsg);
    }

    
    return jsonObj;
}

+(id)requestSData:(NSString*)nurl{
    
    NSURL *url = [NSURL URLWithString:nurl];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    return str;
}

//提交表单数据
+(BOOL)postData:(NSMutableDictionary *)paramData withUrl:(NSString *)url{
    
    DateUtil *dateUtil = [[DateUtil alloc]init];
    if (paramData==nil||paramData.count==0) return false;
    //获取所有keys
    NSMutableArray *allKey = [NSMutableArray arrayWithArray:paramData.allKeys];
    //遍历key获取值
    NSString *val;
    NSString *nowDateTime =[NSString stringWithFormat:@"now=%@&",[dateUtil getCurDateTimeStr]];
    NSString *postString = [[NSString alloc]initWithString:nowDateTime];
    for(int i=0;i<allKey.count;i++){
        val = [paramData valueForKey:allKey[i]];
        postString = [postString stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",allKey[i],val]];
    }//end for
    
    NSLog(@"postString:%@",postString);
    
    //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据。
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //计算POST提交数据的长度
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSLog(@"postLength=%@",postLength);
    //定义NSMutableURLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //设置提交目的url
    [request setURL:[NSURL URLWithString:url]];
    //设置提交方式为 POST
    [request setHTTPMethod:@"POST"];
    //设置http-header:Content-Type
    //这里设置为 application/x-www-form-urlencoded ，如果设置为其它的，比如text/html;charset=utf-8，或者 text/html 等，都会出错。不知道什么原因。
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //设置http-header:Content-Length
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //设置需要post提交的内容
    [request setHTTPBody:postData];
    
    //定义
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    
    //设置网络状态显示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //同步提交:POST提交并等待返回值（同步），返回值是NSData类型。
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    //将NSData类型的返回值转换成NSString类型
    //    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    //将NSData装换为字典类型
    NSError *jsonError = [[NSError alloc] init];
    NSDictionary *personDictionary = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&jsonError];
    NSString *status = [personDictionary objectForKey:@"status"];
    
    if ([@"ok" compare:status] == NSOrderedSame) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        return YES;
    }
    return NO;
    
}


@end
