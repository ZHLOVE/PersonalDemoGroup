//
//  UIImage+ColorAtPixel.h
//  Blue-toothLight
//
//  Created by mazg on 15/6/20.
//  Copyright (c) 2015年 mazg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ColorAtPixel)

- (UIColor *)colorAtPixel:(CGPoint)point;

@end
