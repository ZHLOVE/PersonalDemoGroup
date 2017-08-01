//
//  BaseNetwork.m
//  logDemo
//
//  Created by MccRee on 2017/7/24.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "BaseNetwork.h"
#import "AFNetworking.h"
#import "MJExtension.h"


@implementation BaseNetwork
+ (instancetype)sharedNetwork{
    static BaseNetwork *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[BaseNetwork alloc] init];
    });
    return instance;
}


+ (NSString *)p_getURLWithParameters:(NSString *)param forHost:(NSString *)host{
    return [[NSString stringWithFormat:@"%@%@", host,param] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
}


+ (void)postRequestHTTPSerializerForHost:(NSString *)host
                           forParam:(NSString *)param
                      forParameters:(id)parameters
                         completion:(void (^)(id responseObject))success
                            failure:(void (^)(NSString *error))failure{

    NSString *url = [NSString stringWithFormat:@"%@%@", host,param];
    NSLog(@"POST_URL\n%@",url);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 3;
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([error localizedDescription]);
    }];
}
    



@end
