//
//  HomeCallBackDelegate.h
//  ShiJia
//
//  Created by 峰 on 2017/2/17.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "homeModel.h"

@protocol CallBackDelegate <NSObject>

@optional
/**
 *  @brief
 *
 *  @param model
 *  @param index
 *  @param type  1 需要用 categoryId 跳转的
 */
-(void)clickHomeBricksCallBackWith:(homeModel *)model andContents:(contents *)contents andType:(NSInteger)type;


@end

@protocol HomeDelegate <NSObject>

@optional

-(void)HomeBricksCallBackWith:(homeModel *)model andContents:(contents *)contents andType:(NSInteger)type;

@end

@protocol MainDelegate <NSObject>

@optional

-(void)MainBricksCallBackWith:(homeModel *)model andContents:(contents *)contents andType:(NSInteger)type;
-(void)hotSpotCallBack;

@end
