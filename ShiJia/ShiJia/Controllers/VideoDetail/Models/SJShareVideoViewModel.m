//
//  SJShareVideoViewModel.m
//  ShiJia
//
//  Created by yy on 16/5/13.
//  Copyright © 2016年 Ysten. All rights reserved.
//

#import "SJShareVideoViewModel.h"

//#import "UMSocialSnsPlatformManager.h"
//#import "UMSocial.h"
#import "WeiboSDK.h"

#import "TPIMMessageModel.h"
#import "TPIMNodeModel.h"
#import "TPIMContentModel.h"

#import "HiTVVideo.h"
#import "VideoSource.h"
#import "UserEntity.h"
#import "WatchFocusVideoEntity.h"
#import "WatchFocusVideoProgramEntity.h"
#import "TVProgram.h"
#import "TVStation.h"
#import "AES128Util.h"
#import "SJShareVideoViewController.h"
#import "SJ30SVedioRequestModel.h"

@interface SJShareVideoViewModel ()
{
    NSString *wbtoken;
    UIViewController *activeController;
}

@end

@implementation SJShareVideoViewModel

#pragma mark - Lifecycle
- (instancetype)initWithController:(UIViewController *)controller
{
    self = [super init];
    
    if (self) {
        activeController = controller;
    }
    return self;
}

#pragma mark - Umeng Share
#pragma mark - 短视频分享
- (void)shareShortVedioToUserFriends:(NSArray <UserEntity *> *)list{

    NSString *url = self.shortVideoUrl;

    TPIMMessageModel *message = [[TPIMMessageModel alloc] init];
    message.ext = @"1";
    message.persistent = @"1";
    
    //from
    TPIMNodeModel *from = [[TPIMNodeModel alloc] init];
    from.uid = [HiTVGlobals sharedInstance].uid;
    from.nickname = [HiTVGlobals sharedInstance].nickName;
    from.jid = [HiTVGlobals sharedInstance].xmppUserId;
    message.from = from;
    
    //to array
    NSMutableArray *to = [[NSMutableArray alloc] init];
    for (UserEntity *model in list) {
        TPIMNodeModel *node = [[TPIMNodeModel alloc] init];
        node.jid = model.jid;
        node.uid = model.uid;
        node.nickname = model.name.length > 0 ? model.name : model.nickName;
        if (node.nickname.length == 0) {
            node.nickname = model.name;
        }
        [to addObject:node];
    }
    message.to = [NSArray arrayWithArray:to];
    
    
    message.type = @"11";
    
    //content
    TPIMContentModel *content = [[TPIMContentModel alloc] init];
    content.faceImg = [HiTVGlobals sharedInstance].faceImg;
    content.content = [NSString stringWithFormat:@"%@ 发给你一条视频",[HiTVGlobals sharedInstance].nickName];
    content.path = url;
    content.filesdpath = self.videoThumImgUrl;
    
    message.contentModel = content;
    message.title = [NSString stringWithFormat:@"%@ 发给你一条视频",[HiTVGlobals sharedInstance].nickName];
    message.summary = message.title;
    
    //发送消息
    
    [TPIMMessageModel sendMessage:message completionHandler:^(id responseObject, NSError *error) {
        NSString* str = [NSUserDefaultsManager getObjectForKey:LOG_SHARE_CONTENT];
        if (!error){
            if (str != nil) {
                [Utils BDLog:1 module:@"605" action:@"Share" content:[NSString stringWithFormat:str,0]];
            }
//            UIView *subView=[UIApplication sharedApplication].keyWindow;
//            [MBProgressHUD showMessag:@"分享成功" toView:subView];
            [OMGToast showWithText:@"分享成功"];
            [activeController.navigationController popViewControllerAnimated:YES];
//            [MBProgressHUD showSuccess:@"分享成功" toView:nil];
            
            
        }else{
            
            if (str != nil) {
                [Utils BDLog:1 module:@"605" action:@"Share" content:[NSString stringWithFormat:str,-1]];
            }
            //分享失败
//            [MBProgressHUD showError:@"分享失败" toView:nil];
            [MBProgressHUD showMessag:@"分享失败" toView:nil];
        }
        [NSUserDefaultsManager saveObject:nil forKey:LOG_SHARE_CONTENT];
    }];

}

