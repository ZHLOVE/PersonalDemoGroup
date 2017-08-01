//
//  TogetherManager.h
//  HiTV
//
//  Created by 蒋海量 on 15/7/30.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HiTVDeviceInfo.h"
#import "RoomNumEntity.h"

@interface TogetherManager : NSObject
typedef void (^TogetherManagerDeviceDetectedBlock)();
typedef void (^ScreenManagerResetBlock)();

+ (instancetype)sharedInstance;
@property (nonatomic, strong) TogetherManagerDeviceDetectedBlock deviceDetectedBlock;

@property (nonatomic, readonly) NSArray* detectedDevices;

@property (nonatomic, strong) HiTVDeviceInfo* connectedDevice;

@property (nonatomic, readonly, getter=isConnected )BOOL connected;

@property (nonatomic, assign) NSString* barrageSwitch;
@property (nonatomic, assign) NSString* reportType;

@property (nonatomic, strong) NSArray* distrustTvs;


/*
 *开机启动多屏
 */
-(void)start;
/*
 *掉线重连
 */
-(void)reconnect;
/**
 *  关联请求
 *
 *  @param infoDic
 */
-(void)uploadDeviceRelationRequest:(NSDictionary *)infoDic;

/**
 *  获取关联列表
 *  @param handler 处理回调
 */
-(void)getDeviceDetectionRequestForCompletion:(void(^)(NSArray *devices,NSString *error))handler;

/**
 *  解除关联关系
 *  @param uid 盒子uid
 *  @param handler 处理回调
 */
-(void)removeDeviceDetectionRequest:(NSString *)uid completion:(void(^)(id responseObject,NSString *error))handler;

/**
 *  手机确认内网电视上报多屏接口
 *  @param tvUids 盒子uid(数组)
 *  @param identityNet 同网（sameNet）或异网（notSameNet）
 *  @param handler 处理回调
 */
-(void)confirmTvNetTVS:(NSArray *)tvUids identityNet:(NSString *)identityNet completion:(void(^)(id responseObject,NSString *error))handler;

/**
 *  用户频道群聊房间在线人数
 *  @param roomId 群聊房间号
 *  @param handler 处理回调
 */
-(void)getRoomNums:(NSString *)roomId completion:(void(^)(RoomNumEntity *roomEntity,NSString *error))handler;

/**
 *  获取疑似列表
 */
-(void)getDistrustTvsMethod;
/**
 *  设置遥控器状态
 */
-(void)setRemoteStatus;
/**
 *  组播回调处理
 */
-(void) actionOfCallback:(NSData*) data;
@end

