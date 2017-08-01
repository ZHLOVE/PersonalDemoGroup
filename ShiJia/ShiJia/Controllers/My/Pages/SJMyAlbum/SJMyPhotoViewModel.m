//
//  SJMyPhotoViewModel.m
//  ShiJia
//
//  Created by 峰 on 16/8/31.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJMyPhotoViewModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SJAlbumNetWork.h"
#import "HiTVGlobals.h"
#import "TPIMAlertView.h"
#import <Photos/Photos.h>
#import "LocalMediaManager.h"


@interface SJMyPhotoViewModel ()

@property (nonatomic, strong) NSMutableArray *albumsArray;
@property (nonatomic, strong) CloudAlbumModel *localModel;

//@property (nonatomic, strong) NSMutableArray <UserEntity *>*friendModels;

@end

@implementation SJMyPhotoViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _photoModelSubject = [RACSubject subject];
        [self getAlbumRight];
    }
    return self;
}

- (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,
                  ^{
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}

-(NSMutableArray *)albumsArray{
    if (!_albumsArray) {
        _albumsArray = [NSMutableArray new];
    }
    return _albumsArray;
}
/**
 *  获取本地相册
 */
-(void)getGroup{
//    WEAKSELF

    ALAssetsLibraryAccessFailureBlock failureblock =^(NSError *myerror){

        if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
            UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请前往设置->隐私->相册授权应用访问相册权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    };
    ALAssetsLibraryGroupsEnumerationResultsBlock libraryGroupsEnumeration = ^(ALAssetsGroup* group,BOOL* stop){
        if (group!=nil){
            if ([[[group valueForProperty:ALAssetsGroupPropertyType] description] isEqualToString:@"16"]) {
                UIImage *image =[UIImage imageWithCGImage:group.posterImage];
                _localModel = [[CloudAlbumModel alloc]init];
                _localModel.name = @"本地相册";
                _localModel.albumType = 1;
                _localModel.imageV = image;
            }
        }
    };

    [[self defaultAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupAll
                                               usingBlock:libraryGroupsEnumeration
                                             failureBlock:failureblock];
}

-(void)getAlbumRight{


    LocalMediaManager *manager = [LocalMediaManager shared];

    [manager setScanCompleted:^{
        [self getGroup];
    }];

    [manager loadMediaLibrary];

}

-(RACSignal *)localAlbumSingle{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        ALAssetsLibraryAccessFailureBlock failureblock =^(NSError *myerror){

            [subscriber sendError:myerror];
        };
        ALAssetsLibraryGroupsEnumerationResultsBlock libraryGroupsEnumeration = ^(ALAssetsGroup* group,BOOL* stop){
            if (group!=nil){
                if ([[[group valueForProperty:ALAssetsGroupPropertyType] description] isEqualToString:@"16"]) {
                    UIImage *image =[UIImage imageWithCGImage:group.posterImage];
                    _localModel = [[CloudAlbumModel alloc]init];
                    _localModel.name = @"本地相册";
                    _localModel.albumType = 1;
                    _localModel.imageV = image;

                    //                [weakSelf.photoModelSubject sendNext:_localModel];

                    [subscriber sendNext:_localModel];
                }
            }
        };

        [[self defaultAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupAll
                                                   usingBlock:libraryGroupsEnumeration
                                                 failureBlock:failureblock];
        return [RACDisposable disposableWithBlock:^{
            //销毁信号-----
        }];
    }];
}

/**
 *  获取云相册
 */

-(RACSignal *)getUserCloudSingle:(SJAlbumRequestModel *)model{

    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {


        [SJAlbumNetWork SJ_AlbumQueryAlbumRequest:model
                                            Block:^(id result, NSString *error) {
                                                if (error) {
                                                    if (self.localModel) {
                                                        [self.albumsArray addObject:self.localModel];
                                                    }

                                                    [subscriber sendNext:_albumsArray];
                                                }else{

                                                    NSArray *models = [CloudAlbumModel mj_objectArrayWithKeyValuesArray:result[@"albumList"]];

                                                    for (CloudAlbumModel *model in models) {
                                                        model.name =[NSString stringWithFormat:@"%@家的相册",[SJAlbumNetWork getFriendName:model.uid]];



                                                        if (model.coverUrl) {
                                                            model.coverUrl = [model.coverUrl hasSuffix:@"!thum"] ?model.coverUrl:model.coverUrl;

                                                        }

                                                        [self.albumsArray addObject:model];
                                                    }
                                                    if (self.localModel) {
                                                        [self.albumsArray addObject:self.localModel];
                                                    }
                                                    [subscriber sendNext:_albumsArray];
                                                    
                                                }
                                            } ];
        
        return [RACDisposable disposableWithBlock:^{
            //销毁信号-----
        }];
    }];
}

@end