#pragma mark - 图片分享
- (void)shareImageToUserFriends:(NSArray <UserEntity *> *)list{
    
    NSString *url = self.imageUrl;
    
    TPIMMessageModel *message = [[TPIMMessageModel alloc] init];
    message.ext = @"1";
    
    //from
    TPIMNodeModel *from = [[TPIMNodeModel alloc] init];
    from.uid = [HiTVGlobals sharedInstance].uid;
    from.nickname = [HiTVGlobals sharedInstance].nickName;
    from.jid = [HiTVGlobals sharedInstance].xmppUserId;
    message.from = from;
    
    //to array
    NSMutableArray *to = [[NSMutableArray alloc] init];
    for (UserEntity *model in list) {
        TPIMNodeModel *node = [[TPIMNodeModel alloc] init];
        node.jid = model.jid;
        node.uid = model.uid;
        node.nickname = model.name.length > 0 ? model.name : model.nickName;
        if (node.nickname.length == 0) {
            node.nickname = model.name;
        }
        [to addObject:node];
    }
    message.to = [NSArray arrayWithArray:to];
    
    
    message.type = @"26";
    
    //content
    TPIMContentModel *content = [[TPIMContentModel alloc] init];
    content.faceImg = [HiTVGlobals sharedInstance].faceImg;
    content.content = [NSString stringWithFormat:@"%@ 给你分享一张图片",[HiTVGlobals sharedInstance].nickName];

    content.path = url;
    
    message.contentModel = content;
    message.title = [NSString stringWithFormat:@"%@ 给你分享一张图片",[HiTVGlobals sharedInstance].nickName];
    message.summary = message.title;
    
    //发送消息
    [TPIMMessageModel sendMessage:message completionHandler:^(id responseObject, NSError *error) {
        NSString* str = [NSUserDefaultsManager getObjectForKey:LOG_SHARE_CONTENT];
        if (!error){
            
            
            if (str != nil) {
                [Utils BDLog:1 module:@"605" action:@"Share" content:[NSString stringWithFormat:str,0]];
            }
            
            [activeController.navigationController popViewControllerAnimated:YES];
//            [MBProgressHUD showSuccess:@"分享成功" toView:nil];
             [OMGToast showWithText:@"分享成功"];

        }else{
            if (str != nil) {
                [Utils BDLog:1 module:@"605" action:@"Share" content:[NSString stringWithFormat:str,-1]];
            }
            [MBProgressHUD showError:@"分享失败" toView:nil];
           
        }
        [NSUserDefaultsManager saveObject:nil forKey:LOG_SHARE_CONTENT];
    }];
    
}
//!!!:分享有料视频给视加好友
//!!!:
-(void)shareHotSpotVideoToUserFriends:(NSArray <UserEntity *> *)list{

    TPIMMessageModel *message = [[TPIMMessageModel alloc] init];
    message.ext = @"1";

    //from
    TPIMNodeModel *from = [[TPIMNodeModel alloc] init];
    from.uid = [HiTVGlobals sharedInstance].uid;
    from.nickname = [HiTVGlobals sharedInstance].nickName;
    from.jid = [HiTVGlobals sharedInstance].xmppUserId;
    message.from = from;

    //to array
    NSMutableArray *to = [[NSMutableArray alloc] init];
    for (UserEntity *model in list) {
        TPIMNodeModel *node = [[TPIMNodeModel alloc] init];
        node.jid = model.jid;
        node.uid = model.uid;
        node.nickname = model.name.length > 0 ? model.name : model.nickName;
        if (node.nickname.length == 0) {
            node.nickname = model.name;
        }
        [to addObject:node];
    }
    message.to = [NSArray arrayWithArray:to];


    message.type = @"28";

    //content
    TPIMContentModel *content = [[TPIMContentModel alloc] init];
    content.faceImg = [HiTVGlobals sharedInstance].faceImg;
    content.content = [NSString stringWithFormat:@"%@ 给你分享一个短视频",[HiTVGlobals sharedInstance].nickName];
    content.hotspotID = self.hotspotVideoID;
    content.filesdpath = self.hotspotVideoImage;

    message.contentModel = content;
    message.title = [NSString stringWithFormat:@"%@ 给你分享一个短视频",[HiTVGlobals sharedInstance].nickName];
    message.summary = message.title;

    //发送消息
    [TPIMMessageModel sendMessage:message completionHandler:^(id responseObject, NSError *error) {
        NSString* str = [NSUserDefaultsManager getObjectForKey:LOG_SHARE_CONTENT];
        if (!error){


            if (str != nil) {
                [Utils BDLog:1 module:@"605" action:@"Share" content:[NSString stringWithFormat:str,0]];
            }

            [activeController.navigationController popViewControllerAnimated:YES];
//            [MBProgressHUD showSuccess:@"分享成功" toView:nil];
           [OMGToast showWithText:@"分享成功"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@"短视频" forKey:@"type"];
            [dic setValue:[NSString stringWithFormat:@"%@好友",CurrentAppName] forKey:@"share_way"];
            [UMengManager event:@"U_Share" attributes:dic];

        }else{
            if (str != nil) {
                [Utils BDLog:1 module:@"605" action:@"Share" content:[NSString stringWithFormat:str,-1]];
            }
            [MBProgressHUD showError:@"分享失败" toView:nil];

        }
        [NSUserDefaultsManager saveObject:nil forKey:LOG_SHARE_CONTENT];
    }];
}


