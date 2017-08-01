//
//  HiTVGlobals.m
//  HiTV
//
//  Created by 蒋海量 on 15/3/11.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "HiTVGlobals.h"
#import "TPXmppManager.h"
#import "TPXmppRoomManager.h"
#import "TPIMUser.h"

#define kDocumentFolder	[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"]

/*
 正式环境默认域名
 */
static NSString* const bims_cosepg = @"http://cosepg.public.taipan.bcs.ottcn.com:8084/ysten-epg/";
static NSString* const bims_dingxiangIP = @"http://218.205.238.198";
static NSString* const EPG30 = @"http://epg.is.ysten.com:8080/";
static NSString* const EPG20 = @"http://epg.is.ysten.com:8080/";
static NSString* const EPGGroupId = @"51000159";

//看点、频道域名
static NSString* const LiveEPG = @"http://phoneepg.is.ysten.com:8080/";
static NSString* const LiveEPGgroupId = @"88888";

//用户中心电视行为记录
static NSString* const UIC = @"http://jxseen.formal.taipan.ysten.com";
static NSString* const Projection_low_domain = @"http://phone.media.ysten.com/";
static NSString* const ProjectionDomain = @"http://hot.media.ysten.com/";
static NSString* const ProjectionLiveDomain = @"http://tvlookbackpanel.sc.ysten.com:7070/";
static NSString* const Recommend = @"http://images.is.ysten.com:8080/images/ysten/images/phone_application/recommendlist.xml";
static NSString* const Loading = @"http://images.is.ysten.com/images/ysten/images/PANEL_image/icon/mbh/loading.png";
static NSString* const bims_search = @"http://search.is.ysten.com:8080";
static NSString* const bims_mylook = @"http://myepg.formal.taipan.ysten.com:8080/yst-ppl-api/";
static NSString* const live_epg = @"http://looktvepg.jx.ysten.com:8080";
static NSString* const live_templateId = @"88888";
static NSString* const bims_multiscreen = @"http://mc.formal.taipan.ysten.com:8080";
static NSString* const bims_msg = @"http://msg.formal.taipan.ysten.com:8080";
static NSString* const bims_mylookcenter = @"http://117.169.5.39:8081";
static NSString* const bims_mylooknew = @"http://social.formal.taipan.ysten.com";
static NSString* const xmpp_host = @"xmpp.formal.taipan.ysten.com";
static NSString* const xmpp_hostName = @"jx.yst";

static NSString* const bims_cloudserver = @"http://upaiyun.bcs.ottcn.com";

static NSString* const bims_shareserver = @"http://wxh5.ysten.com";
static NSString* const bims_STBext = @"{\"deviceGroupIds\":[\"88889\"],\"userGroupIds\":[],\"districtCode\":\"\",\"abilities\":[\"4K-0\"],\"dType\":\"1\"}";
static NSString* const bims_openflag = @"0";

static NSString* const bims_domain = @"110000_1";
static NSString* const bims_clouduploadUrl = @"http://v0.api.upyun.com";
static NSString* const bims_cloudalbumsUrl = @"http://social.demo.taipan.ysten.com/yst-cas-api/";
static NSString* const bims_ystenapyUrl = @"http://192.168.1.73:38085/yst-pms-api/";
//static NSString* const bims_thumbSuffix = @"!thum";
static NSString* const bims_facade = @"http://192.168.1.73:38088/yst-ord-api/";
static NSString* const bims_bssHost = @"http://bsu.formal.taipan.bcs.ottcn.com:18121/yst-lbss-api/";
static NSString* const bims_dmsHost = @"http://221.131.123.204:8031/mock/ysten-mdms-api/";


/*
 测试环境默认域名
 */
static NSString* const TestEPG30 = @"http://epg.is.ysten.com:8080/";
static NSString* const TestEPG20 = @"http://epg.is.ysten.com:8080/";
static NSString* const TestEPGGroupId = @"4";

//看点、频道域名
static NSString* const TestLiveEPG = @"http://phoneepg.is.ysten.com:8080/";
static NSString* const TestLiveEPGgroupId = @"51000004";

