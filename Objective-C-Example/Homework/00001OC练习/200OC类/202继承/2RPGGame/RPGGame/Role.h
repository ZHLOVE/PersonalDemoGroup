//
//  Role.h
//  RPGGame
//
//  Created by niit on 15/12/29.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "def.h"

@interface Role : NSObject

@property (nonatomic,copy) NSString *name;
// 坐标
@property (nonatomic,assign) int x,y;

// HP
@property (nonatomic,assign) int hp;
@property (nonatomic,assign) int maxHp;

// 往某个方向移动一步
- (void)move:(Direction)d;

// 走一步
- (void)walkOneStep;

@end
