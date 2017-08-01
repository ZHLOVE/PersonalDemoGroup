//
//  SJInviteUserViewModel.m
//  ShiJia
//
//  Created by yy on 16/5/17.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJInviteUserViewModel.h"

#import "TPIMMessageModel.h"
#import "TPIMNodeModel.h"
#import "TPIMContentModel.h"
#import "TPIMEpgData.h"
#import "VideoSource.h"
#import "HiTVVideo.h"

#import "AES128Util.h"

#import "TPXmppManager.h"
#import "TPXmppRoomManager.h"
#import "TPIMGroup.h"

@implementation SJInviteUserViewModel
{
    NSMutableArray *friendList;//好友列表
    BOOL createdRoom;//是否已创建房间标志位，避免重复创建房间
    BOOL finishInvited;//是否已发送邀请标志位
    NSString *createdGroupName;//已创建的房间名称
}

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Public
//发送邀请消息
- (void)sendInvitationMessageToUsers:(NSArray <UserEntity *> *)list;
{
    TPIMMessageModel *message = [[TPIMMessageModel alloc] init];
    
    //保存消息标志位
    message.ext = @"1";
    
    //to array
    NSMutableArray *to = [[NSMutableArray alloc] init];
    for (UserEntity *model in list) {
        TPIMNodeModel *node = [[TPIMNodeModel alloc] init];
        node.jid = model.jid;
        node.uid = model.uid;
        node.nickname = model.nickName;
        if (node.nickname.length == 0) {
            node.nickname = model.name;
        }
        [to addObject:node];
    }
    message.to = [NSArray arrayWithArray:to];
    
    //消息类型，7--约片消息
    message.type = @"7";
    
    //content Model
    TPIMContentModel *content = [[TPIMContentModel alloc] init];
    
    //epg data
    TPIMEpgData *epgdata = [[TPIMEpgData alloc] initWithHiTVVideo:self.video];
    content.epgDataModel = epgdata;
    content.curPosition = [NSString stringWithFormat:@"%zd",self.currentVideoIndex];
    
    //加密url
    //content.url = self.videoSource.actionURL;
    
    //影片url，未加密url
    NSString *key = @"36b9c7e8695468dc";
    if ([self.videoSource.actionURL rangeOfString:@"yst://"].location != NSNotFound) {
        NSString *strUrl = [self.videoSource.actionURL stringByReplacingOccurrencesOfString:@"yst://" withString:@""];
        
        //start modified by Lance Zhang, playing watch Focus video
        if ([self.videoSource isKindOfClass:[VideoSource class]]) {
            content.url  = [AES128Util AES128Decrypt:strUrl key:key];
        }else{
            content.url  = strUrl;
            
        }
    }
    else{
        content.url = self.videoSource.actionURL;
    }
    
    content.playerType = self.playerType;
    
    if ([self.playerType isEqualToString:@"onDemand"]) {
        //看点（可投屏）
        content.videoType = VideoTypeNetwork;
    }
    else if ([self.playerType isEqualToString:@"channel"]){
        //频道直播（可投屏）
        content.videoType = VideoTypeChannelZuiXin;
    }
    
    //房间id
    content.roomId = [NSString stringWithFormat:@"%@",[[TPXmppManager defaultManager] roomJidWithRoomName:@""]];
    
    //影片开始时间
    content.startTime = [NSString stringWithFormat:@"%f",self.startTime];
    
    //信息标题
    message.title = [NSString stringWithFormat:@"%@ 约你一起看《%@》",[HiTVGlobals sharedInstance].nickName,self.videoSource.name];
    
    //消息内容
    content.contents = [NSString stringWithFormat:@"<font color='#e6e6e6'>你的好友 %@ 约你一起看</font> <font color='#005d70'>《%@》</font> <font color='#e6e6e6'>,要不要马上就约起来，一起边看边聊呢？</font>",[HiTVGlobals sharedInstance].nickName,self.videoSource.name];
    content.content = content.contents;
    
    message.summary = message.title;
    
    //消息发送方式
    message.sentMethod = kTPMessageSentMethod_ByHttp;
    
    message.contentModel = content;
    
    //发送消息
    [TPIMMessageModel sendMessage:message];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
}

//创建房间
- (void)createRoom
{
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
    if (!createdRoom) {
        
        //设置创建房间标志位为YES，避免重复创建房间
        createdRoom = YES;
        
        //从播放器进入邀请
        
        //1、创建xmpp房间/进入房间
        TPIMGroup *group = [[TPIMGroup alloc] init];
        group.groupName = createdGroupName;
        
        if (group.groupName.length == 0) {
            
            return;
        }
        [TPIMGroup createGroup:group completionHandler:^(id responseObject, NSError *error) {
            
            if (error == nil) {
                //创建房间成功
                
            }
            else{
                //创建房间失败
                
            }
        }];
    }
}

@end
