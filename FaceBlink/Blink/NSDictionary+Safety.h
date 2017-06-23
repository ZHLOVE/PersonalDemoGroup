//
//  NSDictionary+Safety.h
//  Blink
//
//  Created by MBP on 2016/12/30.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Safety)

- (id)safeObjectForKey:(id)aKey;

@end
