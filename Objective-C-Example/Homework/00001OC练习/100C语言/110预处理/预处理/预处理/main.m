//
//  main.m
//  预处理
//
//  Created by niit on 15/12/22.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

// iOS界面框架
//#import <UIKit/UIKit.h>



// 1 引入头文件
//#import "Function.m"
//=> 等同于复制代码进来
//
//  Function.h
//  预处理
//
//  Created by niit on 15/12/22.
//  Copyright © 2015年 NIIT. All rights reserved.
//

int add(int a,int b)
{
    return a+b;
}


#import "def.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {

    
        printf("13+25=%i\n",add(13,25));
//
////        printf("PI = %f,%f,%f\n",PI,M_1_PI,M_2_PI);
//        
//        for (int i=0; i<kMapSize; i++)
//        {
//            for (int j=0; j<kMapSize; j++)
//            {
//                printf("◻️");
//            }
//            printf("\n");
//        }
//        printf("\n");
//        
//        
//        
//        // 奇异数
//        
//        for (int i=0; i<kMapSize; i++)
//        {
//            for (int j=0; j<kMapSize; j++)
//            {
//                printf("◻️");
//            }
//            printf("\n");
//        }
//        printf("\n");
//        
//        
//        NSLog(@"当前操作系统是:%@",OS);
//        
//#ifdef DEBUG
//        NSLog(@"调试模式");
//#else
//        NSLog(@"发布模式");
//#endif
        
//
        
//        int x=10;
//        printf("%i",PF(x));
        
        int a=200;
        int b=100;
//        printf("%i\n",SUB(a,b));//=>  printf("%i\n",a-b);
        
        printf("%i\n",SUB(a,b)*10);// => printf("%i\n",((a)-(b))*10);
    
    }
    return 0;
}
