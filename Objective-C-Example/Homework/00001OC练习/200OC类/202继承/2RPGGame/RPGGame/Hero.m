//
//  Player.m
//  组合
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Hero.h"

@implementation Hero

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"玩家";
    }
    return self;
}

- (instancetype)initWithName:(NSString *)n
{
    self = [super init];
    if (self) {
        self.name = n;
    }
    return self;
}

- (void)walkOneStep
{
    //根据玩家输入的方向控制
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
    [self move:d];
}
@end