//用户中心电视行为记录
static NSString* const TestUIC = @"http://wxseen.demo.taipan.ysten.com";
static NSString* const TestProjection_low_domain = @"http://phone.media.ysten.com/";
static NSString* const TestProjectionDomain = @"http://hot.media.ysten.com/";
static NSString* const TestProjectionLiveDomain = @"http://tvlookbackpanel.sc.ysten.com:7070/";
static NSString* const TestRecommend = @"http://images.is.ysten.com:8080/images/ysten/images/phone_application/recommendlist.xml";
static NSString* const TestLoading = @"http://images.is.ysten.com/images/ysten/images/PANEL_image/icon/mbh/loading.png";
static NSString* const Testbims_search = @"http://search.is.ysten.com:8080";
static NSString* const Testbims_mylook = @"http://myepg.demo.taipan.ysten.com";
static NSString* const Testlive_epg = @"http://looktvepg.jx.ysten.com:8080";
static NSString* const Testlive_templateId = @"88888";
static NSString* const Testbims_multiscreen = @"http://mc.demo.taipan.ysten.com";
static NSString* const Testbims_msg = @"http://msg.demo.taipan.ysten.com";
static NSString* const Testbims_mylookcenter = @"http://lkp.api.demo.taipan.ysten.com";
static NSString* const Testmylook_new = @"http://social.formal.taipan.ysten.com";
static NSString* const Testxmpp_host = @"223.82.249.149";
static NSString* const Testxmpp_hostName = @"b.yst";


static NSString *isBarrageOnKey = @"isBarrageOnKey";

@implementation HiTVGlobals
+ (instancetype)sharedInstance{
    static HiTVGlobals *sharedObject = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        sharedObject.isBarrageOn = [defaults boolForKey:isBarrageOnKey];
        [sharedObject addObserverBlockForKeyPath:@"uid" block:^(id obj, id oldVal, id newVal){
            DDLogInfo(@"############## uid old val : %@ , new val : %@", oldVal, newVal);
            [mgServer updateSrvInfo:_UsrId :newVal];
            
        }];
        [sharedObject addObserverBlockForKeyPath:@"phoneNo" block:^(id obj, id oldVal, id newVal){
            DDLogInfo(@"############## phoneNo old val : %@ , new val : %@", oldVal, newVal);
            [mgServer updateSrvInfo:_PhoneNum :newVal];
        }];
        [sharedObject addObserverBlockForKeyPath:@"loggerAddr" block:^(id obj, id oldVal, id newVal){
            DDLogInfo(@"##############  loggerAddr old val : %@ , new val : %@", oldVal, newVal);
             [mgServer updateSrvInfo:_UploadAddr :newVal];
        }];
    
    });
    
    return sharedObject;
}

-(NSString *)dingxiangIP{
    if (_dingxiangIP == nil || [_dingxiangIP length] <= 0) {
        return bims_dingxiangIP;
        
    }
    return _dingxiangIP;
}
-(NSString *)domain{
    if (_domain == nil || [_domain length] <= 0) {
        return bims_domain;
        
    }
    return _domain;
}
-(NSString *)clouduploadUrl{
    if (_clouduploadUrl == nil || [_clouduploadUrl length] <= 0) {
        return bims_clouduploadUrl;
        
    }
    return _clouduploadUrl;
}
-(NSString *)cloudalbumsUrl{
    if (_cloudalbumsUrl == nil || [_cloudalbumsUrl length] <= 0) {
        return bims_cloudalbumsUrl;
        
    }
    return _cloudalbumsUrl;
}
-(NSString *)ystenapyUrl{
    if (_ystenapyUrl == nil || [_ystenapyUrl length] <= 0) {
        return bims_ystenapyUrl;
        
    }
    return _ystenapyUrl;
}
//-(NSString *)thumbSuffix{
//    if (_thumbSuffix == nil || [_thumbSuffix length] <= 0) {
//        return bims_thumbSuffix;
//        
//    }
//    return _thumbSuffix;
//}
-(NSString *)facadeUrl{
    //return @"http://112.25.7.58:8116/yst-ord-api/";
    if (_facadeUrl == nil || [_facadeUrl length] <= 0) {
        return bims_facade;
        
    }
    return _facadeUrl;
}
/**
 *  手机EPG3.0入口
 */
-(NSString *)getEpg_30{
    if (_epg_30 == nil || [_epg_30 length] <= 0) {
        if (_formal) {
            return EPG30;
        }
        return TestEPG30;
    }
    else{
        return [NSString stringWithFormat:@"%@/",_epg_30];
    }
}
/**
 *  手机EPG2.0入口
 */
