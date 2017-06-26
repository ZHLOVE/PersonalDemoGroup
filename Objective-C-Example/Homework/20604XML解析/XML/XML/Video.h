//
//  Video.h
//  JSON
//
//  Created by niit on 16/3/25.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

@property (nonatomic,assign) int videoId;
@property (nonatomic,copy) NSString *image,*name,*url;
@property (nonatomic,assign) int length;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)videoWithDict:(NSDictionary *)dict;
@end
