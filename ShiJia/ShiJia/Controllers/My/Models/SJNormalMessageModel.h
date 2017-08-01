//
//  SJNormalMessageModel.h
//  ShiJia
//
//  Created by yy on 16/4/19.
//  Copyright © 2016年 yy. All rights reserved.
//

/*
 {￼
 "from": {￼
 "jid": "p14843960@b.yst",
 "nickname": "测881",
 "uid": 14843960
 },
 "msgId": 22206,
 "read": 0,
 "time": 1453087004000,
 "title": "测881 约你一起看《[HD]催眠大师》",
 "to": [￼
 {￼
 "jid": "p14843959@b.yst",
 "nickname": "测581",
 "uid": 14843959
 }
 ],
 "type": 7
 }
 */
#import <Foundation/Foundation.h>

@class UserEntity;

@interface SJNormalMessageModel : NSObject

@property (nonatomic, strong) UserEntity *from;

@property (nonatomic, assign) NSInteger    msgId;

@property (nonatomic, assign) BOOL         read;

@property (nonatomic, assign) NSInteger    time;

@property (nonatomic,   copy) NSString    *title;

@property (nonatomic, strong) NSArray <UserEntity *> *to;

@property (nonatomic, assign) NSInteger    type;

@end
