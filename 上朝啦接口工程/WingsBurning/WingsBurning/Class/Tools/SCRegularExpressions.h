//
//  SCRegularExpressions.h
//  WingsBurning
//
//  Created by MBP on 16/8/23.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SCRegularExpressions : NSObject
//邮箱
+ (BOOL) validateEmail:(NSString *)email;
//电话
+ (BOOL)validateMobile:(NSString *)phone;
//车牌号
+ (BOOL) validateCarNo:(NSString *)carNo;
//车的型号
+ (BOOL) validateCarType:(NSString *)CarType;
//用户名
+ (BOOL) validateUserName:(NSString *)name;
//密码
+ (BOOL) validatePassword:(NSString *)passWord;
//昵称
+ (BOOL) validateNickname:(NSString *)nickname;
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
//判断是否有特殊符号
- (BOOL)effectivePassword;
//判断手机型号
+ (NSString *)deviceString;

@end
