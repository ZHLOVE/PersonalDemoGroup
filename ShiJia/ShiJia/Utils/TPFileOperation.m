//
//  TPFilePath.m
//  HiTV
//
//  Created by yy on 15/11/19.
//  Copyright © 2015年 Lanbo Zhang. All rights reserved.
//

#import "TPFileOperation.h"

static NSString * const ShortVideoFileName = @"ShortVideos";
static NSString * const VoiceMessageFileName = @"VoiceMessages";
static NSString * const PublicVoiceMessageFileName = @"PublicVoiceMessages";
static NSString * const PrivateVoiceMessageFileName = @"PrivateVoiceMessages";

@implementation TPFileOperation

#pragma mark - Video path
+ (NSString *)getShortVideoFilePath
{
    //获取documents文件夹路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //video文件夹路径
    NSString *videoPath = [documentsPath stringByAppendingPathComponent:ShortVideoFileName];
   
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //检查文件夹是否存在
    if (![fileManager fileExistsAtPath:videoPath]) {
        
        //不存在，创建video文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:videoPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return videoPath;
}

+ (NSString *)getShortVideoPathWithName:(NSString *)name
{
    if (name.length == 0) {
        return nil;
    }
    return [[TPFileOperation getShortVideoFilePath] stringByAppendingPathComponent:name];
}

+ (NSString *)getShortVideoPathWithURL:(NSURL *)url
{
    if (url == nil) {
        return nil;
    }
    NSString *urlString = [url absoluteString];
    NSArray *array = [urlString componentsSeparatedByString:@"/"];
    NSString *name;
    if (array.count > 0) {
        name = [array lastObject];
    }
    
    return [self getShortVideoPathWithName:name];
}

+ (BOOL)clearShortVideoFile
{
    NSString *videoPath = [TPFileOperation getShortVideoFilePath];
    NSArray *a = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:videoPath error:nil];
    for (NSString *p in a) {
        [[NSFileManager defaultManager] removeItemAtPath:[videoPath stringByAppendingPathComponent:p] error:nil];
    }
    return YES;
}

+ (BOOL)removeShortVideo:(NSString *)name
{
    NSString *videoPath = [TPFileOperation getShortVideoPathWithName:name];
    return [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
}

+ (BOOL)shortVideoExists:(NSString *)name
{
    NSString *videoPath = [TPFileOperation getShortVideoPathWithName:name];
    return [[NSFileManager defaultManager] fileExistsAtPath:videoPath];
}

#pragma mark - Voice path
+ (NSString *)getVoiceMessageFilePath
{
    //获取documents文件夹路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //voice文件夹路径
    NSString *voicePath = [documentsPath stringByAppendingPathComponent:VoiceMessageFileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //检查文件夹是否存在
    if (![fileManager fileExistsAtPath:voicePath]) {
        
        //不存在，创建voice文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:voicePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return voicePath;
}

+ (NSString *)getVoiceMessagePathWithName:(NSString *)name
{
    if (name.length == 0) {
        return nil;
    }
    return [[TPFileOperation getVoiceMessageFilePath] stringByAppendingPathComponent:name];
}

+ (BOOL)clearVoiceMessageFile
{
    NSString *voicePath = [TPFileOperation getVoiceMessageFilePath];
    NSArray *a = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:voicePath error:nil];
    for (NSString *p in a) {
        [[NSFileManager defaultManager] removeItemAtPath:[voicePath stringByAppendingPathComponent:p] error:nil];
    }
    return YES;
}

+ (BOOL)removeVoiceMessage:(NSString *)name
{
    NSString *videoPath = [TPFileOperation getVoiceMessagePathWithName:name];
    return [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
}

#pragma mark - 群聊
+ (NSString *)getPublicVoiceMessageFilePath
{
    //获取documents文件夹路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //voice文件夹路径
    NSString *voicePath = [documentsPath stringByAppendingPathComponent:PublicVoiceMessageFileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //检查文件夹是否存在
    if (![fileManager fileExistsAtPath:voicePath]) {
        
        //不存在，创建voice文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:voicePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return voicePath;
}

+ (NSString *)getPublicVoiceMessagePathWithName:(NSString *)name
{
    if (name.length == 0) {
        return nil;
    }
    return [[TPFileOperation getPublicVoiceMessageFilePath] stringByAppendingPathComponent:name];
}

+ (BOOL)clearPublicVoiceMessageFile
{
    NSString *voicePath = [TPFileOperation getPublicVoiceMessageFilePath];
    NSArray *a = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:voicePath error:nil];
    for (NSString *p in a) {
        [[NSFileManager defaultManager] removeItemAtPath:[voicePath stringByAppendingPathComponent:p] error:nil];
    }
    return YES;
}

+ (BOOL)removePublicVoiceMessage:(NSString *)name
{
    NSString *videoPath = [TPFileOperation getPublicVoiceMessagePathWithName:name];
    return [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
}

#pragma mark - 私聊
+ (NSString *)getPrivateVoiceMessageFilePath
{
    //获取documents文件夹路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //voice文件夹路径
    NSString *voicePath = [documentsPath stringByAppendingPathComponent:PrivateVoiceMessageFileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //检查文件夹是否存在
    if (![fileManager fileExistsAtPath:voicePath]) {
        
        //不存在，创建voice文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:voicePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return voicePath;
}

+ (NSString *)getPrivateVoiceMessagePathWithName:(NSString *)name
{
    if (name.length == 0) {
        return nil;
    }
    return [[TPFileOperation getPrivateVoiceMessageFilePath] stringByAppendingPathComponent:name];
}

+ (BOOL)clearPrivateVoiceMessageFile
{
    NSString *voicePath = [TPFileOperation getPrivateVoiceMessageFilePath];
    NSArray *a = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:voicePath error:nil];
    for (NSString *p in a) {
        [[NSFileManager defaultManager] removeItemAtPath:[voicePath stringByAppendingPathComponent:p] error:nil];
    }
    return YES;
}

+ (BOOL)removePrivateVoiceMessage:(NSString *)name
{
    NSString *videoPath = [TPFileOperation getPrivateVoiceMessagePathWithName:name];
    return [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
}

#pragma mark - Basic opreation
+ (BOOL)removeFileAtPath:(NSString *)path
{
    if (path.length == 0) {
        return NO;
    }
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

+ (BOOL)removeItemAtURL:(NSURL *)url
{
    if (url != nil) {
        return [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    }
    return NO;
}

+ (BOOL)fileExistsAtPath:(NSString *)path
{
    DDLogInfo(@"%@:%zd",path,[[NSFileManager defaultManager] fileExistsAtPath:path]);
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

@end
