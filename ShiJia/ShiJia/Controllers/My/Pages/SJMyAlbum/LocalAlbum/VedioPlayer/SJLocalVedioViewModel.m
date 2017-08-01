//
//  SJLocalVedioViewModel.m
//  ShiJia
//
//  Created by 峰 on 16/8/16.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJLocalVedioViewModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ScreenManager.h"
#import "SJLocailFileScreen.h"
#import "SJLocailFileResponseModel.h"
#import "TPIMContentModel.h"
#import "TogetherManager.h"

@interface SJLocalVedioViewModel()

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray  *dataSourceArray;
@property (nonatomic, strong) ScreenManager   *screenManager;

@end

@implementation SJLocalVedioViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataSourceSubject = [RACSubject subject];
    }
    return self;
}

-(ScreenManager *)screenManager{
    
    return [ScreenManager sharedInstance];
}

-(NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray new];
    }
    return _dataSourceArray;
}

-(ALAssetsLibrary *)assetsLibrary{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,
                  ^{
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}

#pragma mark --获取相册资源
//获取手机根目录相册下视频
-(void)filterImageWithGroup:(ALAssetsGroup *)group
{
    ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result,NSUInteger index, BOOL *stop){
        
        if (result!=NULL){
            
            if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypeVideo]){
                
                [self.dataSourceArray addObject:result];
            }
        }else{
            [_dataSourceSubject sendNext:self.dataSourceArray];
        }
    };
    [group enumerateAssetsUsingBlock:groupEnumerAtion];
}

/**
 *  获取手机系统相册
 */
-(void)loadLocalVediosFiles{
    
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            [self.dataSourceArray addObject:result];
        }else{
            [_dataSourceSubject sendNext:self.dataSourceArray];
        }
        
    };
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        ALAssetsFilter *onlyVideoFilter = [ALAssetsFilter allVideos];
        [group setAssetsFilter:onlyVideoFilter];
        if ([group numberOfAssets] > 0)
        {
            if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos) {
                [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
            }
        }else{
             [_dataSourceSubject sendNext:self.dataSourceArray];
        }
        
        if (group == nil) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
            });
        }
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:listGroupBlock failureBlock:^(NSError *error) {
        
    }];
}
/**
 *  投屏Signal
 *
 *  @param index
 *
 *  @return
 */
-(RACSignal *)screenCurrentVedioToTV:(NSInteger)index {
    
	   return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           
           
           if (![TogetherManager sharedInstance].connectedDevice) {
               
               NSString *domain = @"Domain";
               NSDictionary *userInfo = @{ NSLocalizedDescriptionKey:@"亲，没有关联设备，请添加" };
               NSError *error = [NSError errorWithDomain:domain
                                                    code:-100
                                                userInfo:userInfo];
               [subscriber sendError:error];
           }
           
           [[self screenManager] reset];
           
           WEAKSELF
           //
           ALAsset *asset = [self.dataSourceArray objectAtIndex:index];
           [SJLocailFileScreen SJ_locailFileScreen:asset
                                       andFileType:1
                                             Block:^(id result, NSError *error, CGFloat percent) {
                                                 
                                                 if (result) {
                                                     SJLocailFileResponseModel *model = (SJLocailFileResponseModel*)result;
                                                     
                                                     TPIMContentModel *xmppModel =[TPIMContentModel new];
                                                     xmppModel.playerType = @"video";
                                                     xmppModel.action = @"play";//rotateL rotateR
                                                     xmppModel.url = [NSString stringWithFormat:@"%@",model.url];
                                                     
                                                     [weakSelf.screenManager remoteLoacalFileWith:xmppModel andType:1];
                                                     
                                                 }
                                                 if (error) {
                                                     [subscriber sendError:error];
                                                 }
                                             }];
           
           self.screenManager.remoteLoacalFileBlock = ^(BOOL isSuccess){
               if (isSuccess) {
                   [subscriber sendCompleted];
               }else{
                   NSString *domain = @"Domain";
                   NSDictionary *userInfo = @{ NSLocalizedDescriptionKey:@"投屏失败" };
                   NSError *error = [NSError errorWithDomain:domain
                                                        code:-100
                                                    userInfo:userInfo];
                   [subscriber sendError:error];
               }
           };
           return [RACDisposable disposableWithBlock:^{
               //销毁信号-----
           }];
       }];
}




@end