-(NSString *)getEpg_20{
    if (_epg_20 == nil || [_epg_20 length] <= 0) {
        if (_formal) {
            return EPG20;
        }
        return TestEPG20;
    }
    else{
        return [NSString stringWithFormat:@"%@/",_epg_20];
    }
}
/**
 *  EPG分组ID
 */
-(NSString *)getEpg_groupId{
    if (_epg_groupId == nil || [_epg_groupId length] <= 0) {
        if (_formal) {
                return EPGGroupId;
        }
        return TestEPGGroupId;
    }
    else{
        return _epg_groupId;
    }
}
/**
 *  直播epg地址
 */
-(NSString *)live_epg{
    if (_liveepg == nil || [_liveepg length] <= 0) {
        if (_formal) {
            return LiveEPG;
        }
        return TestLiveEPG;
    }
    else{
        return [NSString stringWithFormat:@"%@/",_liveepg];
    }
}
/**
 *  直播epg分组ID
 */
-(NSString *)getLiveepg_groupId{
    if (_liveepg == nil || [_liveepg length] <= 0) {
        if (_formal) {
            return LiveEPGgroupId;
        }
        return TestLiveEPGgroupId;
    }
    else{
        return _liveepg_groupId;
    }
}
/**
 *  UIC入口
 */
-(NSString *)getUic{
   // return @"http://192.168.1.31:8086/box_api/";

    if (_uic == nil || [_uic length] <= 0) {
        if (_formal) {
            return UIC;
        }
        return TestUIC;
    }
    else{
        return _uic;
    }
}
/**
 *  手机播放媒体低码率兑换
 */
-(NSString *)getProjection_low_domain{
    if (_projection_low_domain == nil || [_projection_low_domain length] <= 0) {
        if (_formal) {
            return Projection_low_domain;
        }
        return TestProjection_low_domain;
    }
    else{
        return _projection_low_domain;
    }
}

/**
 *  点播投屏域名入口
 */
-(NSString *)getProjection_domain{
    if (_projection_domain == nil || [_projection_domain length] <= 0) {
        if (_formal) {
            return ProjectionDomain;
        }
        return TestProjectionDomain;
    }
    else{
        return _projection_domain;
    }
}
/**
 *  直播投屏域名入口
 */
-(NSString *)getProjection_live_domain{
    if (_projection_live_domain == nil || [_projection_live_domain length] <= 0) {
        if (_formal) {
            return ProjectionLiveDomain;
        }
        return TestProjectionLiveDomain;
    }
    else{
        return [NSString stringWithFormat:@"%@/",_projection_live_domain];
    }
}
/**
 *  推荐位地址
 */
-(NSString *)getRecommend{
    if (_recommend == nil || [_recommend length] <= 0) {
        if (_formal) {
            return Recommend;
        }
        return TestRecommend;
    }
    else{
        return _recommend;
    }
}

/**
 *  启动画面地址
 */
-(NSString *)getLoading{
    if (_loading == nil || [_loading length] <= 0) {
        if (_formal) {
            return Loading;
        }
        return TestLoading;
    }
    else{
        return _loading;
    }
}
/**
 *  搜索资源
 */
-(NSString *)getBims_search{
    //return @"http://223.82.250.120:8080";
    if (_bims_search == nil || [_bims_search length] <= 0) {
        if (_formal) {
            return bims_search;
        }
        return Testbims_search;
    }
    else{
        return _bims_search;
    }
}
/**
 *  看单EPG
 */
-(NSString *)getBims_mylook{
    if (_bims_mylook == nil || [_bims_mylook length] <= 0) {
        if (_formal) {
            return bims_mylook;
        }
        return Testbims_mylook;
    }
    else{
        return _bims_mylook;
    }
}
/**
 *  看点EPG
 */
-(NSString *)getLive_epg{
    if (_live_epg == nil || [_live_epg length] <= 0) {
        if (_formal) {
            return live_epg;
        }
        return Testlive_epg;
    }
    else{
        return _live_epg;
    }
}
/**
 *  看点分组
 */
-(NSString *)getLive_templateId{
    //return live_templateId;
    if (_live_templateId == nil || [_live_templateId length] <= 0) {
        if (_formal) {
            return live_templateId;
        }
        return Testlive_templateId;
    }
    else{
        return _live_templateId;
    }
}
/**
 *  多屏入口
 */
-(NSString *)getBims_multiscreen{
    if (_bims_multiscreen == nil || [_bims_multiscreen length] <= 0) {
        if (_formal) {
            return bims_multiscreen;
        }
        return Testbims_multiscreen;
    }
    else{
        return _bims_multiscreen;
    }
}
/**
 *  消息中心入口
 */
