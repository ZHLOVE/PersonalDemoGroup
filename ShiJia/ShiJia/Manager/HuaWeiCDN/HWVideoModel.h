//
//  HWVideoModel.h
//  ShiJia
//
//  Created by 蒋海量 on 2017/3/23.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWVideoModel : NSObject
/*
 *内容编号 
 当businessType为1时传影片ID
 当businessType为2时传频道ID 
 当businessType为4时传频道ID
 当businessType为5时传节目单ID 
 当businessType为6时传频道ID
 */
@property (nonatomic, copy) NSString *cid;
/*
 *栏目编号
 */
@property (nonatomic, copy) NSString *tid;
/*
 *父集编号，当是子集时supercid不能为空
 */
@property (nonatomic, copy) NSString *supercid;
/*
 *播放类型
 1:VOD播放
 2:TV播放
 4:TVOD播放
 5:片花播放
 6:书签播放 
 8:直播频道、轮播频道的节目播放
 */
@property (nonatomic, copy) NSString *playType;
/*
 *内容类型
 0:视频VOD
 1:视频频道
 2:音频频道
 3:频道
 4:音频VOD
 10:VOD
 300:频道节目
 */
@property (nonatomic, copy) NSString *contentType;
/*
 *业务类型
 1:VOD
 2:LIVETV
 4:PLTV
 5:TVOD
 6: LIVETV&PLTV
 */
@property (nonatomic, copy) NSString *businessType;
/*
 *
 ID类型标识，用于只是上述cid、tid的取值是牌照商 的CODE还是OTT平台的内部ID(当前OTT牌照方使 用自己的CODE时，请务必填写为1):
 0: 内部ID标记
 1: 外部牌照商CODE
 */
@property (nonatomic, copy) NSString *idflag;
/*
 *post: header
 */
@property (nonatomic, copy) NSString *Authorization;

@end
