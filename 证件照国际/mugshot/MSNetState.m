//
//  MSNetState.m
//  mugshot
//
//  Created by Venpoo on 15/9/28.
//  Copyright (c) 2015年 junyu. All rights reserved.
//


#import "MSNetState.h"
#import "Reachability.h"

@interface MSNetState ()
@end

@implementation MSNetState

+(BOOL) isConnectionAvailable{
    BOOL isExistenceNetwork = NO;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            NSLog(@"3G");
            break;
    }
    return isExistenceNetwork;
}
@end