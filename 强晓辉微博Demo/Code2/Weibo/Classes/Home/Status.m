//
//  Status.m
//  Weibo
//
//  Created by qiang on 5/4/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "Status.h"

#import "UserAccount.h"
#import "NetworkTools.h"

@implementation Status

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)statusWithDict:(NSDictionary *)dict
{
    return [[[self class] alloc] initWithDict:dict];
}


- (void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"user"]) // 遇到key为user的时候特殊处理一下
    {
        self.user = [User userWithDict:value];
        return;
    }
    
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (void)requestStatusWithSuccessBlock:(void (^)(NSArray *status))successBlock
                            failBlock:(void (^)(NSError *error))failBlock
{
    //1. 路径: oauth2/access_token
    NSString *path = @"2/statuses/home_timeline.json";
    //2. 参数
    NSDictionary *dict = @{@"access_token":[UserAccount sharedUserAccount].access_token};
    
    //3. 发送请求
    [[NetworkTools sharedNetwrokTools] GET:path parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dict);
        NSArray *arr = dict[@"statuses"];
        // 处理得到数据
        NSMutableArray *mArr = [NSMutableArray array];
        for(NSDictionary *d in arr)
        {
            Status *status = [Status statusWithDict:d];
            NSLog(@"%@",status.user);
            [mArr addObject:status];
        }
        successBlock(mArr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
        failBlock(error);
    }];
    
}
@end
