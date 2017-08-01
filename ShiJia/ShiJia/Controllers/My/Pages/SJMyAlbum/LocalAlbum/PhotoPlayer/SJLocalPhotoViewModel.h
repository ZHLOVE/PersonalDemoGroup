//
//  SJLocalPhotoViewModel.h
//  ShiJia
//
//  Created by 峰 on 16/7/21.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJLocalPhotoViewModel : NSObject

@property (nonatomic, strong) RACSubject *dataSourceSubject;

/**
 * 加载本地相片文件
 */
-(void)loadLocalPhotoFiles;
/**
 *  投屏Signal
 */
-(RACSignal *)screenCurrentPhotoToTV:(ALAsset *)asset andMediaType:(Media_TYPE)type;
@end
