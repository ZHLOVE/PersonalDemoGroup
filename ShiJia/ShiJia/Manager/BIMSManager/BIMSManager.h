//
//  BIMSManager.h
//  HiTV
//
//  Created by 蒋海量 on 15/2/28.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^BIMSManagerIsLoginBlock)();

@interface BIMSManager : NSObject
@property (nonatomic, strong) BIMSManagerIsLoginBlock IsLoginBlock;
@property (nonatomic, strong) NSTimer *verTimer;
@property (nonatomic, strong) NSMutableArray *addressBookArray;

+ (instancetype)sharedInstance;
/**
 *  向BIMS注册手机信息
 */
-(void)registeredMobileInformation;
/**
 *  手机开机引导
 */
-(void)boot;

/**
 *  匿名用户登录(手机)
 */
-(void)anonymousUserLogin_Mobile;


/**
 *  上传手机通讯录
 */
-(void)uploadLocalAddrBook;

/**
 *  获取用户信息
 */
-(void)getUserInfo;
/**
 *  修改用户信息是否公开观看收藏记录
 */
-(void)publicRecord:(NSString *)userAuth;
/**
 *  获取imei
 */
-(NSString*)imei;
/**
 *  会员鉴权
 */
-(void)queryPriceRequest;

/**
 *  更新用户信息
 */
-(void)updateUserInfo;

//检测版本
-(void)apkUpdateRequest;
/**
 *  获取用户jid信息(手机)
 */
-(void)getJidRequest;

//提交点亮页
- (void)submitUserInterestedClass;
@end
