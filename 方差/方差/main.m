//
//  main.m
//  方差
//
//  Created by MBP on 2016/11/8.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //**初始化参数*/
        NSLog(@"Hello, 方差!");
        int count = 500;
        int sum = 0;
        int fcSum = 0;
        int avNum = 0;
        int avFcSum = 0;
        NSMutableArray *numArray = [NSMutableArray array];


        for (int i = 0; i<count; i++) {
            int ranNum = arc4random()%100 + 300;
            NSLog(@"%d",ranNum);
            [numArray addObject:@(ranNum)];
            sum = sum + ranNum;
        }

//        [numArray replaceObjectAtIndex:1 withObject:@(150)];
        [numArray replaceObjectAtIndex:3 withObject:@(10)];
//        [numArray replaceObjectAtIndex:4 withObject:@(200)];

        avNum = sum / count;
        NSLog(@"平均数%i",avNum);
        for (NSNumber *num in numArray) {
            NSInteger intNum = [num floatValue] - avNum;
            double fNum = powf(intNum, 2);
            fcSum = fcSum + fNum;
        //NSLog(@"%f",fNum);
        }

        avFcSum = fcSum / count;
        NSLog(@"方差%d",avFcSum);
    }
    return 0;
}
