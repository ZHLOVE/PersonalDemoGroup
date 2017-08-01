//
//  CHKeychain.h
//  HiTV
//
//  Created by 蒋海量 on 15/3/2.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHKeychain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
//+ (void)deleteData:(NSString *)service;
@end
