//
//  HttpClient.m
//  TruckAlliance
//
//  Created by LiuJie on 14-9-26.
//  Copyright (c) 2014年 zuoteng. All rights reserved.
//

#import "HttpClient.h"
#import "AFNetworking.h"

@interface OperationDelegate : NSObject

@property (nonatomic, strong) NSOperation *operation;
@property (nonatomic, strong) NSString *identifier;

@end

@implementation OperationDelegate

@end

@interface HttpClient ()

@property (nonatomic, strong) NSMutableArray *operationArray;//http请求数组

@end

@implementation HttpClient

DEFINE_SINGLETON_FOR_CLASS(HttpClient)

#pragma mark - 移除HTTP请求

+ (void)deleteOperationWithIdentifier:(NSString *)identifier
{
    HttpClient *httpClient = [HttpClient singletonHttpClient];
    for (int i=0; i<httpClient.operationArray.count; i++)
    {
        OperationDelegate *operationDelegate = [httpClient.operationArray objectAtIndex:i];
        if ([operationDelegate.identifier isEqualToString:identifier])
        {
            if (!operationDelegate.operation.isCancelled)
            {
                [operationDelegate.operation cancel];
            }
            [httpClient.operationArray removeObject:operationDelegate];
        }
    }
}

#pragma mark - 普通请求

//get请求
+ (void)GET:(NSString *)address
 parameters:(id)parameters
     isjson:(BOOL)isjson
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (!isjson) {//解析非json数据
         manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    AFHTTPRequestOperation *operation = [manager GET:address parameters:parameters success:success failure:failure];
    
    HttpClient *httpClient = [HttpClient singletonHttpClient];
    OperationDelegate *operationDelegate = [OperationDelegate new];
    operationDelegate.operation = operation;
    [httpClient.operationArray addObject:operationDelegate];
}

//post请求
+ (void)POST:(NSString *)address
  parameters:(id)parameters
      isjson:(BOOL)isjson
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (!isjson) {//解析非json数据
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    AFHTTPRequestOperation *operation = [manager POST:address parameters:parameters success:success failure:failure];
    
    HttpClient *httpClient = [HttpClient singletonHttpClient];
    OperationDelegate *operationDelegate = [OperationDelegate new];
    operationDelegate.operation = operation;
    [httpClient.operationArray addObject:operationDelegate];
}

#pragma mark - 登陆注册

//用户注册
+ (void)userRegister:(NSString *)username
             password:(NSString *)password
                checkcode:(NSString *)checkcode
               isjson:(BOOL)isjson
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *urlPath = [NSString stringWithFormat:@"%@%@",REMOTE_URL,REGISTER_URL];
    NSDictionary *parameters = @{@"username":username, @"verifycode":checkcode,@"password":password};
    
    [self POST:urlPath parameters:parameters isjson:isjson success:success failure:failure];
}

//获取验证码
+(void)getCheckCode:(NSString *)mobile isjson:(BOOL)isjson success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    NSDictionary *parameters = @{@"mobile":mobile};
    NSString *code_url = [NSString stringWithFormat:@"%@%@",REMOTE_URL,CHECK_CODE_URL];
    [self POST:code_url parameters:parameters isjson:isjson success:success failure:failure];
    
}

//找回密码
+(void)findPassword:(NSString *)username isjson:(BOOL)isjson success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    NSDictionary *parameters = @{@"username":username};
    NSString *pwd_url = [NSString stringWithFormat:@"%@%@",REMOTE_URL,GET_PASSWORD_URL];
    [self POST:pwd_url parameters:parameters isjson:isjson success:success failure:failure];
    
}

/**
 获取用户信息
 */
+ (void)loadUserInfo:(NSString *)username
              isjson:(BOOL)isjson
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSDictionary *parameters = @{@"username":username};
    NSString *url = [NSString stringWithFormat:@"%@%@", REMOTE_URL, USER_CENTER_URL];
    [self GET:url parameters:parameters isjson:isjson success:success failure:failure];
    
}

/**
 获取用户中心信息
 */
+ (void)getUserCenterData:(NSString *)userid
              isjson:(BOOL)isjson
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString *user_url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_USERCENTER_NUMS_URL,userid];
    [self GET:user_url parameters:nil isjson:isjson success:success failure:failure];
    
}


/**
 获取Ta的用户中心信息
 */
+ (void)getOTUserCenterData:(NSString *)userid
                   isjson:(BOOL)isjson
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString *user_url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_MYPROJECT_NUMS_URL,userid];
    [self GET:user_url parameters:nil isjson:isjson success:success failure:failure];
    
}


//用户登录
+ (void)userLogin:(NSString *)userName
         password:(NSString *)password
           isjson:(BOOL)isjson
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    NSDictionary *parameters = @{@"username":userName, @"password":password};
    NSString *url = [NSString stringWithFormat:@"%@%@", REMOTE_URL, LOGIN_URL];
    [self POST:url parameters:parameters isjson:isjson success:success failure:failure];
    
}

//上传用户头像
+ (void)uploadUserIcon:(NSString *)userName
         fileExt:(NSString *)fileExt
          base64Str:(NSString *)base64Str
           isjson:(BOOL)isjson
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    NSDictionary *parameters = @{@"username":userName, @"fileExt":fileExt, @"base64":base64Str};
    NSString *url = [NSString stringWithFormat:@"%@%@",REMOTE_ADMIN_URL,UPLOAD_IMG_URL];
    [self POST:url parameters:parameters isjson:isjson success:success failure:failure];
    
}

//修改用户信息(修改密码)
+ (void)updateUserInfo:(NSDictionary *)parameters
                isjson:(BOOL)isjson
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    NSString *url;
    NSString *password = [parameters valueForKey:@"password"];
    if(password!=nil && ![password isEqualToString:@""]){//修改密码
        NSLog(@"修改用户密码！");
        url = [NSString stringWithFormat:@"%@%@",REMOTE_URL,EDIT_PASSWORD_URL];
    }else{
        NSLog(@"修改用户信息！");
        url = [NSString stringWithFormat:@"%@%@",REMOTE_URL,EDIT_USER_URL];
    }
    
    [self POST:url parameters:parameters isjson:isjson success:success failure:failure];
    
}



@end
