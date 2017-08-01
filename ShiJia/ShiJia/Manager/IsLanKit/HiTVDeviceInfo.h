//
//  HiTVDeviceInfo.h
//  HiTV
//
//  Created by lanbo zhang on 1/14/15.
//  Copyright (c) 2015 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HiTVDeviceInfo : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* ip;
@property (nonatomic, copy) NSString* host;
@property (nonatomic) BOOL passwordFlag;
@property (nonatomic, copy) NSString* deviceID;


@property (nonatomic, copy) NSString* userId;
@property (nonatomic, copy) NSString* nickName;
@property (nonatomic, copy) NSString* jId;
@property (nonatomic, copy) NSString* jIdAddr;
@property (nonatomic, copy) NSString* serviceAddr;
@property (nonatomic, copy) NSString* tvName;
@property (nonatomic, copy) NSString* faceImg;
@property (nonatomic, copy) NSString* state;
@property (nonatomic, copy) NSString* relationType;
@property (nonatomic, copy) NSString* tvUid;
@property (nonatomic, copy) NSString* ownerUid; //TV主人的uid＋jid作为唯一标示
@property (nonatomic, copy) NSString* ownerUserId; //TV主人的uid

@property (nonatomic) BOOL IsConnected;

//疑似在一起的tv
@property (nonatomic, copy) NSString* insideIp;
@property (nonatomic, copy) NSString* outsideOutIp;
//add by Allen YES：别人家的设备 NO：我们自己设备
@property (nonatomic, assign) BOOL NotOurSelfTV;

@end
