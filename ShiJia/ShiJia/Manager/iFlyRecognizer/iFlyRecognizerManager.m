//
//  iFlyRecognizerManager.m
//  ShiJia
//
//  Created by yy on 16/7/28.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "iFlyRecognizerManager.h"

@implementation iFlyRecognizerManager

#pragma mark - Init
+ (iFlyRecognizerManager *)defaultManager
{
    static iFlyRecognizerManager *instance = nil;
    static dispatch_once_t precidate;
    dispatch_once(&precidate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end
