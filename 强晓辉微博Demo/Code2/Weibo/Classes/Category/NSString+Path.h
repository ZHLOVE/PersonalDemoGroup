//
//  NSString+Path.h
//  Weibo
//
//  Created by qiang on 5/3/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Path)

// 生成 沙盒路径/Documents/文件名
- (NSString *)docPath;
// 生成 沙盒路径/cache/文件名
- (NSString *)cachePath;
// 生成 沙盒路径/tmp/文件名
- (NSString *)tmpPath;

@end
