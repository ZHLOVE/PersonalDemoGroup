//
//  UMengManager.h
//  ShiJia
//
//  Created by 蒋海量 on 2017/3/17.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

/**
 *  友盟事件统计
*/

#import <Foundation/Foundation.h>

@interface UMengManager : NSObject
/**
 *  友盟初始化
*/
+(void)start;

/**
 *  自定义事件
 */
+(void)event:(NSString *)eventId;

/**
 *  自定义带参数事件
 */
+(void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;

@end
