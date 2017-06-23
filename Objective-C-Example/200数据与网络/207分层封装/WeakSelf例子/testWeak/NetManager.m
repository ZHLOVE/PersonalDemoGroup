//
//  NetManager.m
//  testWeak
//
//  Created by niit on 16/3/30.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "NetManager.h"

@implementation NetManager


+ (void)requestMovieListWithSuccessBlock:(void (^)(NSArray *list))successBlock
                               failBlock:(void (^)(NSError *error))failBlock
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(arc4random()%3 != 0)
        {
            NSArray *arr = @[@"蝙蝠侠",@"超人",@"abc",@"钢铁侠",@"蜘蛛侠",@"私事"];
            successBlock(arr);
        }
        else
        {
            NSError *error = [NSError errorWithDomain:@"com.niit.testweak" code:1 userInfo:@{NSLocalizedDescriptionKey:@"访问失败"}];
            failBlock(error);
        }
    });
}
@end
