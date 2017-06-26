//
//  User.h
//  Weibo
//
//  Created by qiang on 5/4/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

// 编号
@property (nonatomic,assign) int id;
// 名字
@property (nonatomic,copy) NSString *name;
// 头像
@property (nonatomic,copy) NSString *profile_image_url;
    // 头像地址URL
@property (nonatomic,strong) NSURL *imageURL;

// 是否是认证用户
@property (nonatomic,assign) BOOL verfied;
// 认证类型 -1:没有认证 0:认证的用户 2,3,5:企业认证 220:达人
@property (nonatomic,assign) int verified_type;
    // 用户认证的图片
@property (nonatomic,strong) UIImage *verifiedImage;

// 用户等级
@property (nonatomic,assign) int mbrank;
    // 等级图片
@property (nonatomic,strong) UIImage *mbrankImage;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)userWithDict:(NSDictionary *)dict;

@end
