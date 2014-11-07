//
//  NSString+DesCrypt.m
//  CbyTools
//
//  Created by 崔宝印 on 10/24/13.
//  Copyright (c) 2013 崔 宝印. All rights reserved.
//

#import "NSString+DesCrypt.h"
#import <CommonCrypto/CommonCryptor.h>

unsigned char _map_ch2hex[] =
{
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09,
    0, 0, 0, 0, 0, 0, 0,    // :, ;, <, =, >, ?, @,
    0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
};

@implementation NSString (DesCrypt)

- (NSString *)desEncryptString:(NSString*)src withKey:(NSString *)key
{
    NSString *strRet = @"";
    
    // encrypt source content
    NSData *bytes = [src dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [self desCryptWithOperation:kCCEncrypt bytes:bytes key:key];
    
    // format bytes to visible string
    char* pBuff = (char*)[data bytes];
    for (int i = 0; i < data.length; i++)
    {
        strRet = [strRet stringByAppendingFormat:@"%02X", pBuff[i] & 0xFF];
    }
    return strRet;
}

- (NSString *)desDecryptString:(NSString*)src withKey:(NSString *)key
{
    // decode source content to bytes
    unsigned char* bytes = (unsigned char*)malloc((src.length+1)*sizeof(unsigned char));
    [[src uppercaseString] getCString:(char*)bytes maxLength:src.length+1 encoding:NSUTF8StringEncoding];
    unsigned char *p1 = bytes, *p2 = bytes;
    int n = src.length * 0.5;
    for (int i = 0; i < n; i++)
    {
        *p1 = _map_ch2hex[*p2-'0'] * 0x10 + _map_ch2hex[*(p2+1)-'0'];
        p1++;
        p2+=2;
    }
    NSData* data = [NSData dataWithBytes:bytes length:n];

    // decrypt source bytes
    NSData* dataOut = [self desCryptWithOperation:kCCDecrypt bytes:data key:key];
    free(bytes);
    return [[NSString alloc] initWithData:dataOut encoding:NSUTF8StringEncoding];
}

- (NSData *)desCryptWithOperation:(CCOperation)operation bytes:(NSData*)bytes key:(NSString *)key
{
    NSUInteger dataLength = [bytes length];
    
    size_t bufferSize = ([bytes length] + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    unsigned char *buffer = (unsigned char *)malloc(bufferSize*sizeof(unsigned char));
    memset((void*)buffer, 0, bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          (void const*)[key UTF8String],
                                          kCCKeySizeDES,
                                          NULL,
                                          [bytes bytes], dataLength,
                                          (void*)buffer, bufferSize,
                                          &numBytesCrypted);
    NSData* dataRet = nil;
    if (cryptStatus == kCCSuccess)
    {
        dataRet = [[NSData alloc] initWithBytes:buffer length:numBytesCrypted];
    }
    free(buffer);
    return dataRet;
}

@end
