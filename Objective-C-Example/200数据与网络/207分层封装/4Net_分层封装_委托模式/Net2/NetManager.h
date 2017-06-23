//
//  NetManager.h
//  Net2
//
//  Created by niit on 16/3/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Singleton.h"

@protocol NetManagerDelegate <NSObject>

// 登陆回调
- (void)loginSuccess;
- (void)loginFail:(NSError *)error;

// 电影列表获取回调
- (void)requestMovieListSuccess:(NSArray *)list;
- (void)requestMovieListFail:(NSError *)error;

@end

// 封装数据请求
@interface NetManager : NSObject

// 单例
SingletonH(NetManager);

/**
 *  1. 登陆
 *
 *  @param username     用户名
 *  @param password     密码
 */
- (void)loginWithUserName:(NSString *)username
              andPassword:(NSString *)password;
/**
 *  2. 获取电影列表
 *
 *  @param successBock 获取成功时执行的block
 *  @param failBlock   获取失败时执行的block
 */
- (void)requestMovieList;

// 代理人
@property (nonatomic,weak) id<NetManagerDelegate> delegate;

@end
