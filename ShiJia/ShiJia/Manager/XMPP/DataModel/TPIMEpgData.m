//
//  TPIMEPGData.m
//  HiTV
//
//  Created by yy on 15/12/2.
//  Copyright © 2015年 Lanbo Zhang. All rights reserved.
//

#import "TPIMEpgData.h"
#import "TPIMSourceItem.h"
#import "HiTVVideo.h"
#import "VideoSource.h"

@implementation TPIMEpgData
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


/*
{"mDirectorList":["陈正道"],
 "mRelationlist":"http://epg.is.ysten.com:8080/yst-epg/web/program!getRelationProgramseries.action?directors=%E9%99%88%E6%AD%A3%E9%81%93&actors=%E5%BE%90%E5%B3%A5%7C%E8%8E%AB%E6%96%87%E8%94%9A%7C%E8%83%A1%E9%9D%99&programSeriesId=977858&templateId=4",
 "mType":"电影",
 "mInformation":"知名心理治疗师徐瑞宁正值事业风生水起之时，遭遇棘手的女病人任小妍。这起医生和病人的较量并没有想象中那么简单，看似弱不禁风的任小妍处处与他针锋相对。徐瑞宁最终揭开任小妍的真实身份，自己也因爱而得到救赎。",
 "mClassList":["悬疑","剧情"],
 "mMovieName":"催眠大师",
 "mActorList":["徐峥","莫文蔚","胡静"],
 "mId":"977858",
 "mLength":"100",
 "mZoneList":["中国大陆"],
 "mThumPath":"http://images.is.ysten.com:8080/poster/2014-08-01/f64c8cc3532d45449bc300238a006471.jpg"
 }
 
 */

#pragma mark - init
- (instancetype)initWithHiTVVideo:(HiTVVideo *)video
{
    self = [super init];
    if (self) {
        if (video.actor.length != 0) {
            NSArray *actors = [video.actor componentsSeparatedByString:@"|"];
            self.mActorList = [NSArray arrayWithArray:actors];
        }
        if (video.programClass.length != 0) {
            NSArray *class = [video.programClass componentsSeparatedByString:@"|"];
            self.mClassList = [NSArray arrayWithArray:class];
        }
        if (video.director.length != 0) {
            NSArray *directors = [video.director componentsSeparatedByString:@"|"];
            self.mDirectorList = [NSArray arrayWithArray:directors];
        }
        self.mId = video.videoID;
        self.mInformation = video.information;
        self.mLength = video.length;
        self.mMovieName = video.name;
        if (video.zone.length != 0) {
            NSArray *zone = [video.zone componentsSeparatedByString:@"|"];
            self.mZoneList = [NSArray arrayWithArray:zone];
        }
        self.mRelationlist = video.relationlist;
        self.mThumPath = video.picurl;
        self.mType = video.type;
        
        NSMutableArray *sources = [[NSMutableArray alloc] init];
        for (VideoSource *data in video.sources) {
            TPIMSourceItem *source = [[TPIMSourceItem alloc] initWithVideoSource:data];
            [sources addObject:source];
        }
        self.mPlayerList = [NSArray arrayWithArray:sources];
    }
    return self;
}

#pragma mark - convert data
- (VideoSource *)convertToVideoSource
{
    return nil;
}

- (HiTVVideo *)convertToHiTVVideo
{
    HiTVVideo *video = [[HiTVVideo alloc] init];
    
    if (self.mActorList.count > 0 ) {
        video.actor = [self.mActorList componentsJoinedByString:@"|"];
    }
    if (self.mClassList.count > 0) {
        video.programClass = [self.mClassList componentsJoinedByString:@"|"];
    }
    if (self.mDirectorList.count > 0) {
        video.director = [self.mDirectorList componentsJoinedByString:@"|"];
    }
    
    video.videoID = self.mId;
    video.information = self.mInformation;
    video.length = self.mLength;
    video.name = self.mMovieName;
   
    if (self.mZoneList.count > 0) {
        video.zone = [self.mZoneList componentsJoinedByString:@"|"];
    }
    
    video.relationlist = self.mRelationlist;
    video.picurl = self.mThumPath;
    video.type = self.mType;
    
    NSMutableArray *sources = [[NSMutableArray alloc] init];
    for (id data in self.mPlayerList) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)data;
            TPIMSourceItem *item = [TPIMSourceItem mj_objectWithKeyValues:dic];
            VideoSource *source = [item convertToVideoSource];
            [sources addObject:source];
        }
        else if ([data isKindOfClass:[TPIMSourceItem class]]){
            TPIMSourceItem *sourceItem = (TPIMSourceItem *)data;
            VideoSource *source = [sourceItem convertToVideoSource];
            [sources addObject:source];
        }
        
    }
    video.sources = [NSArray arrayWithArray:sources];
    
    return video;
}

@end
