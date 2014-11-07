//
//  NSString+URLEncoding.m
//
//  Created by 崔宝印
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)

//url string encode
//use the we can define the characters that we don't want to decode and encode
- (NSString *)URLEncodedString
{
    NSString *result = ( NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            //define the character that we don't want to decode and encode
                                            CFSTR("!*();+$,%#[] "),
                                            kCFStringEncodingUTF8));
    return result;
}

//url string decode
- (NSString*)URLDecodedString
{
    NSString *result = ( NSString *)
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                            (CFStringRef)self,
                                                            CFSTR(""),
                                                            kCFStringEncodingUTF8));
    return result;
}

@end
