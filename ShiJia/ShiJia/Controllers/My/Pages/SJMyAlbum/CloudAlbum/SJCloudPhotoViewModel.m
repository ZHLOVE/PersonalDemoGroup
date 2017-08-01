//
//  SJCloudPhotoViewModel.m
//  ShiJia
//
//  Created by 峰 on 16/9/3.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJCloudPhotoViewModel.h"

@implementation SJCloudPhotoViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(RACSignal *)QueryPhotoAndVedios:(CloudRequestPhotoModel *)model {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [SJAlbumNetWork SJ_AlbumQueryPhotoRequest:model
                                            Block:^(id result, NSString *error) {
                                                if (error) {
                                                    [subscriber sendError:SJERROR(error)];
                                                }else{
                                                    NSArray *modelsArray = [CloudPhotoModel mj_objectArrayWithKeyValuesArray:result[@"resourceList"]];
                                                    
                                                    [subscriber sendNext:[modelsArray mutableCopy]];
                                                    
                                                }
                                                
                                            }];
        return [RACDisposable disposableWithBlock:^{
            //销毁信号-----
        }];
    }];
    
}

-(RACSignal *)DeletePhotoOrVedios:(DeletePhotoRequestModel *)model {

    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [SJAlbumNetWork SJ_AlbumDeletePhotoRequest:model
                                             Block:^(id result, NSString *error) {
                                                 if (error) {
                                                     [subscriber sendError:SJERROR(error)];
                                                 }else{
                                                     if ([result[@"code"] intValue]==0) {
                                                         [subscriber sendCompleted];
                                                     }else{
                                                         [subscriber sendError:SJERROR(result[@"message"])];
                                                     }
                                                     
                                                 }
                                             }];
        return [RACDisposable disposableWithBlock:^{
            //销毁信号-----
        }];
    }];
}

-(RACSignal *)AddPhotoOrVedios:(AddPhotoRequestModel *)model {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [SJAlbumNetWork SJ_AlbumAddPhotoRequest:model
                                          Block:^(id result, NSString *error) {         
                                              if (error) {
                                                  [subscriber sendError:SJERROR(error)];
                                              }else{
                                                  if ([result[@"code"] intValue]==0) {
                                                      [subscriber sendNext:@(YES)];
                                                      [subscriber sendCompleted];
                                                  }else{
                                                      [subscriber sendError:SJERROR(result[@"message"])];
                                                  }
                                                  
                                              }
                                          }];
        return [RACDisposable disposableWithBlock:^{
            //销毁信号-----
        }];
    }];
}


@end
