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
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
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


//NSString 2 NSDate
- (NSDate *)stringToDate:(NSString *)strdate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *retdate = [dateFormatter dateFromString:strdate];
    return retdate;
}

//NSDate 2 NSString
- (NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

//将本地日期字符串转为UTC日期字符串
//本地日期格式:2013-08-03 12:53:51
//可自行指定输入输出格式
-(NSString *)getUTCFormateLocalDate:(NSString *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:localDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}

//将UTC日期字符串转为本地时间字符串
//输入的UTC日期格式2013-08-03T04:53:51+0000
-(NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}

//将UTC日期字符串转为本地时间字符串
//输入的UTC日期格式2013-08-03T04:53:51
-(NSString *)getLocalDateFormateUTCDate1:(NSString *)utcDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}





@end
