//
//  ProductEntity.h
//  ShiJia
//
//  Created by 蒋海量 on 16/9/6.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductEntity : NSObject
@property (nonatomic, copy) NSString* productId; //产品编号

@property (nonatomic, copy) NSString* serviceId;  //服务编号

@property (nonatomic, copy) NSString* ottProductId;//运营商产品编码

@property (nonatomic, copy) NSString* productType; //产品类型

@property (nonatomic, copy) NSString* businessType; //业务类型

@property (nonatomic, copy) NSString* renewStatus; //续订状态

@property (nonatomic, copy) NSString* refundStatus; //退订状态

@property (nonatomic, copy) NSString* price;  //产品价格

@property (nonatomic, copy) NSString* payPrice;  //实际支付价格

@property (nonatomic, copy) NSString* name;  //产品名称

@property (nonatomic, copy) NSString* ppCycleUnit;  //产品周期

@property (nonatomic, copy) NSString* ppCycleNu;  //产品周期数量

@property (nonatomic, copy) NSString* imgAddr;  //产品包图片地址

@property (nonatomic, copy) NSString* expireDateDesc;  //到期日期描述

@property (nonatomic, copy) NSString* startTime;  //产品有效开始时间

@property (nonatomic, copy) NSString* endTime;  //产品有效结束时间

@property (nonatomic, copy) NSString* introduce;  //产品介绍

@property (nonatomic, copy) NSString* reserve;  //保留字段

@property (nonatomic, copy) NSString* payType;  //支付类型，以竖线分隔

@property (nonatomic, copy) NSString* contentId; //产品内容编号

@property (nonatomic, copy) NSString* eticket; //优惠券json
@property (nonatomic, copy) NSString* ticketPrice; //优惠券价格
@property (nonatomic, copy) NSString* ticketName; //优惠券名称
@property (nonatomic, copy) NSString* ticketNo; //优惠券编号

@property (nonatomic, copy) NSString* isCmsProduct; //是否是未来电视产品包:是：YES 否：NO
@property (nonatomic, copy) NSString* cpCode; //CP编码
@property (nonatomic, copy) NSString* cpName; //CP名称
@property (nonatomic, copy) NSString* cpImageAdd; //CP海报图片地址



- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end
