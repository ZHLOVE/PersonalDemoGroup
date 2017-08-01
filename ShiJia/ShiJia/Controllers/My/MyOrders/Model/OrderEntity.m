//
//  OrderEntity.m
//  ShiJia
//
//  Created by 蒋海量 on 16/9/6.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "OrderEntity.h"

@implementation OrderEntity
- (instancetype)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        self.sequenceId = isNullString(dict[@"sequenceId"]);
        self.custId = isNullString(dict[@"custId"]);
        self.userId = isNullString(dict[@"userId"]);
        self.productId = isNullString(dict[@"productId"]);
        self.productName = isNullString(dict[@"productName"]);
        self.productType = isNullString(dict[@"productType"]);
        self.businessType = isNullString(dict[@"businessType"]);
        self.state = isNullString(dict[@"state"]);
        self.renewStatus = isNullString(dict[@"renewStatus"]);
        self.refundStatus = isNullString(dict[@"refundStatus"]);
        self.price = isNullString(dict[@"price"]);
        self.payPrice = isNullString(dict[@"payPrice"]);
        self.orderTime = isNullString(dict[@"orderTime"]);
        self.endTime = [self endTime:isNullString(dict[@"endTime"])];
        self.contentId = isNullString(dict[@"contentId"]);
        self.contentName = isNullString(dict[@"contentName"]);
        self.payType = isNullString(dict[@"payType"]);
        self.payCode = isNullString(dict[@"payCode"]);
        self.vendorName = isNullString(dict[@"vendorName"]);
        self.expireNum = isNullString(dict[@"expireNum"]);
        self.serviceId = isNullString(dict[@"serviceId"]);
        self.imgAddr = isNullString(dict[@"imgAddr"]);
        self.isExpire = isNullString(dict[@"isExpire"]);
        
        self.isCmsProduct = isNullString(dict[@"isCmsProduct"]);
        self.cpCode = isNullString(dict[@"cpCode"]);
        self.cpName = isNullString(dict[@"cpName"]);
        self.cpImageAdd = isNullString(dict[@"cpImageAdd"]);

    }
    return self;
}
-(void)setPrice:(NSString *)price{
    double pricee = price.doubleValue/100;
    _price = [NSString stringWithFormat:@"%.2f",pricee];
}

-(void)setPayPrice:(NSString *)payPrice{
    double price = payPrice.doubleValue/100;
    _payPrice = [NSString stringWithFormat:@"%.2f",price];
}

- (NSString*) endTime:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyyMMddHHmmss"];
    NSDate *destDate= [dateFormatter dateFromString:str];
    
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *destDateString = [dateFormatter stringFromDate:destDate];
    return destDateString;
}
-(void)setImgAddr:(NSString *)imgAddr{
    NSDictionary *imgDic = [imgAddr mj_JSONObject];
    _imgAddr = imgDic[@"tvProductImg"];
}
@end
