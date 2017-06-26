//
//  Video.h
//  Net2
//
//  Created by student on 16/3/29.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

@property (nonatomic,copy) NSString *sid,*image,*name,*url;
@property (nonatomic,assign) int length;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)videoWithDict:(NSDictionary *)dict;

@end
