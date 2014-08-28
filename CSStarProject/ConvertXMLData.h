//
//  ConvertXMLData.h
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvertXMLData : NSObject

#pragma mark 通过URL请求xml数据并解析
-(NSDictionary*)convertXMLDataWithURL:(NSString*)xmlUrlString;
#pragma mark 通过filePaht请求本地xml数据并解析
-(NSDictionary*)convertXMLDataWithFileName:(NSString*)xmlFileName;
@end
