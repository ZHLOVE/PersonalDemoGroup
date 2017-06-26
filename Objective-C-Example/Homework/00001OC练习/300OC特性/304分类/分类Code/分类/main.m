//
//  main.m
//  分类
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSString+reverse.h"

#import "NSNumber+errorMessage.h"
#import "NSNumber+China.h"

#import "Fraction.h"
#import "Fraction(MathOps).h"

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        
        // 分类 Category
        // 比如我们封装了一个类，不想再动它了，但是我们又需要在那个类中增加一个方法，这时候我们就不必在那个类中做修改或者再定义一个它的子类，只需要添加一个（Category）即可。
        
        // 功能
        //1 对现有类进行扩展:你对Foundation框架、Cocoa Touch框架中的类进行扩展
        //2 作为子类的替代手段:不需要定义和使用一个子类，通过类目直接向已有类增加方法
        //3 对类中的方法归类:利用类目把一个庞大的类划分成小块来分别进行开发，方便更新和维护
        //局限:无法向类目中添加新的实例变量
        
        // 例子1:
        // NSString创建分类提供翻转的方法
        // abcdefg123 -> 321gfedcba
        
        NSString *str1 = @"abcdefg123";
        
        NSLog(@"当前:%@",str1);
        NSLog(@"翻转之后:%@",[str1 reverseString]);
        
        // 例子2: 显示http访问错误码对应的中文含义
        // NSNumber创建分类提供转换为字符串的方法
        //对应的错误码
        //401 未经授权
        //403 禁止访问
        //404 找不到网页
        //500 服务器错误
        //501 没有响应
        //502 错误网管
        //503 服务不可用
        //其他 未知错误
        
        NSNumber *error = @404;
        NSLog(@"%@",[error errorInfo]);
        
        // 练习:
        // 1 给NSString添加一个seperate分类,提供一个方法,实现以下功能,用以下代码测试
//        NSString *str2 = @"abcd";
//        NSLog(@"%@",[str2 addSperateString:@"-"]);// 显示@"a-b-c-d"
        
        // 2 给NSNumber添加一个分类，提供以下的方法
        //- (NSString *)toChinaString;
        //* - (NSString *)toBigChinaString;// 作为课后思考练习题
        //大写参考
        //零、壹、贰、叁、肆、伍、陆、柒、捌、玖 数量单位:拾、佰、仟、万、亿 金额单位:元(圆)、角、分、零、整(原则上角后不写“整”)
        // 用一下代码测试:
        NSNumber *n1=@1234567;
//        NSLog(@"%@",[n1 toChinaString]);//输出 "一二三四五六"
//        NSNumber *n2=@789234;
        NSLog(@"%@",[n1 toBigChinaString]);//输出 @"柒拾捌万玖仟贰佰叁拾肆元整"
        
        NSLog(@"%@",[@0.01 toBigChinaString]);
        NSLog(@"%@",[@0.11 toBigChinaString]);
        NSLog(@"%@",[@1.11 toBigChinaString]);
        NSLog(@"%@",[@11.11 toBigChinaString]);
        NSLog(@"%@",[@111.11 toBigChinaString]);
        NSLog(@"%@",[@1111.11 toBigChinaString]);
        NSLog(@"%@",[@1 toBigChinaString]);
        NSLog(@"%@",[@10 toBigChinaString]);
        NSLog(@"%@",[@1001 toBigChinaString]);
        NSLog(@"%@",[@2050 toBigChinaString]);
        
        
        // 例子3:(对类中的方法归类,模块化)
        Fraction *a = [[Fraction alloc] init];
        a.numerator = 1;
        a.denominator = 3;
        Fraction *b = [[Fraction alloc] init];
        b.numerator = 1;
        b.denominator = 2;
        [a add:b];
        
        

    }
    return 0;
}
