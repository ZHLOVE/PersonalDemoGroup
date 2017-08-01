//
//  AddFriend.h
//  logDemo
//
//  Created by MccRee on 2017/7/22.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

/**
 添加好友
 */
@interface AddFriend : EventModel

@property(nonatomic,assign) int result;
@property(nonatomic,copy) NSString *friend_phone;

@end
