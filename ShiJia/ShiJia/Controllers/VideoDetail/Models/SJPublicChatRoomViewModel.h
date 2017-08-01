//
//  SJPublicChatRoomViewModel.h
//  ShiJia
//
//  Created by yy on 16/7/18.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TPIMMessage;
@class TPDanmakuData;

@interface SJPublicChatRoomViewModel : NSObject

@property (nonatomic, assign, readonly) NSInteger onlineNum;
@property (nonatomic, copy) void (^didReceiveMessage)(TPIMMessage *message, TPDanmakuData *danmuData);

#pragma mark - Download data
- (void)getChanelRoomWithChanelId:(NSString *)channelid
                          success:(void (^)(NSString *))success
                           failed:(void (^)(NSString *))failure;

- (void)queryRoomNumsWithRoomId:(NSString *)roomid
                        success:(void (^)(NSInteger))success
                          failed:(void (^)(NSString *))failure;

#pragma mark - Message
- (void)publicRoomSendMessage:(NSString *)msg;
- (void)publicRoomSendRecordData:(NSData *)recordData recordString:(NSString *)recordString recordDuration:(CGFloat)recordDuration;

#pragma mark - Room operation
- (void)leaveRoom;

@end
