//
//  ConvertJSONData.h
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvertJSONData : NSObject

#pragma mark 通过URL请求json数据并解析
-(NSDictionary*)convertJsonDataWithURL:(NSString*)nurl withDataKey:(NSString *)dataKey;
#pragma mark 通过URL请求json数据并解析［TouchJson方法］
-(NSDictionary*)convertCJsonDataWithURL:(NSString*)nurl withDataKey:(NSString *)dataKey;

@end
