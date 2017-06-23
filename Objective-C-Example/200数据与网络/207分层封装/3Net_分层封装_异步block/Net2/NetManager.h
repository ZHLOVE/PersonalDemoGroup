//
//  NetManager.h
//  Net2
//
//  Created by niit on 16/3/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

// 封装数据请求
@interface NetManager : NSObject

// 2. 异步请求方式
// 2.1 委托模式(代理)
// 2.2 观察者模式(通知)
// 2.3 block方式

/**
 *  登陆
 *
 *  @param username     用户名
 *  @param password     密码
 *  @param successBlock 登陆成功时执行的block
 *  @param failBlock s   登陆失败时执行的block
 */
+ (void)loginWithUserName:(NSString *)username
              andPassword:(NSString *)password
             successBlock:(void (^)())successBlock
              failedBlock:(void (^)(NSError *))failBlock;
/**
 *  获取电影列表
 *
 *  @param successBock 获取成功时执行的block
 *  @param failBlock   获取失败时执行的block
 */
+ (void)requestMovieListWithSuccessBlock:(void (^)(NSArray *))successBock
                             failedBlock:(void (^)(NSError *))failBlock;

//说明:
//void (^)() =>             这是一个block的类型 无参数、五返回值block类型
//void (^)(NSError *) =>    参数是NSError类型、无返回值的block类型

@end
