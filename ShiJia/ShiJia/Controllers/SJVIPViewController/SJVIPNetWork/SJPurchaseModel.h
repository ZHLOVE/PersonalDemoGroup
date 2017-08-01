//
//  SJPurchaseModel.h
//  ShiJia
//
//  Created by 峰 on 16/9/7.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJPurchaseModel : NSObject

@end
/*
token String 否
uid String 是
*/
/**
 *  VIP 鉴权 请求model
 */
@interface SJJudegVIPModel : NSObject

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *uid;

@end
/*
 result String 是 ORD-000成功，其他失败
 description String 否 描述信息
 imageUrl String 是 成功时返回该用户持有的权益图片地址 失败时返回会员权限图片地址
 */
/**
 *  VIP 返回Model
 */
@interface VIPResponModel : NSObject

@property (nonatomic, strong) NSString *result;
@property (nonatomic, strong) NSString *descriptionString;
@property (nonatomic, strong) NSString *imageUrl;

@end

/**
 *  VIP 可用套餐 查询
 */
// source PHONE
@interface SJGetVIPModel : NSObject

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *source;

@end
/*
 productId String 是 产品编号
 productName String 是 产品名称
 serviceid    
 price 字符串 是 产品价格
 payPrice 字符串 是 实际支付价格
 imgAddr 字符串 是 图片地址 {"tvMemberRight":"http:xxxxx", "tvDeclare":"http:xxxx", "tvProductImg":"http:xxxx"}
 expireDateDesc 字符串 是 到期日期描述
 startTime 字符串 是 产品有效开始时间
 endTime 字符串 是 产品有效结束时间
 introduce 字符串 是 产品介绍
 reserve 字符串 否 保留字段
 payType 字符串 是
 支付类型，以竖线分隔
 PHONE--手机支付
 POINT--积分支付
 ETICKET—电子券
 BROADBAND—宽带支付
 WEIXIN—微信支付
 ALIPAY—支付宝支付
 APPSTORE—IOS支付(需特殊处理)
 */
@interface SJVIPPackageModel : NSObject
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *serviceId;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *payPrice;
@property (nonatomic, strong) NSString *expireDateDesc;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *introduce;
@property (nonatomic, strong) NSString *imgAddr;
@property (nonatomic, strong) NSString *ppCycleNum;
@property (nonatomic, strong) NSString *ppCycleUnit;
@property (nonatomic, strong) NSString *phoneMemberRight;

@end

/**
 *  获取观影券
 */
@interface SJGetTicketsModel : NSObject
@property (nonatomic, strong) NSString *uid;
//GAME 游戏 VIDEO 视频 CHANNEL 频道SPEED 提速MUSIC 音乐MEMBER 会员
@property (nonatomic, strong) NSString *businessType;
@property (nonatomic, strong) NSString *token;
//USED 已使用 UNUSE 未使用 INVALID 作废
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *pageNo;
@property (nonatomic, strong) NSString *pageSize;
@property (nonatomic, strong) NSString *source;

@end
/*ticketNo String M 观影券号
ticketName String M 观影券名称
businessType String M 业务类型
GAME 游戏
VIDEO 视频
CHANNEL 频道
SPEED 提速
MUSIC 音乐
MEMBER 会员
price String M 观影券价格，单位分
expireDate String M 到期时间，格式：yyyyMMdd
isExpire String M 是否到期 YES NO
state String M 状态： USED 已使用 UNUSE 未使用
action 跳转类型
actionUrl 跳转地址
*/
@interface SJTicketsModel : NSObject
@property (nonatomic, strong) NSString *ticketNo;
@property (nonatomic, strong) NSString *ticketName;
@property (nonatomic, strong) NSString *businessType;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *expireDate;
@property (nonatomic, strong) NSString *isExpire;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *actionUrl;
@property (nonatomic, strong) NSString *action;

@end

@interface APPStoreVerModel : NSObject
@property (nonatomic, strong) NSString *receipt;
@property (nonatomic, strong) NSString *sequenceId;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *uid;

@end

@interface ServerVerModel : NSObject

@property (nonatomic, strong) NSString *result;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *receipt;

@end


