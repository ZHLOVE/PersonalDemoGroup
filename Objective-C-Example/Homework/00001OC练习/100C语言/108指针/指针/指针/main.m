//
//  main.m
//  指针
//
//  Created by niit on 15/12/22.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct Student
{
    int stuId;
    char name[20];
    BOOL sex;
    int age;
}Student;


// 传入一个变量的值
void changeA(int n)
{
    n=0;
}

// 传入一个变量的地址
void changeB(int *n)
{
    *n=0;
}

// 传值
// 交换两个值,只是交换了两个局部变量的值
//void swap(int x,int y)
//{
//    int tmp = x;
//    x = y;
//    y = tmp;
//}

// 传址
// 交换了地址指向内存的值
void swap(int *x,int *y)
{
    printf("地址:%p,%p\n",x,y);
    int tmp = *x;
    *x = *y;
    *y = tmp;
    printf("地址:%p,%p\n",x,y);
}

// 指针作为返回值
// 参数 两个int型指针
// 返回值 int型指针
int * max(int *pA,int *pB)
{
    if(*pA > *pB)
    {
        return pA;
    }
    else
    {
        return pB;
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {

//#pragma mark - 指针的定义和使用
//        
//        // & 取地址符号
//        // * 间接访问操作符
//        
//        int a=3;
//        int *ptr;// 定义了一个指向int型变量 的 指针变量，存放的是地址信息
//        ptr = &a;// ptr存放a的内存地址
//        printf("a 的内存地址  %p\n",&a);
//        printf("ptr 的值  %p\n",ptr);
//        printf("ptr 的内存地址 %p\n",&ptr);//ptr是变量，本身也占用内存,指针变量地址
//        
//        *ptr = 100;// * 通过指针,操作内存地址指向内存的内容
//        printf("%i\n",*ptr);
//        
//        int b = 200;
//        printf("b 的内存地址 %p\n",&b);
//        ptr = &b;
//        printf("ptr 的值: %p\n",ptr);
//        *ptr = 500;
//        printf("%i\n",*ptr);// 通过指针访问它指向的内容
//        
//        // 定义指针变量时,建议书写的时候*靠近变量
//        // int *p1;
//        // int* p2;// p1 p2没有区别,都是指针变量
//        // int *p3,*p4;// 定义了2个指针
//        // int* p5,p6;//实际上是定义了一个指针,一个int变量
//        
//#pragma mark - 指针与数组
//        int arr[5] ={10,20,30,40,50};
//        ptr = arr;// 数组名数组的地址
//        for (int i=0; i<5; i++)
//        {
////            printf("%i,",arr[i]);
//            printf("%i,",*(ptr+i));
//        }
//        printf("\n");
//        
//        int arr2[2][3]={{10,20,30},{40,50,60}};
//        // *定义二维数组的指针
//        int (*ptr2)[3]=arr2;//
//        for(int i=0;i<2;i++)
//        {
//            for (int j=0; j<3; j++)
//            {
////                printf("%i,",arr2[i][j]);
//                printf("%i,",*(*(ptr2+i)+j));
//            }
//            printf("\n");
//        }
//        printf("\n");
//        
//#pragma mark - 指针与结构体
//        Student stu;
//        Student *pStu;
//        pStu = &stu;
//        printf("请输入学号:");
////        scanf("%i",&stu.stuId);
//        scanf("%i",&pStu->stuId);
//        printf("请输入姓名:");
//        scanf("%s",pStu->name);
//        printf("请输入年龄:");
//        scanf("%i",&pStu->age);
//        
//        printf("%i,%s,%i\n",pStu->stuId,pStu->name,pStu->age);
//
//#pragma mark - 动态分配
//        // 了解一下
//        // 在堆内存里动态创建一个Student
//        pStu = (Student *)malloc(sizeof(Student));//1 创建
//        free(pStu);//2 释放
        
#pragma mark - 函数与指针
        
        // 1) 指针作为函数参数
        //        int a = 150;
////        changeA(a);
//        printf("a = %i\n",a);
//        
//        int b = 250;
////        changeB(&b);
//        printf("b = %i\n",b);

//        swap(a,b);        
//        swap(&a,&b);
//        printf("swap()之后 a = %i,b = %i\n",a,b);
        
        // 2) 指针作为返回值
        int x1 = 200;
        int y1 = 500;
        
        int *pMax = max(&x1, &y1);
        printf("较大的数是 %i",*pMax);
        
        // 作业:
        // 读一遍书上指针一章
        
        
        
    }
    return 0;
}
