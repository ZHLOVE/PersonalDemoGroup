//
//  TaskRequest.h
//  SafeDarkVC
//
//  Created by M on 16/6/20.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TaskRequest : NSObject


/**
 *  证件照处理任务模型
 *
 *  @param img 图片
 *  @param sk  specKey
 *  @param bc  beginColor
 *  @param ec  endColor
 *
 *  @return 模型字典
 */
- (NSDictionary *)taskRequestDataWithImage:(UIImage *)img
                                   SpecKey:(NSString *)sk
                                BeginColor:(int)bc
                                  EndColor:(int)ec;

@end
