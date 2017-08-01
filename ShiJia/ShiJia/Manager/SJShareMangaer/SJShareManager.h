//
//  SJShareManager.h
//  ShiJia
//
//  Created by 峰 on 16/10/11.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//
// 除了视加好友分享 
#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "SJShareMessage.h"
#import "UIWindow+PazLabs.h"
#import <MessageUI/MessageUI.h>

typedef void(^shareResponseBlock)(NSError *error,BOOL success);

@interface SJShareManager : NSObject <MFMessageComposeViewControllerDelegate> 

@property (nonatomic, copy) shareResponseBlock shareresponseblock;

/**
 *  分享
 *
 *  @param params
 *  @param platformType
 */
-(void)shareObject:(SJShareMessage *)params;



@end
