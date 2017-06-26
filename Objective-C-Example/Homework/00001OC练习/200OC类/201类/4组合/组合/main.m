//
//  main.m
//  组合
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Face.h"
#import "Eye.h"


#import "Game.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {

        // 创建眼睛对象
//        Eye *eye = [[Eye alloc] init];
//        eye.color = kColorBrown;
//        eye.bShuang = NO;
////        NSLog(@"%@",[eye info]);
//        
//        // 创建鼻子对象
//        Nose *nose = [[Nose alloc] init];
//        nose.bGao = NO;
////        NSLog(@"%@",[nose info]);
//        
//        // 创建脸对象
//        Face *face = [[Face alloc] init];        
//        face.eye = eye;// 把眼睛安上
//        face.nose = nose;// 把鼻子安上
    
        // 对象的子成员对象
        //1 一种是外部创建好后赋值给它
        //2 一种是对象初始化的时候，同时初始化其子对象,即写在- (id)init;方法里
        
//        NSLog(@"脸的信息:%@",[face info]);
        
        // 练习一下:
        // 1 创建嘴巴类、头发类,完善这张脸。
        // 2 编写一个电脑类(由显示器类、鼠标类、键盘类、主机类对象组成),在main中创建电脑对象，并把它的配置信息打印显示
        
        // 改进之前做的的RPG游戏,将游戏作为一个类Game类,游戏类包含子对象一个怪物一个英雄。
        
        Hero *hero = [[Hero alloc] init];
        Monster *monster = [[Monster alloc] init];
        monster.x = kMapSize-1;
        monster.y = kMapSize-1;
        
        Game *game = [[Game alloc] init];
        game.hero = hero;
        game.monster = monster;
        
        [game play];
        
    }
    return 0;
}
