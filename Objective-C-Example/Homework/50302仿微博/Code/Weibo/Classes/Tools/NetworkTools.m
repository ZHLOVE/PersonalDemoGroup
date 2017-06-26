//
//  NetworkTools.m
//  Weibo
//
//  Created by qiang on 4/28/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "NetworkTools.h"

static NetworkTools *instance = nil;

@implementation NetworkTools

+ (NetworkTools *)sharedNetwrokTools
{
    if(instance == nil)
    {
        NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/"];
        instance = [[NetworkTools alloc] initWithBaseURL:url];
        
    }
    return instance;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url sessionConfiguration:nil];

    // 返回的数据 responseObject 类型格式设置是二进制数据
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    return self;
}



@end
