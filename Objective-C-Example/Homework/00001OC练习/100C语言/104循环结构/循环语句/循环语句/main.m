//
//  main.m
//  循环语句
//
//  Created by niit on 15/12/17.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {

#pragma mark - for语句
        
//        格式
//        for (初始语句; 循环条件; 步进语句)
//        {
//            具体循环执行的语句
//        }

        // 计算1+2+3+...+100
//        int result=0;
//        for (int i=1; i<=100; i++)
//        {
//            result += i;
//        }
//        printf("1+2+3+...+100=%d\n",result);
//        
//        // 练习
//        // 1 打印100个*
//        for (int i=0; i<100; i++)
//        {
//            printf("*");
//        }
        
        // 流程
        //1  int i=1;
        //2  判断 i<=100 满足，则继续执行循环体
        //3  printf("*"）
        //4  i++     // i=2
        //5  判断 i<=100
        //6  printf("*"）
        //7  i++     // i=3
        //5  判断 i<=100
        //6  printf("*"）
        //7  i++     // i=4
        ///...
        ///...
        //  printf("*"）
        //  i++     // i=101
        //  判断 i<=100 不满足循环条件则跳出循环
        
//        // 2 打印1~1000,数字间逗号分隔
//        for (int i=1; i<=1000; i++) {
//            printf("%d,",i);
//        }
//
//        // 3 打印-100~100,数字间逗号分隔
//        for (int w = -100; w<101; w++) {
//            printf("%d,",w);
//        }
//        printf("\n");
//
//        // 4 打印2 4 6 8 ... 100,数字间逗号分隔
//        for(int i=2;i<=100;i+=2){
//            printf("%i,",i);
//        }
        
        // 5 打印-9 -6 -3 -0 3 6 ... 99
        
        // 6 让用户输入n,打印n个*
        //        int n;//客户输入的值
        //        printf("请输入一个数值:\n");
        //        scanf("%d",&n);
        //        for(int i=1;i<=n;i++){
        //            printf("*");
        //        }
        
        // 7 让用户输入n,计算1+2+...+n
        // 8 让用户输入n,计算1*2*...*n
        // 9 找出所有三位数的水仙花数
        //(水仙花数是指一个n位数(n≥3),它的每个位上的数字的n次幂之和等于它本身。例如：1*1*1+5*5*5+3*3*3=153)
        //(思路:对每一个三位数进行判断,把它的个位数十位数百位数取出来进行计算,是否符合这个规则)
        
        
//          int i=0,j=1;
//        for (; i<=100; i++)
//        {
//            result += i;
//        }
//        printf("%d\n",i);
        
//        for (int i=0;i<=100;i++)
//        {
//            result += i;
//        }
        
        // 死循环
//        for (;;)
//        {
//            printf("*");
//        }

        
        
#pragma mark - 二重循环
        // 1 二重循环打印99乘法表
//        for(int i=1;i<=9;i++)
//        {
//            for(int j=1;j<=i;j++)
//            {
//                printf("%i*%i=%2i ",i,j,i*j);
//            }
//            printf("\n");
//        }

        // 循环流程
        // i=1, j=1~9  => 1*1=1 1*2=2 1*3=3 1*4=4 1*5=5 1*6*=6 1*7=7 1*8=8 1*9=9
        // i=2, j=1~9  => 2*1=1 2*2=2 2*3=3 2*4=4 1*5=5 2*6*=6 2*7=7 2*8=8 2*9=18
        // .
        // .
        // i=9, j=1~9  =>
        
        // 2 打印输出如下图形
        //(1)
        //*
        //**
        //***
        //****
        //*****
//        for (int i=1; i<=5; i++) {
//            for (int j=1; j<=i; j++) {
//                printf("*");
//            }
//            printf("\n");
//        }
        
        //(2)
        //*****
        //****
        //***
        //**
        //*
//        for (int i=1; i<=5;i++)
//        {
//            for (int j=1; j<=6-i; j++)
//            {
//                printf("*");
//            }
//            printf("\n");
//        }
        
        //(3)
        //    *
        //   **
        //  ***
        // ****
        //*****
//        for (int i=4; i>=0; i--)
//        {
//            for (int j=0; j<i; j++)
//            {
//                printf(" ");
//            }
//            for (int k=0; k<5-i; k++)
//            {
//                printf("*");
//            }
//            printf("\n");
//        }
        
        //(4)
        //*****
        // ****
        //  ***
        //   **
        //    *
//        for (int i=1; i<=5; i++)
//        {
//            for (int j=1; j<=i-1; j++) {
//                printf(" ");
//            }
//            for (int j=1; j<=6-i; j++){
//                printf("*");
//            }
//            printf("\n");
//        }
        
        
        //(*5)
        //   *
        //  ***
        // *****
        //*******
        // *****
        //  ***
        //   *
        
        // 行  0 1 2 3 4 5 6
        // -3
        //    -3 -2 -1 0 1 2 3
        //空格 3 2 1 0 1 2 3
         // *2
         //    6 4 2 0 2 4 6
        //星号 1 3 5 7 5 3 1
        for(int i=0;i<7;i++)
        {
            // 打印空格
            int spaceCount = abs(i-3); // abs()求绝对值
            for(int j=0;j<spaceCount;j++)
            {
                printf(" ");
            }
            
            // 打印星号
            int starCount = 7-spaceCount*2;
            for(int j=0;j<starCount;j++)
            {
                printf("*");
            }
            printf("\n");
        }
        
        //(*6)
        //   *
        //  * *
        // *   *
        //*     *
        // *   *
        //  * *
        //   *
        
        // 行  0 1 2 3 4 5 6
        //空格 3 2 1 0 1 2 3
        //星号 1 1 1 1 1 1 1
        //空格 0 1 3 5 3 1 0
        //星号 0 1 1 1 1 1 0
        for(int i=0;i<7;i++)
        {
            // 打印空格
            int spaceCount = abs(i-3); // abs()求绝对值
            for(int j=0;j<spaceCount;j++)
            {
                printf(" ");
            }
            
            // 打印星号
            printf("*");
            
            // 打空格
            spaceCount = 5-abs(i-3)*2;// i -> 空格的数量
            if(spaceCount>0)
            {
                for(int j=0;j<spaceCount;j++)
                {
                    printf(" ");
                }
                printf("*");
            }

            printf("\n");
        }
        
        

