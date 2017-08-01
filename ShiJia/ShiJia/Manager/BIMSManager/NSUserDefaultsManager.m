//
//  NSUserDefaultsManager.m
//  HiTV
//
//  Created by 蒋海量 on 15/3/3.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "NSUserDefaultsManager.h"

@implementation NSUserDefaultsManager

+(void)saveObject:(id)object forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(id)getObjectForKey:(NSString *)key
{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return value;
}

+(void)deleteObjectForKey:(NSString *)key{
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
