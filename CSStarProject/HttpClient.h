//
//  HttpClient.h
//  TruckAlliance
//
//  Created by LiuJie on 14-9-26.
//  Copyright (c) 2014年 zuoteng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "common.h"

@class AFHTTPRequestOperation;

@interface HttpClient : NSObject

DEFINE_SINGLETON_FOR_HEADER(HttpClient)

#pragma mark - 移除HTTP请求

/**
 删除指定标示符的请求
 */
+ (void)deleteOperationWithIdentifier:(NSString *)identifier;

#pragma mark - 普通请求

/**
 GET请求
 */
+ (void)GET:(NSString *)address
 parameters:(id)parameters
     isjson:(BOOL)isjson
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 POST请求
 */
+ (void)POST:(NSString *)url
  parameters:(id)parameters
  isjson:(BOOL)isjson
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - 登陆注册

/**
 用户注册
 */
+ (void)userRegister:(NSString *)username
            password:(NSString *)password
           checkcode:(NSString *)checkcode
              isjson:(BOOL)isjson
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 获取验证码
 */
+ (void)getCheckCode:(NSString *)mobile
              isjson:(BOOL)isjson
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//找回密码
+ (void)findPassword:(NSString *)mobile
              isjson:(BOOL)isjson
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
    
/**
 获取用户信息
 */
+ (void)loadUserInfo:(NSString *)username
              isjson:(BOOL)isjson
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 获取用户中心信息
 */
+ (void)getUserCenterData:(NSString *)userid
                   isjson:(BOOL)isjson
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 获取Ta的用户中心信息
 */
+ (void)getOTUserCenterData:(NSString *)userid
                     isjson:(BOOL)isjson
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 用户登录
 */
+ (void)userLogin:(NSString *)username
         password:(NSString *)password
           isjson:(BOOL)isjson
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//上传用户头像
+ (void)uploadUserIcon:(NSString *)userName
               fileExt:(NSString *)fileExt
             base64Str:(NSString *)base64Str
                isjson:(BOOL)isjson
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//修改用户信息(修改密码)
+ (void)updateUserInfo:(NSDictionary *)parameters
                isjson:(BOOL)isjson
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end

