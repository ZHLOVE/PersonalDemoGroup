//
//  Player.h
//  组合
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "def.h"
@interface Hero : NSObject

@property (nonatomic,assign) int x,y;

@property (nonatomic,assign) int hp;
@property (nonatomic,assign) int maxHp;

- (void)move:(Direction)d;

@end
