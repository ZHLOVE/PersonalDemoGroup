//
//  main.m
//  属性
//
//  Created by niit on 15/12/24.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Fraction.h"

#import "Person.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool
    {

//        Fraction *f1 = [[Fraction alloc] init];
//        
//        f1.numerator = 1;//实际上运行的是 => [f1 setNumerator:1];
//        f1.denominator = 3;//=> [f1 setDenominator:3];
//        
//        NSLog(@"%i/%i",f1.numerator,f1.denominator);
        // 实际上运行的是 NSLog(@"%i/%i",[f1 numerator],[f1 denominator]);
        
//        [f1 print];
        
        
        
        Person *p = [[Person alloc] init];
        p.age = 18;
        
        [p printInfo];
        
    }
    return 0;
}
