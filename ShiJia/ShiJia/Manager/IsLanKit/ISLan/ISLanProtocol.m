//
//  ISLanProtocol.m
//  HiTV
//
//  Created by Lanbo Zhang on 1/10/15.
//  Copyright (c) 2015 Lanbo Zhang. All rights reserved.
//

#import <UIKit/UIApplication.h>
#import <CoreGraphics/CoreGraphics.h>
#import "ISLanProtocol.h"
#import <CocoaAsyncSocket/GCDAsyncUdpSocket.h>
#import "HiTVNetworkUtility.h"
#import "HiTViSLanMessage.h"
#import <arpa/inet.h>
#import "HiTVDeviceInfo.h"

static CGFloat KDefaultTimeout = 10;
static NSUInteger KSenderPort = 5001;
static NSUInteger KTVPort = 5000;

@interface ISLanProtocol () <GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong) GCDAsyncUdpSocket* udpSocketServer;
@property (nonatomic, strong) NSTimer* heartbeatSenderTimer;
@property (nonatomic) int heartbeatMissing;
@property (nonatomic, strong) HiTVDeviceInfo* connectedDevice;

@end

@implementation ISLanProtocol

+ (instancetype)sharedInstance{
    static ISLanProtocol* instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(start)
                                                     name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)start{
    [self p_startListener];
}

- (void)stop{
    [self.udpSocketServer close];
    self.udpSocketServer = nil;
}


- (void) deviceDiscovery {

    HiTViSLanMessage* message = [[HiTViSLanMessage alloc] init];
    message.messageID = CTS_INFO;
    [message writeInt:CTS_INFO];

    [self p_sendDataTo:[HiTVNetworkUtility retrieveBroadcastSubNetMask]
              withPort:KTVPort
               andMessage:message];
}

