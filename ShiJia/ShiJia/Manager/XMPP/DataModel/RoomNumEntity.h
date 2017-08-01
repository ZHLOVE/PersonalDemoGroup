//
//  RoomNumEntity.h
//  ShiJia
//
//  Created by 蒋海量 on 16/7/13.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomNumEntity : NSObject
/**
 *  用户所属群聊房间号
 */
@property (nonatomic, copy)   NSString *roomId;
/**
 *  该房间在线人数
 */
@property (nonatomic, copy)   NSString *onlineNum;
@end
