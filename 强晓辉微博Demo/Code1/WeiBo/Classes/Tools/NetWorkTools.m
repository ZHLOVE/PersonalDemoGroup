//
//  NetWorkTools.m
//  WeiBo
//
//  Created by student on 16/4/28.
//  Copyright © 2016年 BNG. All rights reserved.
//

#import "NetWorkTools.h"
static NetWorkTools *instance = nil;
@implementation NetWorkTools
+ (NetWorkTools *)sharedNetWorkTools{
    if (instance == nil) {
        NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/"];
        instance = [[NetWorkTools alloc]initWithBaseURL:url];
    }
    return instance;
}
- (instancetype)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url sessionConfiguration:nil];
    //responseObject的格式二进制数据
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    return  self;
}


@end
