# UIButton相关技巧

##UIButton 控制UIImage自由改变大小
```objc
[btn setContentMode:UIViewContentModeScaleAspectFit];
 
[btn setImage:[titleimage transformWidth:90 height:125] forState:UIControlStateNormal];
```

//设置内容垂直或水平显示位置

```objc
[btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
[btn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
```


```objc 
//
//  UIImageCategory.m
//  CategorySample
//
//  Created by yile on 3/29/09.
//  Copyright 2009 Quoord. All rights reserved.
//

#import "UIImageCategory.h"

@implementation UIImage (Category)

// --------------------------------------------------
// Resize an image
// --------------------------------------------------
- (UIImage*)transformWidth:(CGFloat)width 
height:(CGFloat)height {
 
CGFloat destW = width;
CGFloat destH = height;
CGFloat sourceW = width;
CGFloat sourceH = height;
 
CGImageRef imageRef = self.CGImage;
CGContextRef bitmap = CGBitmapContextCreate(NULL, 
destW, 
destH,
CGImageGetBitsPerComponent(imageRef), 
4*destW, 
CGImageGetColorSpace(imageRef),
(kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
 
CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef);
 
CGImageRef ref = CGBitmapContextCreateImage(bitmap);
UIImage *resultImage = [UIImage imageWithCGImage:ref];
CGContextRelease(bitmap);
CGImageRelease(ref);
 
return resultImage;
}
@end

```