//
//  SJLiveTVViewModel.h
//  ShiJia
//
//  Created by yy on 16/7/28.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"

typedef NS_ENUM(NSInteger, SJMessageType){
    SJMessageTypePrivate,
    SJMessageTypePublic
};

@interface SJLiveTVViewModel : NSObject <IFlySpeechRecognizerDelegate>

@property (nonatomic, assign) SJMessageType messageType;
@property (nonatomic, copy) void (^didRecognizePublicMessage)(NSString *recordString);
@property (nonatomic, copy) void (^didRecognizePrivateMessage)(NSString *recordString);

- (void)iFlyStartListening:(NSData *)wavData;

@end
