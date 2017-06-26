//
//  Movie.h
//  MovieQuery
//
//  Created by 马千里 on 16/3/31.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property(nonatomic,copy)NSString *movieId,*movieName,*pic_url;
@property (nonatomic,copy)NSString *hall,*price,*time;
@property(nonatomic,weak) NSArray *broadcast; //要写上



- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)dataWithDict:(NSDictionary *)d;

@end
