//
//  CornerEntity.h
//  ShiJia
//
//  Created by 蒋海量 on 16/10/28.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CornerEntity : NSObject
@property (nonatomic, strong) NSString* cornerImg;
@property (nonatomic, strong) NSString* position;

- (instancetype)initWithDict:(NSDictionary*)dict;

@end
