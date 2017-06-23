//
//  NetManager.h
//  testWeak
//
//  Created by niit on 16/3/30.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetManager : NSObject

+ (void)requestMovieListWithSuccessBlock:(void (^)(NSArray *list))successBlock
                               failBlock:(void (^)(NSError *error))failBlock;


@end
