//
//  SJShareMessage.h
//  ShiJia
//
//  Created by 峰 on 16/10/11.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJShareMessage : NSObject

@property (nonatomic, assign) Platform platform;
@property (nonatomic, assign) shareMessageType messageType;
@property (nonatomic, strong) NSString *messageTitle;
@property (nonatomic, strong) NSString *messageContent;
@property (nonatomic, strong) NSString *messageThumbImageUrl;
@property (nonatomic, strong) NSString *messageSourceLink;
@property (nonatomic, strong) UIImage  *messageThumbImage;


@end
