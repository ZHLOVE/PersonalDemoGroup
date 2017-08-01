//
//  OrderEntity.h
//  ShiJia
//
//  Created by 蒋海量 on 16/9/6.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderEntity : NSObject
@property (nonatomic, copy) NSString* sequenceId; //订单号
@property (nonatomic, copy) NSString* custId; //用户主账号
@property (nonatomic, copy) NSString* userId; //用户子账号
@property (nonatomic, copy) NSString* productId; //产品编号
@property (nonatomic, copy) NSString* productName; //产品名称
@property (nonatomic, copy) NSString* productType; //产品类型
@property (nonatomic, copy) NSString* businessType; //业务类型
@property (nonatomic, copy) NSString* state; //订单状态
@property (nonatomic, copy) NSString* renewStatus; //续订状态
@property (nonatomic, copy) NSString* refundStatus; //退订状态
@property (nonatomic, copy) NSString* price; //产品价格(单位：分)
@property (nonatomic, copy) NSString* payPrice; //实际支付价格(单位：分)
@property (nonatomic, copy) NSString* orderTime; //订购时间(格式：yyyyMMddHHmmss)
@property (nonatomic, copy) NSString* endTime; //订购失效时间(格式：yyyyMMddHHmmss)
@property (nonatomic, copy) NSString* contentId; //片源Id，单片包时必传
@property (nonatomic, copy) NSString* contentName; //片源名称，单片包时必传
@property (nonatomic, copy) NSString* payType; //支付方式
@property (nonatomic, copy) NSString* payCode; //支付号
@property (nonatomic, copy) NSString* vendorName; //产商名称
@property (nonatomic, copy) NSString* imgAddr; //产品包图片地址
@property (nonatomic, copy) NSString* expireNum; //有效时间
@property (nonatomic, copy) NSString* serviceId;  //服务编号
@property (nonatomic, copy) NSString* isExpire;  //是否到期
@property (nonatomic, copy) NSString* merchantCode;  //商家标示

@property (nonatomic, copy) NSString* isCmsProduct;  //
@property (nonatomic, copy) NSString* cpCode; //CP编码
@property (nonatomic, copy) NSString* cpName; //CP名称
@property (nonatomic, copy) NSString* cpImageAdd; //CP海报图片地址

- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end
