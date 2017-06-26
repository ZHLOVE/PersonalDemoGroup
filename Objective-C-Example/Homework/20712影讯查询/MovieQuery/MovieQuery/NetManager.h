//
//  NetManager.h
//  MovieQuery
//
//  Created by student on 16/3/31.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetManager : NSObject


+ (void)queryCinemaFromNet:(NSString *)urlStr
              successBlock:(void(^)(NSArray *array))successBlock
                 failBlock:(void(^)(NSError *error))failBlock;

+ (void)queryMovieWithCinemaID:(NSString *)cinemaid
                  successBlock:(void(^)(NSArray *array))successBlock
                     failBlock:(void(^)(NSError *error))failBlock;
@end
