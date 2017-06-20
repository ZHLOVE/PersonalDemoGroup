//
//  NetWorkTools.h
//  WeiBo
//
//  Created by student on 16/4/28.
//  Copyright © 2016年 BNG. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface NetWorkTools : AFHTTPSessionManager

+ (NetWorkTools *)sharedNetWorkTools;

@end
