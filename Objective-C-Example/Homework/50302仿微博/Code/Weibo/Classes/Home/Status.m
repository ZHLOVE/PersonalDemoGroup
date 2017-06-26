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
#import "NSDate+Covertion.h"

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

// 修改Created_at的set方法，直接在这个set方法里处理
- (void)setCreated_at:(NSString *)created_at
{
//    _created_at = created_at;
    NSLog(@"%@",created_at);
    
    
    
    // 1 当前:(要处理的字符串:)
//    Mon May 09 14:24:06 +0800 2016
    
    // 2 结果:(转换成的字符串)
    // 1分钟以内 显示 刚刚
    // 60分钟以内 显示 多少分钟之前
    // 60分钟之前 显示 几小时之前
    // 昨天      显示 昨天
    // 更早的时间 显示 04-05
    // 去年      显示 15-12-09
    
    // 转换为日期对象
    NSDate *date = [NSDate dateWithString:created_at];
    NSLog(@"%@",date);
    // 转换为我们想要的字符串
//    date = [NSDate dateWithTimeInterval:-6*30*24*60*60 sinceDate:[NSDate date]];// 临时测试时间格式
    _created_at = [date descDate];
}

- (void)setSource:(NSString *)source
{
//    _source = source;
    NSLog(@"%@",source);
    
    if(source.length>0)
    {
        NSRange range1 = [source rangeOfString:@">"];
        NSRange range2 = [source rangeOfString:@"<" options:NSBackwardsSearch];// 从后面往前查找
        
        if(range1.location != NSNotFound && range2.location!= NSNotFound)
        {
            NSRange newRange = NSMakeRange(range1.location+1, range2.location - range1.location - 1);
            _source = [@"来自:" stringByAppendingString:[source substringWithRange:newRange]];
        }
    }
    
}

- (void)setPic_urls:(NSArray *)pic_urls{
    
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
