//
//  ConvertXMLData.m
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "ConvertXMLData.h"
#import "XMLDictionary.h"

@implementation ConvertXMLData


#pragma mark 通过URL请求xml数据并解析
-(NSDictionary*)convertXMLDataWithURL:(NSString*)xmlUrlString{
    
    if(xmlUrlString==nil)return nil;
    
    NSError *errorMsg;
    NSURL *URL = [[NSURL alloc] initWithString:xmlUrlString];
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:&errorMsg];
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
    
    if(errorMsg!=nil){
        NSLog(@"解析远程xml数据失败：%@",errorMsg);
    }else{
        NSLog(@"解析远程xml数据成功啦");
    }
    return xmlDoc;
}


#pragma mark 通过filePaht请求本地xml数据并解析
-(NSDictionary*)convertXMLDataWithFileName:(NSString*)xmlFileName{
    
    if(xmlFileName==nil)return nil;
    
    NSError *errorMsg;
    NSString*xmlPath=[[NSBundle mainBundle]pathForResource:xmlFileName ofType:@"xml"];
    NSString *xmlString = [[NSString alloc] initWithContentsOfFile:xmlPath encoding:NSUTF8StringEncoding error:&errorMsg];
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
    
    if(errorMsg!=nil){
        NSLog(@"解析本地xml数据失败：%@",errorMsg);
    }else{
        NSLog(@"解析本地xml数据成功啦");
    }
    return xmlDoc;
}

@end
