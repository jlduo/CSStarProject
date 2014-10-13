//
//  DateUtil.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-2.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSDate


-(NSDate *)getCurDate;

-(NSString *)getCurDateStr;

-(NSString *)getCurDateTimeStr;

-(NSString *)getCurDateWithFormat:(NSString *)formater;

-(NSString *)fixStringForDate:(NSDate *)date withFormater:(NSString *)formater;

-(NSString*)date2StringWithFomat:(NSString *) formater WithDate:(NSDate *)date;

-(NSDate *)stringToDate:(NSString *)strdate;
-(NSString *)dateToString:(NSDate *)date;
-(NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate;
-(NSString *)getLocalDateFormateUTCDate1:(NSString *)utcDate;
-(NSString *)getLocalDateFormateUTCDate2:(NSString *)utcDate;
-(NSString *)getUTCFormateLocalDate:(NSString *)localDate;

@end
