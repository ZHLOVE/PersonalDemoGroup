//
//  main.m
//  BitOperate
//
//  Created by niit on 15/12/16.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {

        // 位操作 二进制位操作
        // & | ^ ~ << >>
        int a = 3;//0000 0011
        int b = 5;//0000 0101
        
        // & 与
        printf("a&b = %i\n",a&b);// 1
//        0000 0011
//        0000 0101
//        0000 0001 => 1
        
        // | 或
        printf("a|b = %i\n",a|b);//
//        0000 0011
//        0000 0101
//        0000 0111 => 7
        
        // ^ 异或
        printf("a^b = %i\n",a^b);//
//        0000 0011
//        0000 0101
//        0000 0110 => 6
        
        // ~ 求反
        printf("~a = %i\n",a);//
//        0000 0011
//        1111 1100 => -4

// 计算机中整数的负数用补码方式保存
// -4
// -4的原码
// 1000 0100
// -4的反码
// 1111 1011
// 补码 +1
// 1111 1100
        
        // 左移
        printf("a<<2 = %i\n",a<<2);
//        0000 1100 => 12
        // 右移
        printf("a>>2 = %i\n",a>>2);
//      0000 0000 => 0
        
    }
    return 0;
}
