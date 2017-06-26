//
//  main.m
//  运算符补充
//
//  Created by niit on 15/12/17.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        // 逗号表达式
//        int a=3;
//        int b;
//        int c;
//        c = (a=a+1,b=3*4);
//        printf("%d %d %d\n",a,b,c);
        
//        int a1,a2,b=2,c=7,d=5;
//        a1=(++b,c--,d+3);
//        //++b  3
//        //c--  6
//        //d+3
//        //a=d+3 8
//        a2=++b,c--,d+3;
//        //a2=++b  a2=4
//        //c--     5
//        //d+3
        
        // sizeof()
        printf("%lu\n",sizeof(10));
        
        char c='a';
        printf("%lu\n",sizeof(c));
        printf("%lu\n",sizeof c);
        
        printf("int %lu\n",sizeof(int));
        printf("short int %lu\n",sizeof(short));
        printf("long int %lu\n",sizeof(long));
        printf("long long %lu\n",sizeof(long long));
        printf("float %lu\n",sizeof(float));
        printf("double %lu\n",sizeof(double));
        printf("long double %lu\n",sizeof(long double));
        

        
    }
    return 0;
}
