//
//  ProductEntity.m
//  ShiJia
//
//  Created by 蒋海量 on 16/9/6.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "ProductEntity.h"

@implementation ProductEntity
- (instancetype)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        self.productId = dict[@"productId"];
        self.serviceId = dict[@"serviceId"];
        self.ottProductId = dict[@"ottProductId"];
        self.productType = dict[@"productType"];
        self.businessType = dict[@"businessType"];
        self.renewStatus = dict[@"renewStatus"];
        self.refundStatus = dict[@"refundStatus"];
        self.price = dict[@"price"];
        self.payPrice = dict[@"payPrice"];
        self.name = dict[@"name"];
        self.ppCycleUnit = dict[@"ppCycleUnit"];
        self.ppCycleNu = dict[@"ppCycleNum"];
        self.imgAddr = dict[@"imgAddr"];
        self.expireDateDesc = dict[@"expireDateDesc"];
        self.startTime = dict[@"startTime"];
        self.reserve = dict[@"reserve"];
        self.payType = dict[@"payType"];
        self.endTime = dict[@"endTime"];

        NSDictionary *eticket = dict[@"eticket"];
        if (![eticket isKindOfClass:[NSNull class]]) {
            self.ticketPrice = eticket[@"price"];
            self.ticketName = eticket[@"ticketName"];
            self.ticketNo = eticket[@"ticketNo"];
        }

        self.isCmsProduct = dict[@"isCmsProduct"];
        self.cpCode = dict[@"cpCode"];
        self.cpName = dict[@"cpName"];
        self.cpImageAdd = dict[@"cpImageAdd"];

    }
    return self;
}
-(void)setPrice:(NSString *)price{
    if ([price containsString:@"."]) {
        _price = price;
    }
    else{
        double pricee = price.doubleValue/100;
        _price = [NSString stringWithFormat:@"%.2f",pricee];
    }
}

-(void)setPayPrice:(NSString *)payPrice{
    if ([payPrice containsString:@"."]) {
        _payPrice = payPrice;
    }
    else{
        double price = payPrice.doubleValue/100;
        _payPrice = [NSString stringWithFormat:@"%.2f",price];
    }
}

-(void)setTicketPrice:(NSString *)ticketPrice{
    if ([ticketPrice containsString:@"."]) {
        _ticketPrice = ticketPrice;
    }
    else{
        double price = ticketPrice.doubleValue/100;
        _ticketPrice = [NSString stringWithFormat:@"%.2f",price];
    }
}

-(void)setEndTime:(NSString *)endTime{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
    
    NSDateComponents *dateComponentsForDate = [[NSDateComponents alloc] init];
    if ([self.ppCycleUnit isEqualToString:@"DAY"]) {
        [dateComponentsForDate setDay:self.ppCycleNu.intValue];
    }
    else if ([self.ppCycleUnit isEqualToString:@"MONTH"]) {
        [dateComponentsForDate setMonth:self.ppCycleNu.intValue];
    }
    else if ([self.ppCycleUnit isEqualToString:@"HOUR"]) {
        [dateComponentsForDate setHour:self.ppCycleNu.intValue];
    }
    else if ([self.ppCycleUnit isEqualToString:@"QUARTER"]) {
        [dateComponentsForDate setQuarter:self.ppCycleNu.intValue];
    }
    else if ([self.ppCycleUnit isEqualToString:@"HALFYEAR"]) {
        [dateComponentsForDate setMonth:self.ppCycleNu.intValue*6];
    }
    else{
        [dateComponentsForDate setYear:self.ppCycleNu.intValue];
    }
    
    NSDate * currentDate = [NSDate date];

    if (([self.businessType isEqualToString:@"MEMBER"])&&[HiTVGlobals sharedInstance].VIP) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd"];
        currentDate = [dateFormatter dateFromString:[HiTVGlobals sharedInstance].expireDate];
    }

    NSDate *dateFromDateComponentsAsTimeQantum = [calendar dateByAddingComponents:dateComponentsForDate toDate:currentDate options:0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *destDateString = [dateFormatter stringFromDate:dateFromDateComponentsAsTimeQantum];

    _endTime = destDateString;
}
- (NSString*) endTime:(NSString *)str{
    return str;
#if 0
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:str];

    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *destDateString = [dateFormatter stringFromDate:destDate];
    return destDateString;
#endif
}
-(void)setImgAddr:(NSString *)imgAddr{
    NSDictionary *imgDic = [imgAddr mj_JSONObject];
    _imgAddr = imgDic[@"tvProductImg"];
}
@end