-(NSString *)getBims_msg{
    if (_bims_msg == nil || [_bims_msg length] <= 0) {
        if (_formal) {
            return bims_msg;
        }
        return Testbims_msg;
    }
    else{
        return _bims_msg;
    }
}
/**
 *  看单中心入口
 */
-(NSString *)getBims_mylookcenter{
    if (_bims_mylookcenter == nil || [_bims_mylookcenter length] <= 0) {
        if (_formal) {
            return bims_mylookcenter;
        }
        return Testbims_mylookcenter;
    }
    else{
        return _bims_mylookcenter;
    }
}
/**
 *  XMPP_Host
 */
-(NSString *)getxmpp_host{
    if (_xmpp_host == nil || [_xmpp_host length] <= 0) {
        if (_formal) {
            return xmpp_host;
        }
        else{
            return Testxmpp_host;
        }
    }
    return _xmpp_host;
}
/**
 *  XMPP_HostName
 */
-(NSString *)getxmpp_hostName{
    if (_xmpp_hostName == nil || [_xmpp_hostName length] <= 0) {
        if (_formal) {
            return xmpp_hostName;
        }
        return Testxmpp_hostName;
    }
    else{
        return _xmpp_hostName;
    }
}
/**
 *  社交系统
 */
-(NSString *)getsocial_host{
    if (_social_host == nil || [_social_host length] <= 0) {
        if (_formal) {
            return bims_mylooknew;

        }
        else{
            return Testmylook_new;
        }
    }
    return _social_host;
}

-(NSString *)cloud_server{
    if (_cloud_server == nil || [_cloud_server length] <= 0) {
        NSString *cloudUrl = [NSUserDefaultsManager getObjectForKey:CLOUDSERVER];
        if (cloudUrl == nil || [cloudUrl length] <= 0){
            return bims_cloudserver;
        }
        return cloudUrl;

    }
    return _cloud_server;
}
-(NSString *)share_server{
    if (_share_server == nil || [_share_server length] <= 0) {
        return bims_shareserver;
        
    }
    return _share_server;
}
-(NSString *)STBext{
    if (_STBext == nil || [_STBext length] <= 0) {
        return bims_STBext;
        
    }
    return _STBext;
}
-(NSString *)open_flag
{
    if (_open_flag == nil || [_open_flag length] <= 0) {
        return bims_openflag;
        
    }
    return _open_flag;
}
-(NSString *)getHostFromJsonValue:(int )value{
    NSArray *serviceAddrs = [self.serviceAddrs mj_JSONObject];
    NSString *host = nil;
    for (NSDictionary *dic in serviceAddrs) {
        if ([[dic valueForKey:@"serviceType"] integerValue] == value) {
            host = [dic valueForKey:@"serviceAddr"];
            break;
        }
    }
    return host;
}
+ (UIColor *) colorFromHexCode:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

#pragma mark - setter
//added by yy 2015/11/09
- (void)setIsBarrageOn:(BOOL)isBarrageOn
{
    _isBarrageOn = isBarrageOn;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isBarrageOn forKey:isBarrageOnKey];
    [defaults synchronize];
}

- (void)setNickName:(NSString *)nickName
{
    _nickName = nickName;
    
    if (self.isLogin) {
        
        TPIMUser *user = [[TPIMUser alloc] initWithXMPPvCardTemp:[[TPXmppManager defaultManager] getMyvCardTemp]];
        if (![user.nickname isEqualToString:nickName]) {
            [[TPXmppManager defaultManager] updateMyInfo];
            [[TPXmppRoomManager defaultManager] saveNickname:nickName withUserJid:self.xmppUserId];
        }
        
    }
    
}

