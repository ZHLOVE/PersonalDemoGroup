//
//  Sign.h
//  SafeDarkVC
//
//  Created by M on 16/6/20.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sign : NSObject

/**
 *  生成签名
 *
 *  @return 签名字典
 */
- (NSDictionary *)creatSignWithAppKey:(NSString *)appKey
                            appSecret:(NSString *)appSecret
                               params:(NSDictionary *)params;


@end
