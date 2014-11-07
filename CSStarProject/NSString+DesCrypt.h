//
//  NSString+DesCrypt.h
//  CbyTools
//
//  Created by 崔宝印 on 10/24/13.
//  Copyright (c) 2013 崔 宝印. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DesCrypt)

- (NSString *)desEncryptString:(NSString*)src withKey:(NSString *)key;
- (NSString *)desDecryptString:(NSString*)src withKey:(NSString *)key;

@end
