//
//  TPEditVideoViewController.h
//  ChatDemo
//
//  Created by yy on 15/10/22.
//  Copyright © 2015年 yy. All rights reserved.
//  编辑/发送短视频界面

#import <UIKit/UIKit.h>
#import "SJAlbumModel.h"

typedef void(^uploadBlock)(NSData *videoData,NSString *thumimageString);
/**
 *  完成视频录制通知
 */
extern NSString * const kTPEditVideoViewControllerDidFinishRecordingVideoNotificationName;
extern NSString * const kTPEditVideoViewControllerVideoUrlKey;

@interface TPEditVideoViewController : UIViewController

/**
 *  视频url（用于录制界面赋值）
 */
@property (nonatomic, strong) NSURL *videoURL;

@property (nonatomic, copy) uploadBlock upLoadBlock;

@property (nonatomic, strong) CloudAlbumModel *AlbumModel;

@end
