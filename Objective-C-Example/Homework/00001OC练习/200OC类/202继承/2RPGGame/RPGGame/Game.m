//
//  Game.m
//  组合
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Game.h"

@implementation Game

// ctrl+i 自动缩进

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化的时候创建子对象
        self.monster = [[Monster alloc] init];
        self.hero = [[Hero alloc] init];
    }
    return self;
}

- (void)play
{
    while(1)
    {
        // 1 打印地图信息
        [self printMap];
        // 2 英雄走一步
        [self.hero walkOneStep];
        // 3 怪物走一步
        [self.monster walkOneStep];
        // 4 判断输赢情况
        if(self.hero.x==self.monster.x && self.hero.y == self.monster.y)
        {
            NSLog(@"游戏胜利");
            break;
        }
    }
    [self printMap];
}

// 打印地图信息
- (void)printMap
{
    for (int i=0; i<kMapSize; i++)
    {
        for (int j=0; j<kMapSize; j++)
        {
            if(self.hero.x == j && self.hero.y == i)
            {
                printf("😀");
            }
            else if(self.monster.x == j && self.monster.y == i)
            {
                printf("😈");
            }
            else
            {
                printf("◻️");
            }
        }
        printf("\n");
    }
}

@end
