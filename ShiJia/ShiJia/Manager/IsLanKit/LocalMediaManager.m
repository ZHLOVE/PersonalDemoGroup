//
//  LocalMediaManager
//  HiTV
//
//  Created by SeacCong on 15/1/12.
//
//

#import "LocalMediaManager.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <MediaPlayer/MPMediaQuery.h>
#import <MediaPlayer/MPMediaPlaylist.h>
#import <MediaPlayer/MPMediaLibrary.h>



@interface LocalMediaManager()
{
    int photoNumber;
    int videoNumber;
    int musicNumber;

    NSMutableArray  *assetGroups;
    NSArray         *songsArray;
}

@end


@implementation LocalMediaManager

+ (LocalMediaManager *) shared
{
    @synchronized(self){
        static LocalMediaManager *shared;
        if(!shared){
            shared = [[LocalMediaManager alloc] init];

            //
            [shared buildMonitorChanged];
        }

        return shared;
    }
}

+ (ALAssetsLibrary *)shagedAssetsLibrary
{
    static ALAssetsLibrary *assertLibraryshared;
    if( !assertLibraryshared){
        assertLibraryshared = [[ALAssetsLibrary alloc]init];


    }
    return assertLibraryshared;
}

- (void)assetsLibraryDidChange:(NSNotification*)changeNotification
{
    [self loadMediaLibrary];
}


- (id) init
{
    self = [super init];
    if(!self){
        return nil;
    }

    assetGroups = [[NSMutableArray alloc]init];

    photoNumber = 0;
    videoNumber = 0;
    musicNumber = 0;

    return self;

}


- (void) dealloc
{
    assetGroups = nil;
}

- (int) getPhotoNumber
{
    return photoNumber;
}


- (int) getVideoNumber
{
    return videoNumber;
}

- (int) getMusicNumber
{
    return musicNumber;
}

- (void) loadMediaLibrary
{
    [self performSelectorInBackground:@selector(loadMediaOnThread) withObject:nil];

}

- (void) loadMediaOnThread
{
    [self loadAssetGroups];
    [self loadMusic];
}

- (void) loadAssetGroups
{

    photoNumber = 0;
    videoNumber = 0;

    //创建photoLibrary句柄
    ALAssetsLibrary * assetsLibrary = [LocalMediaManager shagedAssetsLibrary];


    if(!assetsLibrary) return;

    //
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if(group){
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                //从group里面
                NSString* assetType = [result valueForProperty:ALAssetPropertyType];
                if ([assetType isEqualToString:ALAssetTypePhoto]) {
                    photoNumber++;
                }else if([assetType isEqualToString:ALAssetTypeVideo]){
                    videoNumber++;
                }else if([assetType isEqualToString:ALAssetTypeUnknown]){
                    DDLogInfo(@"Unknow AssetType");
                }
            }];
        } else {
            //stop
             DDLogInfo(@"stop");
             dispatch_async(dispatch_get_main_queue(), ^(void) {
                _scanCompleted();
             });
        }

    } failureBlock:^(NSError *error) {
        DDLogError(@"Enumerate the asset groups failed.");
    }];

}


- (void)iPodLibraryDidChange:(NSNotification*)changeNotification
{
    [self loadMusic];
}

- (void) buildMonitorChanged
{

    //monitor music changed
    MPMediaLibrary *iPodLibrary = [MPMediaLibrary defaultMediaLibrary];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iPodLibraryDidChange:)
                                                 name:MPMediaLibraryDidChangeNotification object:nil];
    [iPodLibrary beginGeneratingLibraryChangeNotifications];

    //monitor video and photo changed
    ALAssetsLibrary * assetsLibrary = [LocalMediaManager shagedAssetsLibrary];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(assetsLibraryDidChange:)
                                                 name:ALAssetsLibraryChangedNotification
                                               object:assetsLibrary];

}


- (void) loadMusic
{
    musicNumber = 0;
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
   // musicNumber = [[songsQuery items] count];
   // songsArray = [mysongsQuery items];
    for(MPMediaItem *song in [songsQuery items]){
        NSURL *url = [song valueForProperty:MPMediaItemPropertyAssetURL];
        if(url != nil) musicNumber++;
    }

    //
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        _scanCompleted();
    });
}


@end
