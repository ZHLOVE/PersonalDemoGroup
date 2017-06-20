//
//  NSString+Path.m
//  WeiBo
//
//  Created by student on 16/5/3.
//  Copyright © 2016年 BNG. All rights reserved.
//

#import "NSString+Path.h"

@implementation NSString (Path)

- (NSString *)docPath
{
    NSArray *myPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myDocPath=myPath[0];
    NSString *filePath=[myDocPath stringByAppendingPathComponent:self];
    
    return  filePath;
}

- (NSString *)cachePath
{
    NSArray *myPath=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *myDocPath=myPath[0];
    NSString *filePath=[myDocPath stringByAppendingPathComponent:self];
    
    return  filePath;
    
}

- (NSString *)tmpPath
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:self];;
}
@end