- (void)setFaceImg:(NSString *)faceImg
{
    _faceImg = faceImg;
    if (self.isLogin) {
        
        TPIMUser *user = [[TPIMUser alloc] initWithXMPPvCardTemp:[[TPXmppManager defaultManager] getMyvCardTemp]];
        if (![user.headImageUrl isEqualToString:faceImg]) {
            [[TPXmppManager defaultManager] updateMyInfo];
            [[TPXmppRoomManager defaultManager] saveHeadImageUrl:faceImg withUserJid:self.xmppUserId];
        }
        
    }
    
}
-(NSArray *)wordfilterArray{
    if (!_wordfilterArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"wordfilter"ofType:@"txt"];
        NSString *contents = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSArray *_arr = [contents componentsSeparatedByString:NSLocalizedString(@"\n", nil)];
        // DDLogInfo(@"srt=%@",_arr);
        _wordfilterArray = _arr;
    }
    return _wordfilterArray;
}
-(void)setLibrary_url:(NSString *)library_url
{
    [self sessionDownload:library_url];
}
- (void)sessionDownload:(NSString *)library_url
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSString *urlString = library_url;
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 指定下载文件保存的路径
        //        DDLogInfo(@"%@ %@", targetPath, response.suggestedFilename);
        // 将下载文件保存在缓存路径中
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", kDocumentFolder,response.suggestedFilename];
       /* NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        
        // URLWithString返回的是网络的URL,如果使用本地URL,需要注意
        NSURL *fileURL1 = [NSURL URLWithString:path];*/
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        
       // DDLogInfo(@"== %@ |||| %@", fileURL1, fileURL);
        
        return fileURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        DDLogError(@"%@ %@", filePath, error);
        
        NSString *path = [NSString stringWithFormat:@"%@/%@", kDocumentFolder,response.suggestedFilename];
        
        BOOL l = [Utils unArchiveFielFromPath:path toPath:kDocumentFolder];
        if (l) {
             NSString *documentsDirectory = [kDocumentFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"wordfilter.txt"]];
            NSString *contents = [[NSString alloc] initWithContentsOfFile:documentsDirectory encoding:NSUTF8StringEncoding error:nil];
            NSArray *_arr = [contents componentsSeparatedByString:NSLocalizedString(@"\n", nil)];
            
            _wordfilterArray = _arr;
        }
        
    }];
    
    [task resume];
}
/**
 *  定向IP
 */
+ (NSURL *)dingxiangIpForPlayUrl:(NSURL *)url{
    if ([CHANNELID isEqualToString:@"SCTP"]) {
        NSString *subUrl = [[url absoluteString] substringFromIndex:7];
        NSRange range = [subUrl rangeOfString:@"/"];
        
        
        NSString *lastStr = [subUrl substringFromIndex:range.location];
        
        NSString *action = [NSString stringWithFormat:@"%@%@",DINGXIANG,lastStr];
        NSURL *URL = [NSURL URLWithString:action];
        return URL;
    }
    else{
        return url;
    }
}
/*-(void)setExpireDate:(NSString *)expireDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyyMMddHHmmss"];
    NSDate *destDate= [dateFormatter dateFromString:expireDate];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:destDate];
    _expireDate = destDateString;
}*/
-(void)setDisable_moudles:(NSArray *)disable_moudles{
    NSArray *_arr = [(NSString *)disable_moudles componentsSeparatedByString:NSLocalizedString(@",", nil)];
    _disable_moudles = _arr;
}

-(NSString *)shareContent{
    if ([CHANNELID isEqualToString:taipanTest63]) {
        _shareContent = [NSString stringWithFormat:@"%@下载地址>>%@",SocialShareContent,self.phoneApk];
    }
    else{
        _shareContent = [NSString stringWithFormat:@"%@下载地址>>%@",SocialShareContent,self.phoneApk];
    }
    return _shareContent;
}
-(NSString *)cos_epg{
    if (_cos_epg == nil || [_cos_epg length] <= 0) {
        return bims_cosepg;
        
    }
    return _cos_epg;
}
-(NSString *)bssUserHost{
    // return @"http://10.10.48.223:8080/yst-lbss-api/";

    if (_bssUserHost == nil || [_bssUserHost length] <= 0) {
        return bims_bssHost;
        
    }
    return _bssUserHost;
}
-(NSString *)dmsHost{
    //return @"http://haixinke.tunnel.qydev.com/";
    if (_dmsHost == nil || [_dmsHost length] <= 0) {
        return bims_dmsHost;
        
    }
    return _dmsHost;
}
-(NSString *)uid{
#if 0
    if (self.isLogin) {
        if (!_uid) {
            return @"";
        }
        return _uid;
        
    }else{
        if (!self.anonymousUid) {
            return @"";
        }
        return self.anonymousUid;
    }
#endif 
    return isNullString(_uid);
}
-(NSString *)shareType{
    if (_shareType.length == 0) {
        return @"常规视频";
    }
    return _shareType;
}
-(NSString *)shareWay{
    if (_shareWay.length == 0) {
        return @"微信";
    }
    return _shareWay;
}
@end
