//
//  ISLanProtocol.h
//  HiTV
//
//  Created by Lanbo Zhang on 1/10/15.
//  Copyright (c) 2015 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HiTVDeviceInfo.h"

@protocol ISLanProtocolDelegate;

/**
 *  私有协议支持
 */
@interface ISLanProtocol : NSObject

@property (nonatomic, weak) id<ISLanProtocolDelegate> delegate;

@property (nonatomic, strong) NSArray* detectedTVs;

- (void)start;

- (void)stop;

- (void) deviceDiscovery;

- (BOOL)connectDevice:(HiTVDeviceInfo*)deviceInfo
             withName:(NSString*)name
             password:(NSString*)password;

- (BOOL)disconnect:(HiTVDeviceInfo*)deviceInfo;

- (BOOL)sendKeyCode:(int)key
           toDevice:(HiTVDeviceInfo*)deviceInfo;

- (BOOL)touchEvent:(int)event
                 x:(double)x
                 y:(double)y
          toDevice:(HiTVDeviceInfo*)deviceInfo;

- (BOOL)showPictureForURL:(NSString*)url
                    state:(BOOL)state
                 toDevice:(HiTVDeviceInfo*)deviceInfo;

- (BOOL)addShowPictureForURL:(NSString*)url
                       state:(BOOL)state
                    toDevice:(HiTVDeviceInfo*)deviceInfo;

- (BOOL)showVideoForURL:(NSString*)url
                   name:(NSString*)name
                   time:(int)time
               toDevice:(HiTVDeviceInfo*)deviceInfo;

- (BOOL)addShowVideoForURL:(NSString*)url
                      name:(NSString*)name
                      time:(int)time
                  toDevice:(HiTVDeviceInfo*)deviceInfo;

- (BOOL)showAudioForURL:(NSString*)url
                   name:(NSString*)name
                 artist:(NSString*)artist
                  album:(NSString*)album
                   time:(int)time
                  state:(BOOL)state
               toDevice:(HiTVDeviceInfo*)deviceInfo;

- (BOOL)addShowAudioForURL:(NSString*)url
                      name:(NSString*)name
                    artist:(NSString*)artist
                     album:(NSString*)album
                      time:(int)time
                     state:(BOOL)state
                  toDevice:(HiTVDeviceInfo*)deviceInfo;

- (BOOL)playStartForDevice:(HiTVDeviceInfo*)deviceInfo;

- (BOOL)playPauseForDevice:(HiTVDeviceInfo*)deviceInfo;

- (BOOL)playStopForDevice:(HiTVDeviceInfo*)deviceInfo;

- (BOOL)playNextForDevice:(HiTVDeviceInfo*)deviceInfo;

- (BOOL)playPreviousForDevice:(HiTVDeviceInfo*)deviceInfo;

- (BOOL)playSeekAtTime:(int)time
              toDevice:(HiTVDeviceInfo*)deviceInfo;

- (BOOL)getSeekForDevice:(HiTVDeviceInfo*)deviceInfo;

- (BOOL)getPlayStateForDevice:(HiTVDeviceInfo*)deviceInfo;

- (BOOL)setRotation:(int)degrees
           toDevice:(HiTVDeviceInfo*)deviceInfo;

/*
 发送语音
 modify by jianghailiang
 */
- (BOOL)sendSpeechRecognition:(NSString *)text toDevice:(HiTVDeviceInfo*)deviceInfo;

@end

@protocol ISLanProtocolDelegate <NSObject>

- (void) onConnectEchoForDevice:(HiTVDeviceInfo*) paramDeviceInfo
                   paramBoolean:(BOOL) paramBoolean
                    paramString:(NSString*) paramString;

- (void)deviceDisconnected;


- (void) onDeviceDiscovery:(HiTVDeviceInfo*) paramDeviceInfo;

- (void) onGetPlayerStateEcho:(HiTVDeviceInfo*) paramDeviceInfo
                     paramInt:(uint32_t) paramInt;

- (void) onGetSeekEcho:(HiTVDeviceInfo*) paramDeviceInfo
          paramInt:(int) paramInt;

- (void) onShowAudioEchoForDevice:(HiTVDeviceInfo*) paramDeviceInfo
                      paramString:(NSString*) paramString
                         paramInt:(int) paramInt;

- (void) onShowVideoEchoForDevice:(HiTVDeviceInfo*) paramDeviceInfo
                      paramString:(NSString*) paramString
                         paramInt:(int) paramInt;

@end

