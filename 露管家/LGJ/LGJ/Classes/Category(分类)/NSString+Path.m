//
//  NSString+Path.m
//  Weibo
//
//  Created by qiang on 5/3/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "NSString+Path.h"

@implementation NSString (Path)

- (NSString *)docPath
{
    NSArray *myPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myDocPath=myPath[0];
    NSString *filePath=[myDocPath stringByAppendingPathComponent:self];
    
    NSLog(@"%@",filePath);
    return  filePath;
}

- (NSString *)cachePath
{
    NSArray *myPath=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *myDocPath=myPath[0];
    NSString *filePath=[myDocPath stringByAppendingPathComponent:self];
        NSLog(@"%@",filePath);
    return  filePath;
    
}

- (NSString *)tmpPath
{
    NSLog(@"%@",[NSTemporaryDirectory() stringByAppendingPathComponent:self]);
    return [NSTemporaryDirectory() stringByAppendingPathComponent:self];
}

@end
