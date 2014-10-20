//
//  ViewPassValueDelegate.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-10.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ViewPassValueDelegate <NSObject>

//传递参数到方法
-(void)passValue:(NSString *)val;
-(void)passDicValue:(NSDictionary *)vals;

@end
