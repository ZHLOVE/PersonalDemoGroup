//
//  Game.h
//  组合
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Hero.h"
#import "Monster.h"

@interface Game : NSObject

@property (nonatomic,strong) Hero *hero;
@property (nonatomic,strong) Monster *monster;

- (void)play;

@end
