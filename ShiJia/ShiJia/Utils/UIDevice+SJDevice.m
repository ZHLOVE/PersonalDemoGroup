//
//  UIDevice+SJDevice.m
//  ShiJia
//
//  Created by 峰 on 2017/3/13.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "UIDevice+SJDevice.h"

@implementation UIDevice (SJDevice)


+ (UIDeviceResolution) currentResolution {
    static UIDeviceResolution dev = UIDevice_None;

    if (dev==UIDevice_None) {
        dev = [self getResolution];
    }
    return dev;
}

+ (UIDeviceResolution )getResolution{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            result = CGSizeMake(result.width * [UIScreen mainScreen].scale, result.height * [UIScreen mainScreen].scale);

            int h = MAX(result.width, result.height);//取 高度

            switch (h) {
                case 960:
                    return UIDevice_iPhoneHiRes;
                case 1136:
                    return UIDevice_iPhoneTallerHiRes;
                case 1334:
                    return UIDevice_iPhone6;
                case 2208:
                case 2001:
                    return UIDevice_iPhone6P;
                default:
                    return UIDevice_iPhoneHiRes;
            }
        } else
            return UIDevice_iPhoneStandardRes;
    } else
        return (([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
                ? UIDevice_iPadHiRes
                : UIDevice_iPadStandardRes);
}

@end
