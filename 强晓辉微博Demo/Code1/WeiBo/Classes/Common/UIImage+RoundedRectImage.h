//
//  UIImage+RoundedRectImage.h
//  QRCode
//
//  Created by qiang on 4/27/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RoundedRectImage)
+ (UIImage *)createRoundedRectImage:(UIImage *)image withSize:(CGSize)size withRadius:(NSInteger)radius;
@end
