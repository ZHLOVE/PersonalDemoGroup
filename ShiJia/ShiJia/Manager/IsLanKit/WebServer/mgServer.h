//
//  httpSrv.h
//  httpSrv
//
//  Created by Jian Huang on 8/22/16.
//  Copyright © 2016 Jian Huang. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "httpSrv.h"

@interface mgServer : NSObject
+ (void)start;
+ (void)stop;
+ (bool)updateSrvInfo:(SrvInfoType) type : (NSString*) value;
+ (NSString*)currentPort;

+ (void)sendMsg:(NSData*) data andHost:(NSString*) host;

#if 0
+ (void)startDlna;
+ (void)stopDlna;
+ (void)broadcast2Tv:(NSString*) uuid :(NSString*)url;
+ (void)doAction:(ActionType) type :(NSString*) uuid :(NSString*)pos;
#endif
@end
