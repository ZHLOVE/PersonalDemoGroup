//
//  UIImage+Orientation.h
//  ShiJia
//
//  Created by 峰 on 16/7/29.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Orientation)
- (UIImage *)fixOrientation;
- (UIImage *)normalizedImage;
- (UIImage *)imageRotate:(UIImage*)image rotation:(UIImageOrientation)orient;
- (UIImage *)receiveThumbnailImageByUrl:(NSURL *)videoURL atTime:(NSTimeInterval)time;
@end
