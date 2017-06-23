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

/**
 *  登陆
 *
 *  @param username 用户名
 *  @param password 密码
 *
 *  @return 是否登陆
 */
+ (BOOL)loginWithUserName:(NSString *)username andPassword:(NSString *)password;

/**
 *  请求电影列表
 *
 *  @return 电影对象数组
 */
+ (NSArray *)requestMovieList;

@end
