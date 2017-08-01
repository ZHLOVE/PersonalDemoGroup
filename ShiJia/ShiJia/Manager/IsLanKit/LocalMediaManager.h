//
//  LocalMediaManager.h
//  HiTV
//
//  Created by SeacCong on 15/1/12.
//  
//

#import <Foundation/Foundation.h>
@import AssetsLibrary;

/**
 *本地媒体库管理
 */
@interface LocalMediaManager : NSObject

+ (LocalMediaManager *) shared;

+ (ALAssetsLibrary *)shagedAssetsLibrary;

@property (nonatomic, copy) void(^scanCompleted)();

- (void) loadAssetGroups;
- (int) getPhotoNumber;
- (int) getVideoNumber;
- (int) getMusicNumber;
- (void)assetsLibraryDidChange:(NSNotification*)changeNotification;
- (void) loadMusic;
- (void) loadMediaLibrary;

@end
