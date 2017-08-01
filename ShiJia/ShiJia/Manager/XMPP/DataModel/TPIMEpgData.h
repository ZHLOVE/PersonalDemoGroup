//
//  TPIMEPGData.h
//  HiTV
//
//  Created by yy on 15/12/2.
//  Copyright © 2015年 Lanbo Zhang. All rights reserved.
//

/**
 *  聊天室epg数据
 */

#import <Foundation/Foundation.h>
@class HiTVVideo;
@class VideoSource;

/*
 
 {"mActorList":["徐峥","莫文蔚","胡静"],
 "mClassList":["悬疑","剧情"],
 "mDirectorList":["陈正道"],
 "mId":"979559",
 "mInformation":"知名心理治疗师徐瑞宁正值事业风生水起之时，遭遇棘手的女病人任小妍。这起医生和病人的较量并没有想象中那么简单，看似弱不禁风的任小妍处处与他针锋相对。徐瑞宁最终揭开任小妍的真实身份，自己也因爱而得到救赎。",
  "mLength":"110分钟",
 "mMovieName":"催眠大师（蓝光）",
 "mPlayerList":[  
                  {
                     "mAction":"OpenMedia",
                     "mUrl":"http://m.icntvcdn.com/media/new/2013/icntv2/media/2014/08/14/48215dc6d54c40f2a01be00f1edec0f6.ts",
                     "mId":"9922713",
                     "mName":"[HD]01_催眠大师（蓝光）",
                     "mFileSize":1353876548
                  },
 
                  {
                     "mAction":"OpenMedia",
                     "mUrl":"http://m.icntvcdn.com/media/new/2013/icntv2/media/2014/08/14/b04c6b2ab42b43cf83577ef01464477d.ts",
                     "mId":"9922716",
                     "mName":"[HD]02_催眠大师（蓝光）",
                     "mFileSize":1675778232
                  }
              ],
 "mZoneList":["中国大陆"],
 "mRelationlist":"http://epg.is.ysten.com:8080/yst-epg/web/program!getRelationProgramseries.action?directorsu003d%E9%99%88%E6%AD%A3%E9%81%93u0026actorsu003d%E5%BE%90%E5%B3%A5%7C%E8%8E%AB%E6%96%87%E8%94%9A%7C%E8%83%A1%E9%9D%99u0026programSeriesIdu003d979559u0026templateIdu003d4",
 "mReleaseDate":"2014",
 "mThumPath":"http://images.is.ysten.com:8080/images/ysten/images/icntv2/images/2014/04/29/f38cab8070f04319a667fe536290e92c_m.jpg",
 "mType":"电影",
 "mProductPrice":1}
 
 */
@interface TPIMEpgData : NSObject

/**
 *  演员列表
 */
@property (nonatomic, strong) NSArray *mActorList;

/**
 *  影片类型列表
 */
@property (nonatomic, strong) NSArray *mClassList;

/**
 *  导演列表
 */
@property (nonatomic, strong) NSArray *mDirectorList;

/**
 *  片源id
 */
@property (nonatomic, copy)   NSString *mId;

/**
 *  影片信息
 */
@property (nonatomic, copy)   NSString *mInformation;

/**
 *  影片时长
 */
@property (nonatomic, copy)   NSString *mLength;

/**
 *  影片名称
 */
@property (nonatomic, copy)   NSString *mMovieName;

/**
 *  影片节目单数据
 */
@property (nonatomic, strong) NSArray *mPlayerList;

/**
 *  影片地区列表
 */
@property (nonatomic, strong) NSArray *mZoneList;

/**
 *  相关影片列表
 */
@property (nonatomic, copy)   NSString *mRelationlist;

@property (nonatomic, copy)   NSString *mReleaseDate;

/**
 *  影片封面image地址
 */
@property (nonatomic, copy)   NSString *mThumPath;

/**
 *  影片类型
 */
@property (nonatomic, copy)   NSString *mType;

/**
 *  影片价格
 */
@property (nonatomic, copy)   NSString *mProductPrice;


/**
 *  初始化方法
 *
 *  @param video 将HiTVVideo转换成TPIMEpgData格式
 *
 *  @return 返回TPIMEpgData
 */
- (instancetype)initWithHiTVVideo:(HiTVVideo *)video;

/**
 *  将TPIMEpgData转换成VideoSource类型
 *
 *  @return 返回转换后的数据
 */
- (VideoSource *)convertToVideoSource;

/**
 *  将TPIMEpgData转换成HiTVVideo类型
 *
 *  @return 返回转换后的HiTVVideo
 */
- (HiTVVideo *)convertToHiTVVideo;


@end
