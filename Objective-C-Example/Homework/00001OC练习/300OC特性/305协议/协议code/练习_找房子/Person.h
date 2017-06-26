//
//  Person.h
//  协议
//
//  Created by niit on 16/1/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PersonDelegate <NSObject>

// 找房子
- (int)findHouse;

@end

@protocol GrilFriendProtocol <NSObject>

// 烧饭
- (void)cook;

@optional
// 洗衣服
- (void)wash;

@end

@interface Person : NSObject

@property (nonatomic,weak) id<PersonDelegate> delegate;

@property (nonatomic,weak) id<GrilFriendProtocol> girlFriend;

@end
