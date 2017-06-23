//
//  Video.h
//  Net2
//
//  Created by niit on 16/3/28.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

//id":2,"image":"resources/images/minion_02.png","length":12,"name":"小黄人 第02部","url":"resources/videos/minion_02.mp4"
@property (nonatomic,copy) NSString *sid,*image,*name,*url;
@property (nonatomic,assign) int length;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)videoWithDict:(NSDictionary *)dict;

@end