#pragma mark - while语句 先判断,后执行
        
        //while(判断条件)
        //  循环语句
        
        // 打印1~10
//        int i=11;
//        while(i<11)
//        {
//            printf("%d ",i++);
//        }
//        printf("\n");
        
#pragma mark - do{}while语句 先执行,后判断

        // 打印1~10
//        int i=11;
//        do
//        {
//            printf("%d ",i++);
//        }while (i<11);
        
//        // 区别
//        // do{}while 至少会被运行一次
//

        // 例子:
//        直到输入正确的为止
//        char a,b,c;
//        printf("请输入a:");
//        scanf("%c",&a);
//        printf("\n请输入b:");
//        do
//        {
//            scanf("%c",&b);
//        }while(b<97||b>122);
//        do
//        {
//            printf("\n请输入c:");
//            scanf("%c",&c);
//        }while(c<97||c>122);
//        
//        printf("%c %c %c\n",a,b,c);
        
        // 练习:
        // 1 输入n,计算1+2+3+...+n 使用while循环
        
        // 2 输入n,计算1*2*3*...*n 使用do{}while()
        
        // 3
        // 输入n,用while(){} 或 do{}while()编写打印n个斐波那契数(0 1 1 2 3 5 8 13 21 34 ...)
        // 思路:定义两个变量保存第一个第二个，第三个是由第一第二个加起来，打印完第三个后，将第二第三个再保存到这两个变量中，以供循环下一次使用。
        
        int n1=0,n2=1;
        int n3, n;
        int m=0;
        printf("请输入要打印的斐波那契数的个数\n");
        scanf("%d",&n);
        printf("%d %d ",n1,n2);
        while (m<n-2) {
            n3=n1+n2;
            printf("%d ",n3);
            n1=n2;
            n2=n3;
            m++;
        }
        printf("\n");
        
#pragma mark - break 和 continue
        
        // 1 break 跳出循环
//        for (int i=0; i<10; i++)
//        {
//            if(i==5) break;
//            printf("%d ",i);
//        }
//        printf("\n");
//
        // 2 continue 进入下一次循环 contiue后的语句不执行了，直接执行下一次
//        for (int i=0; i<10; i++)
//        {
//            if(i==5) continue;// 当==5的时候,后面语句不执行了
//            printf("%d ",i);
//        }
//        printf("\n");
//        
//        
//        //注意:如果2层嵌套循环 break只能终止一层循环
//        for(int i=1;i<=9;i++)
//        {
//            for(int j=1;j<=i;j++)
//            {
//                printf("%i*%i=%2i ",i,j,i*j);
//                
//                if(j==5)
//                {
//                    break;
//                }
//            }
//            printf("\n");
//        }
        

        
#pragma mark - goto 直接跳转到某行语句
        
//        for(int i=1;i<=9;i++)
//        {
//            for(int j=1;j<=i;j++)
//            {
//                printf("%i*%i=%2i ",i,j,i*j);
//
//                if(j==5)
//                {
//                    goto Label1;
//                }
//            }
//            printf("\n");
//        }
//        
//    Label1:
//        printf("结束了");
        
        
        // 综合练习:
        // 1 制作一个猜拳游戏。玩家可以选择玩哪种模式。
        // 模式1:猜拳10次，统计输赢次数结果
        // 模式2:一直玩到玩家输10次为止。最后显示输赢次数结果
        
        // *2 制作一个警察追小偷游戏。
        // 地图大小10*10
        // 警察坐标 int policeX=0,policeY=0;//起始坐标(0,0)
        // 小偷坐标 int thiefX,thiefY;//起始坐标(9,9)
        // 让玩家控制警察，让用户输入(a s w d)分别代表向左下上右，往上走y++,往下走y--,往左走x--,往右走x++，但不能走出地图(即0~9范围内)
        // 小偷向随机方向走一步，警察走一步。
        // 警察追上小偷(坐标重合policeX==thiefX&&policeY==thiefY)，显示游戏结束,显示总共走了多少步。
        // 每走一步显示以下当前警察和小偷坐标。
        
//        int policeX=0,policeY=0;
//        int thiefX=9,thiefY=9;
//        
//        // 打印当前位置
//        for(int i=0;i<10;i++)
//        {
//            for(int j=0;j<10;j++)
//            {
//                if(policeX==i&&policeY==j)
//                {
//                    printf("👮");
//                }
//                else if(thiefX==i&&thiefY==j)
//                {
//                    printf("💂");
//                }
//                else
//                {
//                    printf("◻️");
//                }
//            }
//            printf("\n");
//        }
//        
    
        
        
        
        
    }
    return 0;
}
