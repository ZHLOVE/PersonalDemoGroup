//
//  TPIMContentModel.m
//  HiTV
//
//  Created by yy on 15/8/14.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "TPIMContentModel.h"
#import "NSObject+MJKeyValue.h"


/**
 *  播放器视频类型
 */
NSString * const VideoTypeLookback = @"lookback";//手机回看
NSString * const VideoTypeNative = @"native";//本地视频
NSString * const VideoTypeNetwork = @"network";//点播
NSString * const VideoTypeKanDianDianBo = @"kandian_dianbo";//看点-点播
NSString * const VideoTypeKanDianZuiXin = @"kandian_zuixin";//看点-最新
NSString * const VideoTypeChannelZuiXin = @"channel_zuixin";//频道直播

@implementation TPIMContentModel

#pragma mark - MJExtension
+ (NSDictionary *)objectClassInArray
{
    //stype liveTag time resultCode
    return nil;
}

+ (NSArray *)mj_ignoredPropertyNames
{
    
    return @[@"epgDataModel",@"showToast"];
}

- (void)setEpgDataModel:(TPIMEpgData *)epgDataModel
{

}

@end
