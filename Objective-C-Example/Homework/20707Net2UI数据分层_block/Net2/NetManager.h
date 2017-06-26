//
//  NetManager.h
//  Net2
//
//  Created by student on 16/3/29.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetManager : NSObject

// 1. 同步请求方式
// 登陆
+ (BOOL)loginWithUserName:(NSString *)username andPasswd:(NSString *)passwd;
// 2. 异步请求方式
// 2.1 委托模式(代理)
// 2.2 观察者模式(通知)
// 2.3 block方式
+ (void)loginWithUserName:(NSString *)username
                andPasswd:(NSString *)passwd
             successBlock:(void(^)())successBlock
                failBlock:(void(^)(NSError *error))failBlock;
//说明:
//void (^)() => 这是一个block的类型 这block类型无参数,返回值
//void (^)(NSError *) =>

// 获取视频列表
+ (NSArray *)requestMovieList;
@end
