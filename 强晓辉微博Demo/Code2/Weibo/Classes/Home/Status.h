//
//  Status.h
//  Weibo
//
//  Created by qiang on 5/4/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"

@interface Status : NSObject

//"created_at": "Tue May 31 17:46:55 +0800 2011",
//"id": 11488058246,
//"text": "求关注。"，
//"source": "<a href="http://weibo.com" rel="nofollow">新浪微博</a>",

// 创建时间
@property (nonatomic,copy) NSString *created_at;
// 微博id
@property (nonatomic,assign) int id;
// 微博正文
@property (nonatomic,copy) NSString *text;
// 微博来源
@property (nonatomic,copy) NSString *source;
// 图片数组
@property (nonatomic,strong) NSArray *pic_urls;

// 发帖人的信息
@property (nonatomic,strong) User *user;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)statusWithDict:(NSDictionary *)dict;

+ (void)requestStatusWithSuccessBlock:(void (^)(NSArray *status))successBlock
                            failBlock:(void (^)(NSError *error))failBlock;
@end
