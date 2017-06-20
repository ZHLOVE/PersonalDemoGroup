//
//  UserAccount.h
//  WeiBo
//
//  Created by student on 16/4/28.
//  Copyright © 2016年 BNG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAccount : NSObject<NSCoding>

@property(nonatomic,copy) NSString *access_token; //令牌单位秒
@property(nonatomic,assign) int expires_in;   //过期时间
@property(nonatomic,copy) NSString *uid;      //用户uid
@property(nonatomic,strong)NSDate *expires_Date; //令牌具体过期时间

@property(nonatomic,copy) NSString *screen_name;//昵称
@property(nonatomic,copy) NSString *avatar_large;//头像地址


+ (UserAccount *)sharedUserAccount;
- (void)loadUserInfo;


// 获取用户信息
- (void)loadUserInfo;

// 是否已登录
- (BOOL)isLogined;


@end
