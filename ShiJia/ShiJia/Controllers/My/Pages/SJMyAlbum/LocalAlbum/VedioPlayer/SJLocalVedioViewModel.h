//
//  SJLocalVedioViewModel.h
//  ShiJia
//
//  Created by 峰 on 16/8/16.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJLocalVedioViewModel : NSObject
@property (nonatomic, strong) RACSubject *dataSourceSubject;

/**
 * 加载本地视频文件
 */
-(void)loadLocalVediosFiles;
/**
 *  投屏Signal
 */
-(RACSignal *)screenCurrentVedioToTV:(NSInteger)index;

@end
