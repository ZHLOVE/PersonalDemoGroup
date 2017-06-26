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

- (void)play
{
    while(1)
    {
        [self printMap];
        
        //根据玩家输入的方向控制aHero走动
        char c;
        do
        {
            printf("请输入方向(wasd):");
            scanf("%c",&c);
        }while (c!='w'&&c!='a'&&c!='s'&&c!='d');
        
        Direction d;
        switch (c) {
            case 'w':
                d = kDirectionUp;
                break;
            case 'a':
                d = kDirectionLeft;
                break;
            case 's':
                d = kDirectionDown;
                break;
            case 'd':
                d = kDirectionRight;
                break;
            default:
                break;
        }
        [self.hero move:d];
        
        [self.monster move:arc4random()%4];//怪物随机往一个方向走动
        
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
