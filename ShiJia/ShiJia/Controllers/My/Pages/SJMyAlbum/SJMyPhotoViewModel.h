//
//  SJMyPhotoViewModel.h
//  ShiJia
//
//  Created by 峰 on 16/8/31.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJAlbumModel.h"


@interface SJMyPhotoViewModel : NSObject

@property (nonatomic, strong) RACSubject *photoModelSubject;


-(void)getGroup;
/**
 *  获取用户的云相册 加上本地相册
 *
 *  @param model
 *
 *  @return
 */
-(RACSignal *)getUserCloudSingle:(SJAlbumRequestModel *)model;


-(RACSignal *)localAlbumSingle;


@end
