//
//  SJPurchaseModel.m
//  ShiJia
//
//  Created by 峰 on 16/9/7.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJPurchaseModel.h"

@implementation SJPurchaseModel

@end

@implementation SJJudegVIPModel

@end

@implementation VIPResponModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"descriptionString" : @"description",
             };
}
@end

@implementation SJGetVIPModel

@end

@implementation SJVIPPackageModel
//-(void)setPhoneMemberRight:(NSString *)phoneMemberRight{
//    NSDictionary *imgDic = [self.imgAddr mj_JSONObject];
//    _phoneMemberRight = imgDic[@"phoneMemberRight"];
//}

-(NSString *)phoneMemberRight{
    NSDictionary *imgDic = [self.imgAddr mj_JSONObject];
    return imgDic[@"phoneMemberRight"];
}

@end

@implementation SJTicketsModel
-(void)setExpireDate:(NSString *)expireDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyyMMdd"];
    NSDate *destDate= [dateFormatter dateFromString:expireDate];
    
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *destDateString = [dateFormatter stringFromDate:destDate];
    _expireDate = destDateString;
}
@end

@implementation SJGetTicketsModel


@end

@implementation APPStoreVerModel

@end

@implementation ServerVerModel

@end