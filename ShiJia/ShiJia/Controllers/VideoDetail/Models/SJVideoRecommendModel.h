//
//  SJVideoRecommendModel.h
//  ShiJia
//
//  Created by yy on 16/6/20.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//
/*
 {
 content = ();
 posterAddr = "http://images.is.ysten.com:8080/images/ysten/images/lanmudianbo/DSJ/REBO/HXS.jpg";
 reason = "\U6700\U8fd1\U6b63\U5728\U70ed\U64ad";
 resultId = 0;
 resultType = 0;
 verticalPosterAddr = "http://images.is.ysten.com:8080/images/ysten/images/lanmudianbo/DSJ/REBO/HXS.jpg";
 }
 */
#import <Foundation/Foundation.h>

@class SJVideoRecommendItemModel;

@interface SJVideoRecommendModel : NSObject

@property (nonatomic, strong) NSArray <SJVideoRecommendItemModel *> *content;
@property (nonatomic, copy)   NSString *posterAddr;
@property (nonatomic, copy)   NSString *reason;
@property (nonatomic, assign) NSInteger resultId;
@property (nonatomic, assign) NSInteger resultType;
@property (nonatomic, copy)   NSString *verticalPosterAddr;

@end
