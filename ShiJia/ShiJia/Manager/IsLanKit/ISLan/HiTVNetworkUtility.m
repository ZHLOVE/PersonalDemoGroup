//
//  HiTVNetworkUtility.m
//  HiTV
//
//  Created by lanbo zhang on 1/13/15.
//  Copyright (c) 2015 Lanbo Zhang. All rights reserved.
//

#import "HiTVNetworkUtility.h"
#import <ifaddrs.h>
#import <sys/socket.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <net/if.h>
#import <netdb.h>


@implementation HiTVNetworkUtility

+ (NSString*)retrieveBroadcastSubNetMask{
    NSString* address = nil;
#if !TARGET_IPHONE_SIMULATOR
    const char* primaryInterface = "en0";  // WiFi interface on iOS
#endif
    struct ifaddrs* list;
    if (getifaddrs(&list) >= 0) {
        for (struct ifaddrs* ifap = list; ifap; ifap = ifap->ifa_next) {
#if TARGET_IPHONE_SIMULATOR
            if (strcmp(ifap->ifa_name, "en0") && strcmp(ifap->ifa_name, "en1"))  // Assume en0 is Ethernet and en1 is WiFi since there is no way to use SystemConfiguration framework in iOS Simulator
#else
                if (strcmp(ifap->ifa_name, primaryInterface))
#endif
                {
                    continue;
                }
            if ((ifap->ifa_flags & IFF_UP) && (ifap->ifa_addr->sa_family == AF_INET)) {
                address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)ifap->ifa_dstaddr)->sin_addr)];
                
                break;
            }
        }
        freeifaddrs(list);
    }
    return address;
    
}

@end
