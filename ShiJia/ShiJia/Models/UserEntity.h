//
//  UserEntity.h
//  HiTV
//
//  Created by 蒋海量 on 15/7/27.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecentVideo.h"

@interface UserEntity : NSObject

@property (nonatomic, strong) NSString *faceImg;
@property (nonatomic, strong) NSString *jid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) __block NSString *phoneNo;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *userAuth;
@property (nonatomic, strong) NSString *xmppCode;
@property (nonatomic, strong) NSString *authorType;
@property (nonatomic, strong) NSString *friendAuthorType;
@property (nonatomic, strong) NSString *enName;



//通讯录
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *type;

//正在观看
@property (nonatomic, strong) NSString *programName;
@property (nonatomic, strong) RecentVideo *watchingEntity;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
