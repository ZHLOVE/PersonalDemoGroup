//
//  UIImage+RGBAConv.m
//  junyucamera
//
//  Created by dexter on 12-11-20.
//  Copyright (c) 2012年 junyu. All rights reserved.
//

#import "UIImage+RGBAConv.h"

@implementation UIImage (RGBAConv)

- (void)getRGBA:(uint8_t*) buf alpha:(BOOL) alpha
{
    //Last+Little 排布是 A B G R
    //First 排布是 A R G B
    //Last 排布是 R G B A
    //去A函数只去第一个bytes
    CGImageRef imageRef = [self CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(buf, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 (alpha?kCGImageAlphaPremultipliedLast:kCGImageAlphaNoneSkipLast)|kCGBitmapByteOrder32Little);
    //kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
}

//void ReleaseBuffer(void *pixel, const void *data, size_t size)
//{
//	NSLog(@"release");
//free((void*)data);
//}

+ (UIImage*)getImageFromRGBA:(uint8_t*) buf width:(int) width height:(int)height alpha:(BOOL) alpha
{
    //24位只支持 R G B
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    //CGDataProviderCreateWithCFData
    //尝试还原原来的非提供者方法
    //使用提供者如果不再次绘制则原来的缓存变动会变成黑图
    //	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buf, bytesPerRow*height, NULL);//ReleaseBuffer
    //	CGImageRef img = CGImageCreate(width, height,
    //								   bitsPerComponent, bytesPerPixel*bitsPerComponent, bytesPerRow, colorSpace,
    //								   (alpha?kCGImageAlphaPremultipliedLast:kCGImageAlphaNoneSkipLast)|kCGBitmapByteOrder32Little,
    //								   provider, NULL, true, kCGRenderingIntentDefault);
    
    CGContextRef context = CGBitmapContextCreate(buf, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 (alpha?kCGImageAlphaPremultipliedLast:kCGImageAlphaNoneSkipLast)|kCGBitmapByteOrder32Little);
    //kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    //	CGContextDrawImage(context, CGRectMake(0, 0, width, height), img);
    //	CGImageRelease(img);
    //	CGDataProviderRelease(provider);
    
    CGImageRef img = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    UIImage* ret=[UIImage imageWithCGImage:img];
    CGImageRelease(img);
    
    return ret;
}

- (UIImage *)fixOrientationWithSize:(CGSize)newSize// flip:(BOOL)flip
{
    //    NSArray *pp=@[@"上",@"下",@"左",@"右",@"上次",@"下次",@"左次",@"右次"];
    //	NSLog(@"%@",pp[self.imageOrientation]);
    
    //int tmparr[]={4,5,7,6};
    int orientation=self.imageOrientation; //flip?tmparr[self.imageOrientation]:
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp && CGSizeEqualToSize(newSize,self.size))// && !flip)
        return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (orientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (orientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, newSize.width, newSize.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    if(newSize.width*newSize.height > self.size.width*self.size.height)
        CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);
    
    if(orientation != UIImageOrientationUp)
        CGContextConcatCTM(ctx, transform);
    switch (orientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,newSize.height,newSize.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,newSize.width,newSize.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//裁减图片中心圆形部分
-(UIImage*) circleImage:(CGFloat)inset {
    UIGraphicsBeginImageContext(self.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, self.size.width - inset * 2.0f, self.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [self drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

-(unsigned char *)requestImagePixelData {
    CGImageRef img = [self CGImage];
    CGSize size = [self size];
    
    //使用上面的函数创建上下文
    CGContextRef cgctx = CreateRGBABitmapContext(img);
    CGRect rect = {{0,0},{size.width, size.height}};
    
    //将目标图像绘制到指定的上下文，实际为上下文内的bitmapData。
    CGContextDrawImage(cgctx, rect, img);
    unsigned char *data = CGBitmapContextGetData (cgctx);
    
    //释放上面的函数创建的上下文
    CGContextRelease(cgctx);
    
    return data;
}

static CGContextRef CreateRGBABitmapContext (CGImageRef inImage)
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData; //内存空间的指针，该内存空间的大小等于图像使用RGB通道所占用的字节数。
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    size_t pixelsWide = CGImageGetWidth(inImage); //获取横向的像素点的个数
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    bitmapBytesPerRow    = (int)(pixelsWide * 4); //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit(0-255)的空间
    bitmapByteCount    = (int)(bitmapBytesPerRow * pixelsHigh); //计算整张图占用的字节数
    
    colorSpace = CGColorSpaceCreateDeviceRGB();//创建依赖于设备的RGB通道
    //分配足够容纳图片字节数的内存空间
    bitmapData = malloc( bitmapByteCount );
    //创建CoreGraphic的图形上下文，该上下文描述了bitmaData指向的内存空间需要绘制的图像的一些绘制参数
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast);
    //Core Foundation中通过含有Create、Alloc的方法名字创建的指针，需要使用CFRelease()函数释放
    CGColorSpaceRelease( colorSpace );
    return context;
}

//裁剪图片
- (UIImage*)cropImageWithRect:(CGRect)cropRect {
    CGRect drawRect = CGRectMake(-cropRect.origin.x , -cropRect.origin.y, self.size.width * self.scale, self.size.height * self.scale);
    
    UIGraphicsBeginImageContext(cropRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, CGRectMake(0, 0, cropRect.size.width, cropRect.size.height));
    
    [self drawInRect:drawRect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//扩大边界
- (UIImage*)resizeWith:(CGSize)newSize InRect:(CGRect)inRect {
    UIGraphicsBeginImageContext(newSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, CGRectMake(0, 0, newSize.width, newSize.height));
    
    [self drawInRect:inRect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage*)resizeWith:(CGSize)newSize InRect:(CGRect)inRect withColor:(UIColor *)blankColor {
    UIGraphicsBeginImageContext(newSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, CGRectMake(0, 0, newSize.width, newSize.height));
    
    //纯色背景
    [blankColor setFill];
    CGContextFillRect(context, CGRectMake(0, 0, newSize.width, newSize.height));
    
    [self drawInRect:inRect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//角度转弧度
CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
};

//旋转指定角度
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)scalingToSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [self drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
