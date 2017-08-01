//
//  SJLiveTVCollcetModel.h
//  ShiJia
//
//  Created by 峰 on 16/7/7.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJLiveTVCollcetModel : NSObject

@property (nonatomic,strong) NSString *uid;       //用户中心id
@property (nonatomic,strong) NSString *oprUids;
@property (nonatomic,strong) NSString *businessType;
@property (nonatomic,strong) NSString *playType;
@property (nonatomic,strong) NSString *objectId;
@property (nonatomic,strong) NSString *objectName;
@property (nonatomic,strong) NSString *startTime;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,strong) NSString *assortId;
@property (nonatomic,strong) NSString *lastProgramId;
@property (nonatomic,strong) NSString *lastProgramName;
@property (nonatomic,strong) NSString *startWatchTime;
@property (nonatomic,strong) NSString *endWatchTime;
@property (nonatomic,strong) NSString *bannerImg;
@property (nonatomic,strong) NSString *verticalImg;
@property (nonatomic,strong) NSString *directors;
@property (nonatomic,strong) NSString *actors;
@property (nonatomic,strong) NSString *deviceGroupId;
@property (nonatomic,strong) NSString *templateId;
//@property (nonatomic,strong) NSString *vendor;
//@property (nonatomic) NSInteger seconds;
//@property (nonatomic) NSInteger seriesNumber;
@property (nonatomic,strong) NSString *deviceType;

@end
/**
 *  请求model 是否收藏过
 */
@interface SJLiveRequestIsCollectModel : NSObject

@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *businessType;
@property (nonatomic,strong) NSString *objectId;
@property (nonatomic,strong) NSString *startTime;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,strong) NSString *deviceType;

@end

/**
 *  取消收藏 参数model
 */
@interface SJCancelCollcetionModel : NSObject

@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *oprUids;
@property (nonatomic,strong) NSString *businessType;
@property (nonatomic,strong) NSString *playType;
@property (nonatomic,strong) NSString *objectId;
@property (nonatomic,strong) NSString *startTime;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,strong) NSString *templateId;
@property (nonatomic,strong) NSString *deviceType;

@end

