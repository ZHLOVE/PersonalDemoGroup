//
//  ChooseCategoryDelegate.h
//  ShiJia
//
//  Created by 峰 on 2016/12/30.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol ChooseCategoryDelegate <NSObject>

@optional

-(void)receiveCategoryData:(NSArray *)array;

-(void)receiveCategoryError:(NSError *)error;

-(void)receiveSearchData:(NSArray *)array;

@end
