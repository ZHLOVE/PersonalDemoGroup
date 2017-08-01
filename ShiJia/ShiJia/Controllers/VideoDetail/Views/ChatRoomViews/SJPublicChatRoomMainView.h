//
//  SJPublicChatRoomMainView.h
//  ShiJia
//
//  Created by yy on 16/6/21.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJHitTestView.h"

@class TPDanmakuData;
@class TPPublicMUCInputView;

@interface SJPublicChatRoomMainView : SJHitTestView

@property (nonatomic, readonly, strong) TPPublicMUCInputView *inputView;
@property (nonatomic, strong) UIViewController *activeController;
@property (nonatomic,   copy) NSString *channelId;
@property (nonatomic,   copy) void(^publicRoomDidReceiveDanmuData)(TPDanmakuData * danmuData);

//语音消息开始播放
@property (nonatomic, copy) void(^voiceMessageWillStartPlay)();

//语音消息播放结束
@property (nonatomic, copy) void(^voiceMessageDidFinishPlaying)();

- (void)leaveChatRoom;

@end
