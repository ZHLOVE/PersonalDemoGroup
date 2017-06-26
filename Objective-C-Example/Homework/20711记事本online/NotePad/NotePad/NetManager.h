//
//  NetManager.h
//  NotePad
//
//  Created by student on 16/3/30.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NetManager : NSObject

+ (void)queryFromNet:(NSString *)urlStr
        successBlock:(void(^)(NSArray *array))successBlock
           failBlock:(void(^)(NSError *error))failBlock;

+ (void)addFromNet:(NSString *)content
           andDate:(NSString *)date
      successBlock:(void(^)(NSString *str))successBlock
         failBlock:(void(^)(NSError *error))failBlock;

+ (void)deleteFromNet:(NSString *)deleteId;
@end
