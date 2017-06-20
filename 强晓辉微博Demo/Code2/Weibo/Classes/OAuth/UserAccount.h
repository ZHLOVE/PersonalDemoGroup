//
//  UserAccount.h
//  Weibo
//
//  Created by qiang on 4/28/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAccount : NSObject<NSCoding>

+ (UserAccount *)sharedUserAccount;

// 授权信息
@property (nonatomic,copy) NSString *access_token;  // 令牌
@property (nonatomic,assign) int expires_in;        // 过期时间  (当前认证时间点过多少秒后,令牌过期,服务器就要求你重新登录，获取新的令牌)
@property (nonatomic,copy) NSString *uid;           // 用户uid
@property (nonatomic,strong) NSDate *expires_Date;  // 令牌具体过期日期时间 （认证的时候+expires_in)

// 用户信息
@property (nonatomic,copy) NSString *screen_name;   // 昵称
@property (nonatomic,copy) NSString *avatar_large;  // 用户头像地址

// 请求获取用户信息
- (void)requstUserInfo;
- (void)requstUserInfoSuccesBlock:(void (^)(UserAccount *account))successBlock
                        failBlock:(void (^)(NSError *error))failBlock;

// 是否已登录
- (BOOL)isLogined;

@end
