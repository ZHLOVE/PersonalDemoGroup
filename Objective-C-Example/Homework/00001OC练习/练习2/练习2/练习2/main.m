//
//  main.m
//  练习2
//
//  Created by 马千里 on 16/3/12.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Dog.h"
#import "Master.h"
#import "Person.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Dog *dog = [[Dog alloc]init];
        dog.firstName = @"小白";
        Master *master = [[Master alloc]init];
        dog.myMaster = master;
        NSLog(@"%@",dog.fullName);
        /****************2.1定时器喂狗******************/
        
//        Person *timeMachine = [[Person alloc]init];
//        timeMachine.dog = dog;
//        [timeMachine machineFeedTheDog];
        
        /****************2.2主人喂狗*******************/
//        master.myDog = dog;

        /****************2.3代理人老王喂狗***************/
        
        Person *wang = [[Person alloc]init];
        wang.dog = dog;
        dog.delegate = wang;
        
        [[NSRunLoop currentRunLoop]run];
    }
    return 0;
}


