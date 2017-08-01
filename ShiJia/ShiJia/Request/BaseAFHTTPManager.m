//
//  BaseAFHTTPManager.m
//  HiTV
//
//  Created by 蒋海量 on 15/3/3.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "BaseAFHTTPManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFXMLDictionaryResponseSerializer.h"



@implementation BaseAFHTTPManager

+(NSString*)p_getURLWithParameters:(NSString*)param forHost:(NSString*)host{
    return [[NSString stringWithFormat:@"%@%@", host, param ?:@""] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+(void)postRequestOperationForHost:(NSString *)host
                          forParam:(NSString *)param
                     forParameters:(id)parameters
                        completion:(void (^)(id responseObject))success
                           failure:(void (^)(NSString *error))failure{

    NSString *url = [self p_getURLWithParameters:param forHost:host];
    DDLogInfo(@"post-----request:%@-----",url);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager  manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    manager.requestSerializer.timeoutInterval = 30;
    [manager.requestSerializer setValue:[parameters objectForKey:@"authkey"] forHTTPHeaderField:@"authkey"];
    
    
    if ([url containsString:@"https"]) {
        manager.securityPolicy =  [self customSecurityPolicy];

    }
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([error localizedDescription]);
    }];
}

+(void)postRequestOperationForHost:(NSString *)host
                          forParam:(NSString *)param
                     forParameters:(id)parameters
                          data:(NSData *)imageData
                        completion:(void (^)(id responseObject))success
                           failure:(void (^)(NSString *error))failure
{
    
    NSString *url = [self p_getURLWithParameters:param forHost:host];
    DDLogInfo(@"-----request:%@-----",url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager  manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    //申明请求的数据是json类型
    //manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    if ([url containsString:@"https"]) {
        manager.securityPolicy =  [self customSecurityPolicy];

    }
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"faceImg" fileName:@"faceImg.png" mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLogInfo(@"-----result:%@-----",responseObject);
        success(responseObject);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([error localizedDescription]);

    }];
}

+(void)postRequestOperationForHost:(NSString *)host
                          forParam:(NSString *)param
                     forParameters:(id)parameters
                              data:(NSData *)data
                          filename:(NSString *)filename
                          mimetype:(NSString *)minetype
                        completion:(void (^)(id responseObject))success
                           failure:(void (^)(NSString *error))failure
{
    NSString *url = [self p_getURLWithParameters:param forHost:host];
    DDLogInfo(@"-----request:%@-----",url);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager  manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    //申明请求的数据是json类型
    //manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    if ([url containsString:@"https"]) {
        manager.securityPolicy =  [self customSecurityPolicy];

    }
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:filename fileName:filename mimeType:minetype];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLogInfo(@"-----result:%@-----",responseObject);
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([error localizedDescription]);
        
    }];
}


+(void)postJsonRequestOperationForHost:(NSString *)host
                          forParam:(NSString *)param
                     forParameters:(id)parameters
                        completion:(void (^)(id responseObject))success
                           failure:(void (^)(NSString *error))failure{
    
    NSString *url = [self p_getURLWithParameters:param forHost:host];
    DDLogInfo(@"-----request:%@-----",url);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager  manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setValue:[parameters objectForKey:@"Authorization"] forHTTPHeaderField:@"Authorization"];
    manager.requestSerializer.timeoutInterval = 30;
    if ([url containsString:@"https"]) {
        manager.securityPolicy =  [self customSecurityPolicy];

    }
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLogInfo(@"-----result:%@-----",responseObject);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([error localizedDescription]);
    }];
}

+(void)getRequestOperationForHost:(NSString *)host
                   forParam:(NSString *)param
              forParameters:(id)parameters
                 completion:(void (^)(id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation,NSString *error))failure{
    NSString *url = [self p_getURLWithParameters:param forHost:host];
    DDLogInfo(@"-----request:%@-----",url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager  manager];
    ///申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
   
    manager.requestSerializer.timeoutInterval = 30;
    
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    if ([url containsString:@"https"]) {
        manager.securityPolicy =  [self customSecurityPolicy];

    }
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLogInfo(@"-----result:%@-----",responseObject);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,[error localizedDescription]);
    }];
}

+(AFHTTPRequestOperation*)requestJsonWithParameter:(NSString*)param
                                            forHost:(NSString*)host
                                         completion:(void (^)(id responseObject))success
                                            failure:(void (^)(NSString *error))failure{
    NSString* url = [self p_getURLWithParameters:param forHost:host];
    NSURL *URL = [NSURL URLWithString:url];
    DDLogInfo(@"-----request:%@-----",URL);
//    DDLogInfo(@"requestJsonWithParameter fromURL: %@, withParam: %@", URL, param);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setTimeoutInterval:30];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableSet *set = [NSMutableSet setWithSet:operation.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    operation.responseSerializer.acceptableContentTypes = set;
    if ([url containsString:@"https"]) {
        operation.securityPolicy =  [self customSecurityPolicy];

    }
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLogInfo(@"-----result:%@-----",responseObject);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([error localizedDescription]);
    }];
    
    [operation start];
    return operation;
}

+(AFHTTPRequestOperation*)requestXMLWithParameter:(NSString*)param
                                           forHost:(NSString*)host
                                        completion:(void (^)(id responseObject))success
                                           failure:(void (^)(NSString *error))failure{
    NSString* url = [self p_getURLWithParameters:param forHost:host];
    NSURL *URL = [NSURL URLWithString:url];
    
    //    DDLogInfo(@"XML URL: %@", URL);
    DDLogInfo(@"-----request:%@-----",URL);
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFXMLDictionaryResponseSerializer serializer];
    NSMutableSet *set = [NSMutableSet setWithSet:operation.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    operation.responseSerializer.acceptableContentTypes = set;
    
    if ([url containsString:@"https"]) {
        operation.securityPolicy =  [self customSecurityPolicy];

    }
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLogInfo(@"-----result:%@-----",responseObject);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([error localizedDescription]);
    }];
    
    [operation start];
    return operation;
}
+ (AFSecurityPolicy*)customSecurityPolicy {
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"ystenssl" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    //securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = @[certData];
    
    return securityPolicy;
}
@end
