//
//  SJLocalPhotoViewModel.m
//  ShiJia
//
//  Created by 峰 on 16/7/21.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJLocalPhotoViewModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ScreenManager.h"
#import "SJLocailFileScreen.h"
#import "SJLocailFileResponseModel.h"
#import "TPIMContentModel.h"

@interface SJLocalPhotoViewModel()

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray  *dataSourceArray;
@property (nonatomic, strong) ScreenManager   *screenManager;


@end

@implementation SJLocalPhotoViewModel

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
//获取手机根目录相册下的图片
-(void)filterImageWithGroup:(ALAssetsGroup *)group
{
    ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result,NSUInteger index, BOOL *stop){
        
        if (result!=NULL){
            
            if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto]){
                
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
-(void)loadLocalPhotoFiles{
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:^(ALAssetsGroup *group, BOOL *stop){
        if (group) {
            [self filterImageWithGroup:group];
        }
    } failureBlock:^(NSError *error) {
        NSString *domain = @"Error";
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey:@"获取失败" };
        error = [NSError errorWithDomain:domain
                                    code:-101
                                userInfo:userInfo];
        
        [_dataSourceSubject sendError:error];
    }];
}
/**
 *  投屏Signal
 *
 *  @param index
 *
 *  @return
 */
-(RACSignal *)screenCurrentPhotoToTV:(NSInteger)index {
    
	   return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           
           [[self screenManager] reset];
           WEAKSELF
           ALAsset *asset = [self.dataSourceArray objectAtIndex:index];
           
           [SJLocailFileScreen SJ_locailFileScreen:asset
                                       andFileType:0
                                             Block:^(id result, NSError *error, CGFloat percent) {
                                                 
                                                 if (result) {
                                                     SJLocailFileResponseModel *model = (SJLocailFileResponseModel*)result;
                                                     
                                                     TPIMContentModel *xmppModel =[TPIMContentModel new];
                                                     xmppModel.playerType = @"photo";
                                                     xmppModel.action = @"play";
                                                     xmppModel.url = [NSString stringWithFormat:@"%@",model.url];
                                                     
                                                     [weakSelf.screenManager remoteLoacalFileWith:xmppModel andType:2];
                                                     
                                                 }
                                                 if (error) {
                                                     
                                                     [subscriber sendError:error];
                                                 }
                                             }];
           
           
           [self screenManager].remoteLoacalFileBlock = ^(BOOL isSuccess){
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
