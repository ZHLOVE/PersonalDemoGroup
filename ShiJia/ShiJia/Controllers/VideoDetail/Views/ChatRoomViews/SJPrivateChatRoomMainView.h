//
//  SJChatRoomMainView.h
//  ShiJia
//
//  Created by yy on 16/4/1.
//  Copyright © 2016年 yy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJHitTestView.h"

@class SJChatRoomViewModel;
@class TPDanmakuData;
@class TPPrivateMUCInputView;

@interface SJPrivateChatRoomMainView : SJHitTestView

@property (nonatomic, readonly, strong) TPPrivateMUCInputView *inputView;
@property (nonatomic, strong) UIViewController *activeController;
//@property (nonatomic, strong, readonly) SJChatRoomViewModel *viewModel;

//私聊房间收到弹幕消息
@property (nonatomic, copy) void(^privateRoomDidReceiveDanmuData)(TPDanmakuData * danmuData);

//语音消息开始播放
@property (nonatomic, copy) void(^voiceMessageWillStartPlay)();

//语音消息播放结束
@property (nonatomic, copy) void(^voiceMessageDidFinishPlaying)();

- (void)refreshData;
- (void)leaveChatRoom;


@end
