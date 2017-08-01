//
//  ScreenDeviceInfo.h
//  HiTV
//
//  Created by cs090_jzb on 15/8/17.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 关联状态
 TOGETHER_SAME_NET：同网在一起，
 TOGETHER_DIFF_NET：异网在一起，
 UNTOGETHER_ONLINE：在线不在一起用户，
 UNTOGETHER_OFFLINE：不在线在线不在一起用户
 */
#define TOGETHER_SAME_NET   @"TOGETHER_SAME_NET"
#define TOGETHER_DIFF_NET   @"TOGETHER_DIFF_NET"
#define UNTOGETHER_ONLINE   @"UNTOGETHER_ONLINE"
#define UNTOGETHER_OFFLINE  @"UNTOGETHER_OFFLINE"

@interface ScreenDeviceInfo : NSObject

@property (nonatomic, assign) BOOL isWiff;          //手机应用网络状态
@property (nonatomic, retain) NSString* tvAnonymousUid; //uid
@property (nonatomic, retain) NSString* intranetIp;   //内网ip
@property (nonatomic, retain) NSString* jidAddr;     //电视盒子标识
@property (nonatomic, retain) NSString* jId;          //电视盒子的xmpp通信id
@property (nonatomic, retain) NSString* tvName;       //电视名字
@property (nonatomic, retain) NSString* state;        //“在一起”状态

@end
