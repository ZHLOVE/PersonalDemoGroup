//
//  NetManageer.h
//  apiDemo3_block
//
//  Created by student on 16/3/29.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetManageer : NSObject


+ (void)requestInfoByPersonId:(NSString *)personId
                 successBlock:(void(^)(NSString *))successBlock
                    failBlock:(void(^)(NSError *))failBlock;


@end
