//
//  User.h
//  Weibo
//
//  Created by qiang on 5/4/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

// 编号
@property (nonatomic,assign) int id;
// 名字
@property (nonatomic,copy) NSString *name;
// 头像
@property (nonatomic,copy) NSString *profile_image_url;
// 是否是认证用户
@property (nonatomic,assign) BOOL verfied;
// 认证类型
@property (nonatomic,assign) int verified_type;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)userWithDict:(NSDictionary *)dict;

@end
