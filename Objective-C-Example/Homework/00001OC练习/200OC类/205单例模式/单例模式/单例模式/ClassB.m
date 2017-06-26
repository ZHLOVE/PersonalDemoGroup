//
//  ClassB.m
//  单例模式
//
//  Created by niit on 15/12/31.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "ClassB.h"

#import "UserContext.h"
@implementation ClassB

- (void)printInfo
{
    UserContext *userInfo = [UserContext sharedUserContext];
    
    NSLog(@"用户名:%@ 密码:%@ 登陆状态:%@",userInfo.username,userInfo.password,userInfo.logined?@"已登陆":@"未登录");
}
@end
