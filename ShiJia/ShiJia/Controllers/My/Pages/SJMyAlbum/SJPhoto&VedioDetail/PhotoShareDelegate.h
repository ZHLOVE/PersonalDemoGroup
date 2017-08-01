//
//  PhotoShareDelegate.h
//  ShiJia
//
//  Created by 峰 on 16/9/21.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoShareDelegate;


@protocol PhotoShareDelegate <NSObject>

@optional
/**
 *  分享到那个平台
 *
 *  @param name 平台名字
 */
- (void)PhotoShareToSocailName:(Platform)name;

@optional


@end

