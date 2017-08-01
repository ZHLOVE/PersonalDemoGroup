//
//  OrderDetailEntity.h
//  ShiJia
//
//  Created by 蒋海量 on 16/9/7.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailEntity : NSObject
@property (nonatomic, copy) NSString* sequenceId; //订单号
@property (nonatomic, copy) NSString* descriptionn; //描述信息
@property (nonatomic, copy) NSString* productId; //产品Id
@property (nonatomic, copy) NSString* productName; //产品名称
@property (nonatomic, copy) NSString* contentId; //产品内容Id
@property (nonatomic, copy) NSString* contentName; //产品内容名称
@property (nonatomic, copy) NSString* price; //原价
@property (nonatomic, copy) NSString* payPrice; //实际支付价格
@property (nonatomic, copy) NSString* imgAddr; //产品包图片地址
@property (nonatomic, copy) NSString* startTime; //开始时间，格式：yyyyMMddHHmmss
@property (nonatomic, copy) NSString* endTime; //结束时间，格式：yyyyMMddHHmmss
@property (nonatomic, copy) NSString* isExpire; //是否过期 YES 过期 NO  未过期
@property (nonatomic, copy) NSString* expireNum; //有效时间
@property (nonatomic, copy) NSString* businessType; //
@property (nonatomic, copy) NSString* state; //订单状态
@property (nonatomic, copy) NSString* serviceId;  //服务编号
@property (nonatomic, copy) NSString* payType;  //支付方式
@property (nonatomic, copy) NSString* renewStatus; //续订状态

//@property (nonatomic, copy) NSString* orderPayType;  //支付方式
//Add by Allen 新接口 增加 4 个参数
@property (nonatomic, copy) NSString *custId;
@property (nonatomic, copy) NSString *userSource;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *isH5Pay;

- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end
