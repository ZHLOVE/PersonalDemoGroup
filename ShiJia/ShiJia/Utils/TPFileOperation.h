//
//  TPFilePath.h
//  HiTV
//
//  Created by yy on 15/11/19.
//  Copyright © 2015年 Lanbo Zhang. All rights reserved.
//
/**
 *  用于聊天室语音、微视频文件操作
 */
#import <Foundation/Foundation.h>

@interface TPFileOperation : NSObject


#pragma mark - Video path
/**
 *  获取存放微视频文件夹路径
 *
 *  @return 返回路径
 */
+ (NSString *)getShortVideoFilePath;

/**
 *  获取某个微视频路径
 *
 *  @param name 微视频name
 *
 *  @return 返回路径
 */
+ (NSString *)getShortVideoPathWithName:(NSString *)name;

/**
 *  根据微视频下载地址获取本地路径
 *
 *  @param url 下载地址
 *
 *  @return 返回路径
 */
+ (NSString *)getShortVideoPathWithURL:(NSURL *)url;

/**
 *  删除某个微视频文件
 *
 *  @param 微视频name
 *
 *  @return 返回操作结果
 */
+ (BOOL)removeShortVideo:(NSString *)name;

/**
 *  清空存放微视频的文件夹
 *
 *  @return 返回操作结果
 */
+ (BOOL)clearShortVideoFile;

/**
 *  检查某个微视频是否存在
 *
 *  @param name 微视频name
 *
 *  @return 返回操作结果
 */
+ (BOOL)shortVideoExists:(NSString *)name;



#pragma mark - Voice path
/**
 *  获取存放聊天室语音的文件夹路径
 *
 *  @return 返回路径
 */
+ (NSString *)getVoiceMessageFilePath;

/**
 *  获取某个语音文件的路径
 *
 *  @param name 语音name
 *
 *  @return 返回路径
 */
+ (NSString *)getVoiceMessagePathWithName:(NSString *)name;

/**
 *  清空存放聊天室语音的文件夹
 *
 *  @return 返回操作结果
 */
+ (BOOL)clearVoiceMessageFile;

/**
 *  删除某个语音文件
 *
 *  @param name 语音文件name
 *
 *  @return 返回操作结果
 */
+ (BOOL)removeVoiceMessage:(NSString *)name;

#pragma mark - 群聊
/**
 *  获取存放聊天室语音的文件夹路径
 *
 *  @return 返回路径
 */
+ (NSString *)getPublicVoiceMessageFilePath;

/**
 *  获取某个语音文件的路径
 *
 *  @param name 语音name
 *
 *  @return 返回路径
 */
+ (NSString *)getPublicVoiceMessagePathWithName:(NSString *)name;

/**
 *  清空存放聊天室语音的文件夹
 *
 *  @return 返回操作结果
 */
+ (BOOL)clearPublicVoiceMessageFile;

/**
 *  删除某个语音文件
 *
 *  @param name 语音文件name
 *
 *  @return 返回操作结果
 */
+ (BOOL)removePublicVoiceMessage:(NSString *)name;

#pragma mark - 私聊
/**
 *  获取存放聊天室语音的文件夹路径
 *
 *  @return 返回路径
 */
+ (NSString *)getPrivateVoiceMessageFilePath;

/**
 *  获取某个语音文件的路径
 *
 *  @param name 语音name
 *
 *  @return 返回路径
 */
+ (NSString *)getPrivateVoiceMessagePathWithName:(NSString *)name;

/**
 *  清空存放聊天室语音的文件夹
 *
 *  @return 返回操作结果
 */
+ (BOOL)clearPrivateVoiceMessageFile;

/**
 *  删除某个语音文件
 *
 *  @param name 语音文件name
 *
 *  @return 返回操作结果
 */
+ (BOOL)removePrivateVoiceMessage:(NSString *)name;


#pragma mark - Basic Operation
/**
 *  删除指定路径下的文件
 *
 *  @param path 路径
 *
 *  @return 返回操作结果
 */
+ (BOOL)removeFileAtPath:(NSString *)path;

/**
 *  删除指定url下的文件
 *
 *  @param url
 *
 *  @return 返回操作结果
 */
+ (BOOL)removeItemAtURL:(NSURL *)url;

/**
 *  检查文件是否存在
 *
 *  @param path 路径
 *
 *  @return 返回检查结果
 */
+ (BOOL)fileExistsAtPath:(NSString *)path;

@end
