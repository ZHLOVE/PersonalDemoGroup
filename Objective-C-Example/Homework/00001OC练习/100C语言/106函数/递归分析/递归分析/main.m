//
//  main.m
//  递归分析
//
//  Created by niit on 15/12/21.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>


// foo

// f(n) = f(n-1)*n
// ...
// f(5) = f(4)*5
// f(4) = f(3)*4
// f(3) = f(2)*3
// f(2) = f(1)*2
// f(1) = 1

int foo(int n)
{
    int result;
    printf("计算f(%i)\n",n);
    printf("形参n的地址:%p\n",&n);
    printf("result的地址:%p\n",&result);
    
    if(n > 1)
    {
        result =  n * foo(n-1);//调用自身
    }
    else
    {
        result = 1;
    }
    printf("返回结果f(%i)的结果:%i\n",n,result);
    return  result;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        int n = 4;
        int result;
        printf("main里的n的地址:%p\n",&n);
        printf("result的地址:%p\n",&result);
        result = foo(n);
        printf("4! = 1*2*...*4 = %d",result);
    }
    return 0;
}
