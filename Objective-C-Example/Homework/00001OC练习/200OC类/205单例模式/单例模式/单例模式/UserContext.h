//
//  UserContext.h
//  单例模式
//
//  Created by niit on 15/12/31.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserContext : NSObject

// 1 声明一个类方法
+ (UserContext *)sharedUserContext;
// 这个类方法的命名一般格式:
// shared+类名
// default+类名

// 用户名密码
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *password;

// 登陆状态
@property (nonatomic,assign) BOOL logined;

@end
