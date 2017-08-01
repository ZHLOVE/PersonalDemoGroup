//
//  ScreenManager.h
//  HiTV
//
//  Created by cs090_jzb on 15/8/17.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "DeviceChooseView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TPIMMessageModel.h"

#define NOT_SUPPORT_REMOTE_PROJECT 0

typedef void (^ScreenManagerDeviceDetectedBlock)();
typedef void (^ScreenManagerLacalRemoteBlock)();

typedef void(^RemoteLoacalFile )(BOOL showSuccess);
typedef void(^ScreenManagerBlock )(BOOL showSuccess,NSString *time);

typedef enum SouceType_
{
    Audio,      //音频
    Video,      //视频
    Photo,      //图片
    OnDemand,   //点播
    WatchTV,    //看点
    
    /*操作投屏播放器*/
    Exit,       //播放器退出
    Pause,      //暂停
    Resume,     //恢复
    Seek,       //seek
}SouceType;

@interface ScreenManager : NSObject
+ (instancetype)sharedInstance;

@property (nonatomic, copy) RemoteLoacalFile remoteLoacalFileBlock;
@property (nonatomic, copy) ScreenManagerBlock screenManagerBlock;
@property (nonatomic, strong) NSString *state;

- (void)reset;
/**
 *  本地文件的投屏事件
 *
 *  @return
 */

-(void)remoteLoacalFileWith:(TPIMContentModel *)contentModel andType:(SouceType)sourceType;


//投屏点播或直播
-(void)remoteNetVideoWithContentModel:(TPIMContentModel *)conentModel;

//弹幕消息投屏

-(void)remoteChatRoomVideoWithContentModel:(TPIMContentModel *)contentModel;

//遥控器控制
-(void)remoteControlContentModel:(TPIMContentModel *)conentModel;

//操作投屏播放器
//- (void)remotePlayerWithSourceType:(SouceType)sourceType;



@end