- (BOOL)connectDevice:(HiTVDeviceInfo*)deviceInfo
             withName:(NSString*)name
             password:(NSString*)password{
    if ((deviceInfo != nil) && (name != nil)) {
        //建立发送数据包
        HiTViSLanMessage* message = [[HiTViSLanMessage alloc] init];
        message.messageID = CTS_LOGIN;
        [message writeInt:CTS_LOGIN];

        [message writeStringValue:name];
        [message writeStringValue:password];

        //数据发送
        [self p_sendDataTo:deviceInfo.ip
                  withPort:KTVPort
                   andMessage:message];
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)disconnect:(HiTVDeviceInfo*)deviceInfo{
    if (deviceInfo != nil) {
        //建立发送数据包
        HiTViSLanMessage* message = [[HiTViSLanMessage alloc] init];
        message.messageID = CTS_LOGOUT;
        [message writeInt:CTS_LOGOUT];

        //数据发送
        [self p_sendDataTo:deviceInfo.ip
                  withPort:KTVPort
                   andMessage:message];
        return YES;
    }
    else {
        return NO;
    }

}

- (BOOL)sendKeyCode:(int)key
           toDevice:(HiTVDeviceInfo*)deviceInfo{
    if (deviceInfo != nil) {
        //建立发送数据包
        HiTViSLanMessage* message = [[HiTViSLanMessage alloc] init];
        message.messageID = CTS_KEY;
        [message writeInt:CTS_KEY];

        [message writeInt:key];

        //数据发送
        [self p_sendDataTo:deviceInfo.ip
                  withPort:KTVPort
                   andMessage:message];
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)touchEvent:(int)event
                 x:(double)x
                 y:(double)y
           toDevice:(HiTVDeviceInfo*)deviceInfo{
    if (deviceInfo != nil) {
        //建立发送数据包
        HiTViSLanMessage* message = [[HiTViSLanMessage alloc] init];
        message.messageID = CTS_TOUCH;
        [message writeInt:CTS_TOUCH];

        [message writeInt:event];

        [message writeDouble:x];
        [message writeDouble:y];

        //数据发送
        [self p_sendDataTo:deviceInfo.ip
                  withPort:KTVPort
                   andMessage:message];
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)showPictureForURL:(NSString*)url
                    state:(BOOL)state
           toDevice:(HiTVDeviceInfo*)deviceInfo{
    if (deviceInfo != nil) {
        NSLog(@"showPictureForURL: %@", url);

        //建立发送数据包
        HiTViSLanMessage* message = [[HiTViSLanMessage alloc] init];
        message.messageID = CTS_SHOW_PIX;
        [message writeInt:CTS_SHOW_PIX];

        [message writeStringValue:url];

        [message writeByte:state];

        //数据发送
        [self p_sendDataTo:deviceInfo.ip
                  withPort:KTVPort
                   andMessage:message];
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)addShowPictureForURL:(NSString*)url
                    state:(BOOL)state
                    toDevice:(HiTVDeviceInfo*)deviceInfo{
    if (deviceInfo != nil) {
        NSLog(@"addShowPictureForURL: %@", url);

        //建立发送数据包
        HiTViSLanMessage* message = [[HiTViSLanMessage alloc] init];
        message.messageID = CTS_ADD_SHOW_PIX;
        [message writeInt:CTS_ADD_SHOW_PIX];

        [message writeStringValue:url];

        [message writeByte:state];

        //数据发送
        [self p_sendDataTo:deviceInfo.ip
                  withPort:KTVPort
                   andMessage:message];
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)showVideoForURL:(NSString*)url
                   name:(NSString*)name
                   time:(int)time
               toDevice:(HiTVDeviceInfo*)deviceInfo{
    if (deviceInfo != nil) {
        NSLog(@"showVideoForURL: %@", url);

        //建立发送数据包
        HiTViSLanMessage* message = [[HiTViSLanMessage alloc] init];
        message.messageID = CTS_SHOW_VIDEO;
        [message writeInt:CTS_SHOW_VIDEO];

        [message writeStringValue:url];
        [message writeStringValue:name];
        [message writeInt:NO];
        [message writeInt:time];

        //数据发送
        [self p_sendDataTo:deviceInfo.ip
                  withPort:KTVPort
                   andMessage:message];
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)addShowVideoForURL:(NSString*)url
                   name:(NSString*)name
                   time:(int)time
               toDevice:(HiTVDeviceInfo*)deviceInfo{
    if (deviceInfo != nil) {
        NSLog(@"addShowVideoForURL: %@", url);

        //建立发送数据包
        HiTViSLanMessage* message = [[HiTViSLanMessage alloc] init];
        message.messageID = CTS_ADD_SHOW_VIDEO;
        [message writeInt:CTS_ADD_SHOW_VIDEO];

        [message writeStringValue:url];
        [message writeStringValue:name];
        [message writeInt:NO];
        [message writeInt:time];

        //数据发送
        [self p_sendDataTo:deviceInfo.ip
                  withPort:KTVPort
                   andMessage:message];
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)showAudioForURL:(NSString*)url
                   name:(NSString*)name
                 artist:(NSString*)artist
                  album:(NSString*)album
                   time:(int)time
                  state:(BOOL)state
               toDevice:(HiTVDeviceInfo*)deviceInfo{
    if (deviceInfo != nil) {
        NSLog(@"showAudioForURL: %@", url);

        //建立发送数据包
        HiTViSLanMessage* message = [[HiTViSLanMessage alloc] init];
        message.messageID = CTS_SHOW_MUSIC;
        [message writeInt:CTS_SHOW_MUSIC];

        [message writeStringValue:url];
        [message writeByte:state];
        [message writeStringValue:name];
        [message writeStringValue:artist];
        [message writeStringValue:album];
        [message writeInt:time];

        //数据发送
        [self p_sendDataTo:deviceInfo.ip
                  withPort:KTVPort
                   andMessage:message];
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)addShowAudioForURL:(NSString*)url
                   name:(NSString*)name
                 artist:(NSString*)artist
                  album:(NSString*)album
                   time:(int)time
                  state:(BOOL)state
               toDevice:(HiTVDeviceInfo*)deviceInfo{
    if (deviceInfo != nil) {
        NSLog(@"addShowAudioForURL: %@", url);

        //建立发送数据包
        HiTViSLanMessage* message = [[HiTViSLanMessage alloc] init];
        message.messageID = CTS_ADD_SHOW_MUSIC;
        [message writeInt:CTS_ADD_SHOW_MUSIC];

        [message writeStringValue:url];
        [message writeByte:state];
        [message writeStringValue:name];
        [message writeStringValue:artist];
        [message writeStringValue:album];
        [message writeInt:time];

        //数据发送
        [self p_sendDataTo:deviceInfo.ip
                  withPort:KTVPort
                   andMessage:message];
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)playStartForDevice:(HiTVDeviceInfo*)deviceInfo{
    return [self p_sendCommand:CTS_PLAYER_START ToDevice:deviceInfo];
}

- (BOOL)playPauseForDevice:(HiTVDeviceInfo*)deviceInfo{
    return [self p_sendCommand:CTS_PLAYER_PAUSE ToDevice:deviceInfo];
}

- (BOOL)playStopForDevice:(HiTVDeviceInfo*)deviceInfo{
    return [self p_sendCommand:CTS_PLAYER_STOP ToDevice:deviceInfo];
}

- (BOOL)playNextForDevice:(HiTVDeviceInfo*)deviceInfo{
    return [self p_sendCommand:CTS_PLAYER_NEXT ToDevice:deviceInfo];
}

- (BOOL)playPreviousForDevice:(HiTVDeviceInfo*)deviceInfo{
    return [self p_sendCommand:CTS_PLAYER_PREVIOUS ToDevice:deviceInfo];
}

- (BOOL)playSeekAtTime:(int)time
              toDevice:(HiTVDeviceInfo*)deviceInfo{
    if (deviceInfo != nil) {
        //建立发送数据包
        HiTViSLanMessage* message = [[HiTViSLanMessage alloc] init];
        message.messageID = CTS_PLAYER_SEEK;
        [message writeInt:CTS_PLAYER_SEEK];

        [message writeInt:time];

        //数据发送
        [self p_sendDataTo:deviceInfo.ip
                  withPort:KTVPort
                   andMessage:message];
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)getSeekForDevice:(HiTVDeviceInfo*)deviceInfo{
    return [self p_sendCommand:CTS_GET_SEEK ToDevice:deviceInfo];
}

- (BOOL)getPlayStateForDevice:(HiTVDeviceInfo*)deviceInfo{
    return [self p_sendCommand:CTS_GET_PLAYER_STATE ToDevice:deviceInfo];
}

- (BOOL)setRotation:(int)degrees
           toDevice:(HiTVDeviceInfo*)deviceInfo{
    if (deviceInfo != nil) {
        //建立发送数据包
        HiTViSLanMessage* message = [[HiTViSLanMessage alloc] init];
        message.messageID = CTS_SET_ROTATION;
        [message writeInt:CTS_SET_ROTATION];

        [message writeInt:degrees];

        //数据发送
        [self p_sendDataTo:deviceInfo.ip
                  withPort:KTVPort
                   andMessage:message];
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark -GCDAsyncUdpsocket Delegate

/**
 * Called when the datagram with the given tag has been sent.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    NSLog(@"udp did send message:%@(%08lx)", [HiTViSLanMessage idToString:tag], tag);
}

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"udp did send not message:%@(%08lx) error: %@", [HiTViSLanMessage idToString:tag], tag, error);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    struct sockaddr_in* senderAddress = (struct sockaddr_in*)address.bytes;
    NSString* senderIp = [NSString stringWithUTF8String:inet_ntoa(senderAddress->sin_addr)];

    HiTViSLanMessage* message = [[HiTViSLanMessage alloc] initWithData:data];
    NSLog(@"Reciv Data\n[%@]\n len:%lu\n from ip:%@\n message:%@(%08lx)", data, (unsigned long)[data length],
          senderIp, [HiTViSLanMessage idToString:message.messageID], (unsigned long)message.messageID);

    HiTVDeviceInfo* deviceInfo = [[HiTVDeviceInfo alloc] init];
    deviceInfo.ip = senderIp;
    [self p_handleILLanMessage:message forDeviceInfo:deviceInfo];
}


- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error{
    NSLog(@"udpSocketDidClose Error:%@",[error description]);

    [self p_startListener];

}

#pragma mark - private methods

///
- (void)p_startListener{
    self.udpSocketServer.delegate = nil;
    [self.udpSocketServer close];
    GCDAsyncUdpSocket *socket=[[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];

    NSError *error = nil;
    if(![socket bindToPort:KSenderPort error:&error])
        NSLog(@"unable to bindToPort error: %@", error);

    if(![socket enableBroadcast:YES error:&error])
        NSLog(@"unable to enableBroadcast error: %@", error);


//    [socket joinMulticastGroup:[HiTVNetworkUtility retrieveBroadcastSubNetMask]
//                         error:&error];

    if(![socket beginReceiving:&error])
        NSLog(@"unable to beginReceiving error: %@", error);


//    if (nil != error) {
//        NSLog(@"failed.:%@",[error description]);
//    }

    NSLog(@"start udp server");

    self.udpSocketServer = socket;
}

- (void)p_sendDataTo:(NSString*)ip withPort:(NSUInteger)port andMessage:(HiTViSLanMessage*)message{
    NSData* data = [message makeData];
    NSLog(@"Send Data\n[%@]\n len:%lu\n to ip:%@\n message:%@(%08lx)", data, (unsigned long)[data length],
          ip, [HiTViSLanMessage idToString:message.messageID], (unsigned long)message.messageID);

    [self.udpSocketServer sendData:data
                            toHost:ip
                              port:port
                       withTimeout:KDefaultTimeout
                               tag:message.messageID];
}

#pragma mark data handler

- (void)p_handleILLanMessage:(HiTViSLanMessage*)message forDeviceInfo:(HiTVDeviceInfo*)deviceInfo{
    switch (message.messageID) {
        case STC_HEARTBEAT_REQUEST:
        //TODO: 心跳回应
        //心跳计数器充值
//        [self.heartbeatTimer invalidate];
//        [self.heartbeatTimer ];
//        mClientHeartbeat.reset(info.getIp());
        self.heartbeatMissing = 0;
        break;

        case STC_INFO_REQUEST:
        {
            //取得服务器结果信息
            //服务器类型
            __unused uint8_t serverType = [message readByte];

            __unused uint32_t unused = [message readInt];

            //服务器IP地址
            __unused uint32_t serverIp = [message readInt];
            //服务器端口号
            __unused uint32_t serverPort = [message readInt];
            //服务器名称
            deviceInfo.name = [message readStringValue];
            //设备地址
            deviceInfo.deviceID = [message readStringValue];
            //服务器密码标识
            deviceInfo.passwordFlag = [message readByte];

            NSLog(@"STC_INFO_REQUEST: device ip: %@, name: %@, id: %@", deviceInfo.ip, deviceInfo.name, deviceInfo.deviceID);

            [self.delegate onDeviceDiscovery:deviceInfo];
        }
        break;

        case STC_LOGIN_REQUEST:
        {
            //读取登录结果
            BOOL loginResult = [message readByte];
            NSString* host = [message readStringValue];

            // http://tvlookbackpanel.sc.ysten.com:8080/ysten-lvoms-epg/epg/getAllDayPrograms.shtml?templateId=0282
            NSLog(@"STC_LOGIN_REQUEST: host returned by box: %@", host);

            NSString *newHost = @"";
            if (host != nil && [host length] > 0) {
                NSURL *url = [NSURL URLWithString:host];

                if ([url scheme] != nil && [url host] != nil) {
                    newHost = [NSString stringWithFormat:@"%@://%@", [url scheme], [url host]];
                    if ([url port] != nil) {
                        newHost = [newHost stringByAppendingFormat:@":%@", [[url port] stringValue]];
                    }
                    newHost = [newHost stringByAppendingString:@"/"];
                }
            }

            deviceInfo.host = newHost;
            // http://tvlookbackpanel.sc.ysten.com:8080/
            NSLog(@"STC_LOGIN_REQUEST: host from isLanBox is: %@", newHost);
            NSLog(@"STC_LOGIN_REQUEST: device ip: %@", deviceInfo.ip);

            [self.delegate onConnectEchoForDevice:deviceInfo
                                     paramBoolean:loginResult
                                      paramString:newHost];

            if (loginResult) {
                self.connectedDevice = deviceInfo;
                //TODO: 启动心跳线程
//                mClientHeartbeat.removeAll();
//                mClientHeartbeat.add(info.getIp());
            }
        }
        break;

        case STC_LOGOUT_REQUEST:
        //TODO: 新版本不再支持
        break;

//        case STC_SCREEN_SNAP_REQUEST:
//        {
//            //读取截屏结果
//            BOOL screenSnapResult = [message readInt];
//            NSString *screenSnapUrl = nil;
//            if (screenSnapResult == true) {
//                screenSnapUrl = [message readStringValue];
//            }
//            [self.delegate onscr];
//            mProtocolCallback.onScreenSnapEcho(info, screenSnapUrl);
//
//        }
//        break;
//
//        case iSLanMessageID.STC_GET_APP_LIST_REQUEST:
//        //取得应用列表回复
//        String appList = stream.readString();
//        mProtocolCallback.onGetAppListEcho(info, appList);
//        break;
//
        case STC_GET_SEEK_REQUEST:
        {
            //seek请求回复
            int seekTime = [message readUInt];
            [self.delegate onGetSeekEcho:deviceInfo paramInt:seekTime];
        }
        break;

        case STC_GET_PLAYER_STATE_REQUEST:
        {
            //seek请求回复
            uint32_t state = [message readUInt];
            [self.delegate onGetPlayerStateEcho:deviceInfo paramInt:state];
        }

        break;

        case STC_SHOW_VIDEO_REQUEST:
        {
            //视频名称
            NSString* videoName = [message readStringValue];
            //当前时间
            int videoTime = [message readUInt];
            [self.delegate onShowAudioEchoForDevice:deviceInfo
                                        paramString:videoName
                                           paramInt:videoTime];
        }
                break;

        case STC_SHOW_MUSIC_REQUEST:
        {
            //音频名称
            NSString* audioName = [message readStringValue];
            //当前时间
            int audioTime = [message readInt];
            [self.delegate onShowAudioEchoForDevice:deviceInfo
                                        paramString:audioName
                                           paramInt:audioTime];
        }

        break;

        default:
        break;
    }
}

#pragma mark - private send single data
- (BOOL)p_sendCommand:(iSLanMessageID)command
             ToDevice:(HiTVDeviceInfo*)deviceInfo{
    if (deviceInfo != nil) {
        //建立发送数据包
        HiTViSLanMessage* message = [[HiTViSLanMessage alloc] init];
        message.messageID = command;
        [message writeInt:command];


        //数据发送
        [self p_sendDataTo:deviceInfo.ip
                  withPort:KTVPort
                   andMessage:message];
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - heartbit
- (void)invalidateHeartBitTimer{
    [self.heartbeatSenderTimer invalidate];
    self.heartbeatSenderTimer = nil;
}
- (void)resetHeartBitTimer{
    [self invalidateHeartBitTimer];
    [self sendHeartBit];
    self.heartbeatSenderTimer = [NSTimer scheduledTimerWithTimeInterval:10
                                                                 target:self
                                                               selector:@selector(sendHeartBit)
                                                               userInfo:nil
                                                                repeats:YES];
}

- (void)sendHeartBit{
    self.heartbeatMissing += 1;
    if (self.heartbeatMissing >= 10) {
        self.connectedDevice = nil;
    }else{
        [self p_sendCommand:CTS_HEARTBEAT ToDevice:self.connectedDevice];
    }
}

- (void)setConnectedDevice:(HiTVDeviceInfo *)connectedDevice{
    _connectedDevice = connectedDevice;
    if (connectedDevice) {
        [self resetHeartBitTimer];
    }else{
        [self invalidateHeartBitTimer];
        [self.delegate deviceDisconnected];
    }
}


/*
 发送语音
 modify by jianghailiang
 */
- (BOOL)sendSpeechRecognition:(NSString *)text toDevice:(HiTVDeviceInfo*)deviceInfo{
    if (deviceInfo != nil) {
        //建立发送数据包
        HiTViSLanMessage* message = [[HiTViSLanMessage alloc] init];
        message.messageID = CTS_SEND_SPEECH_REQUEST;
        [message writeInt:CTS_SEND_SPEECH_REQUEST];
        [message writeStringValue:text];

        //数据发送
        [self p_sendDataTo:deviceInfo.ip
                  withPort:KTVPort
                andMessage:message];
        return YES;
    }
    else {
        return NO;
    }
}
@end
