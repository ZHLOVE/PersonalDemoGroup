//
//  ComFunc.m
//  转盘
//
//  Created by qiang on 16/3/21.
//  Copyright © 2016年 Qiangtech. All rights reserved.
//

#import "ComFunc.h"

NSUInteger alphaOffset(NSUInteger x, NSUInteger y, NSUInteger w)
{
    return y * w * 4 + x * 4 + 0;
}

// UIImage -> 颜色数组
unsigned char *getBitmapFromImage (UIImage *image)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    CGSize size = image.size;
    // void *bitmapData = malloc(size.width * size.height * 4);
    unsigned char *bitmapData = calloc(size.width * size.height * 4, 1); // Courtesy of Dirk. Thanks!
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Error: Memory not allocated!");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    CGContextRef context = CGBitmapContextCreate (bitmapData, size.width, size.height, 8, size.width * 4, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace );
    if (context == NULL)
    {
        fprintf (stderr, "Error: Context not created!");
        free (bitmapData);
        return NULL;
    }
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    CGContextDrawImage(context, rect, image.CGImage);
    unsigned char *data = CGBitmapContextGetData(context);
    CGContextRelease(context);
    
    return data;
}