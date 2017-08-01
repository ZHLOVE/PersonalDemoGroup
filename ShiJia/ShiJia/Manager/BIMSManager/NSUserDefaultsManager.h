//
//  NSUserDefaultsManager.h
//  HiTV
//
//  Created by 蒋海量 on 15/3/3.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaultsManager : NSObject
/**
 *  NSUserDefaults保存数据
 *
 *  @param object   保存对象
 *  @param key      键值
 */
+(void)saveObject:(id)object forKey:(NSString *)key;

/**
 *  NSUserDefaults取出数据
 *
 *  @param key      键值
 */
+(id)getObjectForKey:(NSString *)key;

/**
 *  NSUserDefaults删除数据
 *
 *  @param key      键值
 */
+(void)deleteObjectForKey:(NSString *)key;
@end