#pragma mark - XMPP Message
- (void)shareVideoToUsers:(NSArray <UserEntity *> *)list{
    
    if (self.shortVideoUrl.length > 0) {
        // 分享短视频
        [self shareShortVedioToUserFriends:list];
        return;
    }
    
    if (self.imageUrl.length > 0) {
        // 分享图片
        [self shareImageToUserFriends:list];
        
        return;
    }

    if (self.hotspotVideoID.length>0) {
        [self shareHotSpotVideoToUserFriends:list];
        return;
    }

    
    TPIMMessageModel *message = [[TPIMMessageModel alloc] init];
    
    //保存消息标志位
    message.ext = @"1";
    
    //to array
    NSMutableArray *to = [[NSMutableArray alloc] init];
    for (UserEntity *model in list) {
        TPIMNodeModel *node = [[TPIMNodeModel alloc] init];
        node.jid = model.jid;
        node.uid = model.uid;
        node.nickname = model.name.length > 0 ? model.name : model.nickName;
        if (node.nickname.length == 0) {
            node.nickname = model.name;
        }
        [to addObject:node];
    }
    message.to = [NSArray arrayWithArray:to];
    
    //消息类型，6--分享消息
    message.type = @"6";
    
    //content Model
    
    __block TPIMContentModel *contentModel = [[TPIMContentModel alloc] init];
    
    __block NSString* videoTypeStr = nil;
    
    switch (self.videoType) {
            // 点播
        case TPShareVideoTypeVOD:
        {
            contentModel.url = self.videoSource.actionURL;
            contentModel.videoType = @"vod";
            contentModel.pId = self.video.videoID;
            contentModel.thumPath = self.video.picurl;
            contentModel.programId = self.videoSource.sourceID;
            contentModel.programSeriesId = self.video.videoID;
            contentModel.programName = self.videoSource.name;
            contentModel.directors = self.video.director;
            contentModel.actors = self.video.actor;
            message.title = [NSString stringWithFormat:@"%@ 分享给你一个节目《%@》",[HiTVGlobals sharedInstance].nickName,self.videoSource.name];
            contentModel.content = [NSString stringWithFormat:@"<font color='#e6e6e6'>%@ 分享给你一个节目</font><font color='#005d70'>《%@》</font>",[HiTVGlobals sharedInstance].nickName,self.videoSource.name];
            
            videoTypeStr = @"点播";
            
        }
            break;
            // 看点
        case TPShareVideoTypeWatchTV:
        {
            
            contentModel.url = [self encodeActionUrl:self.watchProgramEntity.programUrl];
            contentModel.videoType = @"watchtv";
            contentModel.thumPath = self.watchEntity.img;
            contentModel.pId = self.watchEntity.catgId.description;
            contentModel.programSeriesId = self.watchEntity.catgId.description;
            contentModel.programName = self.watchProgramEntity.programName;
            contentModel.programId = self.watchProgramEntity.programId;
            contentModel.directors = self.watchEntity.director;
            contentModel.startTime = [NSString stringWithFormat:@"%lld",self.watchProgramEntity.startTime];
            contentModel.endTime = [NSString stringWithFormat:@"%lld",self.watchProgramEntity.endTime];
            message.title = [NSString stringWithFormat:@"%@ 分享给你一个节目《%@》",[HiTVGlobals sharedInstance].nickName,self.watchProgramEntity.programName];
            contentModel.content = [NSString stringWithFormat:@"<font color='#e6e6e6'>%@ 分享给你一个节目</font><font color='#005d70'>《%@》</font>",[HiTVGlobals sharedInstance].nickName,self.watchProgramEntity.programName];
            
            videoTypeStr = @"看点";
        }
            break;
            
            //频道
        case TPShareVideoTypeLive:
        {
            contentModel.url = self.tvProgram.programUrl;
            contentModel.videoType = @"live";
            contentModel.pId = self.tvStation.uuid;
            contentModel.programId = [NSString stringWithFormat:@"%.f",self.tvProgram.programId];
            contentModel.programSeriesId = self.tvStation.uuid;
            contentModel.programName = self.tvProgram.programName;
            contentModel.thumPath = self.tvProgram.hPosterAddr;
            contentModel.channelUuid = self.tvStation.uuid;
            contentModel.uuId = self.tvStation.uuid;
            contentModel.startTime = self.tvProgram.startTime;
            contentModel.endTime = self.tvProgram.endTime;
            contentModel.channelLogo = self.tvStation.logo;
            contentModel.channelName = self.tvStation.channelName;
            message.title = [NSString stringWithFormat:@"%@ 分享给你一个节目《%@》",[HiTVGlobals sharedInstance].nickName,self.tvProgram.programName];
            contentModel.content = [NSString stringWithFormat:@"<font color='#e6e6e6'>%@ 分享给你一个节目</font><font color='#005d70'>《%@》</font>",[HiTVGlobals sharedInstance].nickName,self.tvProgram.programName];
            videoTypeStr = @"直播";
        }
            break;
        case TPShareVideoTypeReplay:
        {
            contentModel.url = self.tvProgram.programUrl;
            contentModel.videoType = @"replay";
            contentModel.pId = self.tvStation.uuid;
            contentModel.programId = [NSString stringWithFormat:@"%.f",self.tvProgram.programId];
            contentModel.programSeriesId = self.tvStation.uuid;
            contentModel.programName = self.tvProgram.programName;
            contentModel.thumPath = self.tvProgram.hPosterAddr;
            contentModel.channelUuid = self.tvStation.uuid;
            contentModel.uuId = self.tvStation.uuid;
            contentModel.startTime = self.tvProgram.startTime;
            contentModel.endTime = self.tvProgram.endTime;
            contentModel.channelLogo = self.tvStation.logo;
            contentModel.channelName = self.tvStation.channelName;
            message.title = [NSString stringWithFormat:@"%@ 分享给你一个节目《%@》",[HiTVGlobals sharedInstance].nickName,self.tvProgram.programName];
            contentModel.content = [NSString stringWithFormat:@"<font color='#e6e6e6'>%@ 分享给你一个节目</font><font color='#005d70'>《%@》</font>",[HiTVGlobals sharedInstance].nickName,self.tvProgram.programName];
            
            videoTypeStr = @"回看";
        }
            break;
            
        default:
            
            break;
    }
    
    contentModel.contents = contentModel.content;
    contentModel.datePoint = [NSString stringWithFormat:@"%.f",self.currentPlayedSeconds];
    contentModel.faceImg = [HiTVGlobals sharedInstance].faceImg;


    message.summary = message.title;
    
    //消息发送方式
    message.sentMethod = kTPMessageSentMethod_ByHttp;
    
    message.contentModel = contentModel;
    
    __weak __typeof(self)weakSelf = self;

    //发送消息
    [TPIMMessageModel sendMessage:message completionHandler:^(id responseObject, NSError *error) {
        if (error == nil) {
              __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSString* content = [NSString stringWithFormat:@"state=%d&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&way=%@&sharetime=%@&sharepoint=%@",0, videoTypeStr, isNullString(contentModel.channelUuid), isNullString(contentModel.programSeriesId), isNullString(contentModel.programId), isNullString(strongSelf.video.name), isNullString(contentModel.programName), @"视加好友", isNullString([[NSUserDefaults standardUserDefaults] objectForKey:LOG_SHARE_VIDEO_LENGTH]), [Utils getCurrentTime]];
            
            [Utils BDLog:1 module:@"605" action:@"Share" content:content];
            
            if (activeController.navigationController.view) {

                [MBProgressHUD showSuccess:@"分享成功" toView:activeController.navigationController.view];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:@"常规视频" forKey:@"type"];
                [dic setValue:[NSString stringWithFormat:@"%@好友",CurrentAppName] forKey:@"share_way"];
                [UMengManager event:@"U_Share" attributes:dic];
                
            }
            [activeController.navigationController popViewControllerAnimated:YES];
        }
        else{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSString* content = [NSString stringWithFormat:@"state=%d&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&way=%@&sharetime=%@&sharepoint=%@",-1, videoTypeStr, isNullString(strongSelf.tvStation.uuid), isNullString(strongSelf.tvStation.uuid), [NSString stringWithFormat:@"%.f",self.tvProgram.programId], isNullString(strongSelf.tvProgram.programName), isNullString(strongSelf.tvProgram.channelName), @"视加好友", [[NSUserDefaults standardUserDefaults] objectForKey:LOG_SHARE_VIDEO_LENGTH], [Utils getCurrentTime]];
            
            [Utils BDLog:1 module:@"605" action:@"Share" content:content];
            //分享失败
            if (activeController.navigationController.view) {

                [MBProgressHUD showError:@"分享失败" toView:activeController.navigationController.view];
            }
        }
    }];
    
}





#pragma mark - 播放地址解码
- (NSString *)encodeActionUrl:(NSString *)actionUrl
{
    NSString *key = @"36b9c7e8695468dc";
    
    NSString *resultUrl;
    
    if ([actionUrl rangeOfString:@"yst://"].location != NSNotFound) {
        NSString *strUrl = [actionUrl stringByReplacingOccurrencesOfString:@"yst://" withString:@""];
        
        resultUrl = [AES128Util AES128Decrypt:strUrl key:key];
        
    }
    else{
        resultUrl = actionUrl;
    }
    
    return resultUrl;
}


@end
