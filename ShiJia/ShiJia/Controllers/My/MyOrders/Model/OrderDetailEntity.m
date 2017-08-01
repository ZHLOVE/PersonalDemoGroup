//
//  OrderDetailEntity.m
//  ShiJia
//
//  Created by 蒋海量 on 16/9/7.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "OrderDetailEntity.h"

@implementation OrderDetailEntity
- (instancetype)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        self.descriptionn = dict[@"description"];
        self.productId = dict[@"productId"];
        self.productName = dict[@"productName"];
        self.contentId = dict[@"contentId"];
        self.contentName = dict[@"contentName"];
        self.price = dict[@"price"];
        self.payPrice = dict[@"payPrice"];
        self.imgAddr = dict[@"imgAddr"];
        self.startTime = [self endTime:dict[@"startTime"]];
        self.endTime = [self endTime:dict[@"endTime"]];
        self.isExpire = dict[@"isExpire"];
        self.expireNum = dict[@"expireNum"];
        self.serviceId = dict[@"serviceId"];
        self.payType = dict[@"payType"];
        //self.orderPayType = dict[@"orderPayType"];
//Add by Allen 新接口 增加 3 个参数
        self.custId = dict[@"custId"];
        self.userSource = dict[@"userSource"];
        self.source = dict[@"source"];
        self.state = dict[@"state"];

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
