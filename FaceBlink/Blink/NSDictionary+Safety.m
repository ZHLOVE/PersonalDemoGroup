//
//  NSDictionary+Safety.m
//  Blink
//
//  Created by MBP on 2016/12/30.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "NSDictionary+Safety.h"

@implementation NSDictionary (Safety)

- (id)safeObjectForKey:(id)aKey {
    NSObject *object = self[aKey];

    if (object == [NSNull null]) {
        return nil;
    }

    return object;
}

@end
