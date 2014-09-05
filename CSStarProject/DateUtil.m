//
//  DateUtil.m
//  CSStarProject
//
//  Created by jialiduo on 14-9-2.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "DateUtil.h"
#import "common.h"

@implementation DateUtil

//获取当前日期
-(NSDate *)getCurDate{
    NSDate *date = [NSDate date];
    NSLog(@"当前日期:%@",date);
    return date;
}

-(NSString *)getCurDateStr{
    return [self getCurDateWithFormat:SIMPLE_DATE_FORMATER];
}

-(NSString *)getCurDateTimeStr{
    return [self getCurDateWithFormat:SIMPLE_DATETIME_FORMATER];
}

//获取当前日期格式化日期
-(NSString *)getCurDateWithFormat:(NSString *)formater{
    NSDateFormatter *dateToStringFormatter=[[NSDateFormatter alloc] init];
    [dateToStringFormatter setDateFormat:formater];
    NSString *nsDate=[dateToStringFormatter stringFromDate:[self getCurDate]];
    NSLog(@"当前日期:%@", nsDate);
    return nsDate;
}

//格式化指定日期
-(NSString*)date2StringWithFomat:(NSString *) formater WithDate:(NSDate *)date{
    NSDateFormatter *dateToStringFormatter=[[NSDateFormatter alloc] init];
    [dateToStringFormatter setDateFormat:formater];
    NSString *nsDate=[dateToStringFormatter stringFromDate:date];
    NSLog(@"格式化指定日期:%@", nsDate);
    return nsDate;
}


-(NSString *)fixStringForDate:(NSDate *)date withFormater:(NSString *)formater{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:kCFDateFormatterFullStyle];
    [dateFormatter setDateFormat:formater];
    NSString *fixString = [dateFormatter stringFromDate:date];
    NSLog(@"修正当前日期:%@",fixString);
    return fixString;
}

/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *) compareCurrentTime:(NSDate*) compareDate{
    
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

@end
