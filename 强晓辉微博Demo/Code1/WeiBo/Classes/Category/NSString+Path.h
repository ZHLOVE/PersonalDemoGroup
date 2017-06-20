//
//  NSString+Path.h
//  WeiBo
//
//  Created by student on 16/5/3.
//  Copyright © 2016年 BNG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Path)

//生成沙盒路径/Documents/文件名
- (NSString *)docPath;
//生成沙河路径/cache/文件名
- (NSString *)cachePath;
// 生成 沙盒路径/tmp/文件名
- (NSString *)tmpPath;
@end
