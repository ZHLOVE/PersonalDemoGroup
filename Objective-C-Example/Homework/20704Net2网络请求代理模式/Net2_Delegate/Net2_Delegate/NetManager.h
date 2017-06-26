//
//  NetManager.h
//  Net2_Delegate
//
//  Created by student on 16/3/30.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Singleton.h"
@protocol NetManagerDelegate<NSObject>
//登陆回调
- (void)loginSuccess;
- (void)loginFail:(NSError *)error;

//电影列表获取回调
- (void)requestMovieListSuccess:(NSArray *)list;
- (void)requestMovieListFail:(NSError *)error;

@end

@interface NetManager : NSObject

SingletonH(NetManager);
/**
 *  1. 登陆
 *
 *  @param username     用户名
 *  @param password     密码
 */
- (void)loginWithUserName:(NSString *)userName
                andPasswd:(NSString *)passwd;

/**
 *  2. 获取电影列表
 *
 *  @param successBock 获取成功时执行的block
 *  @param failBlock   获取失败时执行的block
 */
- (void)requestMovieList;
@property (nonatomic,weak) id<NetManagerDelegate> delegate;

@end

//封装数据请求
