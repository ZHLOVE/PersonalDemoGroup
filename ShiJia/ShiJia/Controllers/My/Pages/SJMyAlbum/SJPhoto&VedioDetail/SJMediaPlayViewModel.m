//
//  SJMediaPlayViewModel.m
//  ShiJia
//
//  Created by 峰 on 16/9/5.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJMediaPlayViewModel.h"

@implementation SJMediaPlayViewModel

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

@end
