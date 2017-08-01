//
//  SJGetUserDataAPI.h
//  ShiJia
//
//  Created by yy on 16/5/13.
//  Copyright © 2016年 Ysten. All rights reserved.
//

#import "BaseAFHTTPManager.h"

@interface SJGetUserDataAPI : BaseAFHTTPManager

+ (void)getFriendListWithSuccess:(void (^)(NSArray <UserEntity *> *responseObject))success
                          failed:(void (^)(NSString *error))failure;

@end
