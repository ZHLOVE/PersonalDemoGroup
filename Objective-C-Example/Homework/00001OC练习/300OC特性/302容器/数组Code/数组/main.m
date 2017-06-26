//
//  main.m
//  数组
//
//  Created by niit on 16/1/5.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>


NSString *numbetToString(int a)
{
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    int tmp = a;
    while (tmp>0)
    {
        int x = tmp%10;// 求余数
        tmp = tmp/10;
        
        NSArray *tmpArr = @[@"零",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九"];
        [resultStr insertString:tmpArr[x] atIndex:0];
    }
    return [resultStr copy];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        // C语言的数组                        内存
        int a[10];                        // 4*10
        int b[5] = {10,20,30,40,50};      // 4*5
        char c[] ={'a','c','b','d'};      // 1*4
        float d[3][3] = {{18,13.0},{5}};  // 4*3*3
        
#pragma mark - 不可变数组 NSArray
#pragma mark 定义
        // 1 Objective数组的元素必须是对象,不能是基本类型
        // 2 元素可以是任何类型的对象,并不必须需是同一种类型
        NSArray *arr1 = [[NSArray alloc] init];
        NSArray *arr2 = [[NSArray alloc] initWithObjects:@1,@2,@3,@4,@5,nil];// 5 NSNumber对象
        NSArray *arr3 = [NSArray arrayWithObjects:@1,@2,@3,@4,@5, nil];
        NSArray *arr4 = @[@1,@2,@3,@4,@5];
        
        NSNumber *n1 = arr4[0];// 通过下标
        NSNumber *n2 = [arr4 objectAtIndex:0];// 通过方法访问
#pragma mark 1 数组的大小
        NSLog(@"arr4数组的大小:%i",arr4.count);
        
#pragma mark 2 遍历数组
//       方法一: 通过下标
//        for(int i=0;i<arr4.count;i++)
//        {
//            NSLog(@"%@",arr4[i]);
//        }
        
        // 方法二:OC增强型for循环
        // 格式
//        for(类名 *局部变量 in 数组名)
//        {
//            局部变量
//        }
        // 说明
        // 1)数组有几个元素，for循环几次
        // 2)每次循环局部变量tmp指针指向当前循环到的对象,下次循环自动指向下一个对象
        
        // 应用情况:
        // 1 如果要用到下标，用前一种
        // 2 不用到下标，遍历所有，你就用第二种
        
        // 例子:打印arr4
        for(NSNumber *tmp in arr4)
        {
            NSLog(@"%@",tmp);
        }
        
        NSArray *weeks = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
        // 方式一
//        for(int i=0;i<weeks.count;i++)
//        {
//            NSLog(@"%@",weeks[i]);
//        }
        // 方式二
        for (NSObject *tmp in weeks)
        {
            NSLog(@"%@",tmp);
        }
        
        // 练习:
        //a 创建一个字符串数组:甲、乙、丙、丁、戊、己、庚、辛、壬、癸 打印输出
        //b 创建一个学生学号的数组:10001、10002、10003、10004
        //b 创建一个学生名字的数组:王小明、王鹏、王尼玛、比尔盖茨
        //c 创建一个学生成绩的数组:89.5,65.0,49.5,60.5
        
//        NSString *resultStr3 = numbetToString(165234);
//        NSLog(@"%@",resultStr3);
    
#pragma mark 3 二维数组
        NSArray *stuInfos = @[@[@1001,@"小明",@90],
                              @[@1002,@"张三",@60],
                              @[@1003,@"李四",@80]];
        
        // stuInfos数组的子元素是3个NSArray对象
        for(NSArray *tmpArr in stuInfos)
        {
            NSLog(@"学号:%@ 姓名:%@ 成绩:%@",tmpArr[0],tmpArr[1],tmpArr[2]);
        }
        
        // 二维练习
        // 创建一个二维数组，打印输出
        //编号    车型         价格(万元)
        //1     帕萨特2013     25.6
        //2     北京现代ix3    24.25
        //3     本田CR-V      20.78
        //4     宝马1系        24.20
        
#pragma mark - 4 可变数组NSMutableArray
        
//        NSArray *tmpArr1 = @[@1,@2];
//        tmpArr1[0] = @3;// NSArray不可变，编译报错
        
        // 定义
        NSMutableArray *weak2 = [[NSMutableArray alloc] init];
        NSMutableArray *weak3 = [[NSMutableArray alloc] initWithCapacity:7];// 指定容量为7的空数组,在增加对象，减少对象时，不耗费cpu
        NSMutableArray *weak4 = [weeks mutableCopy];
        
        // 向中增加对象
        [weak2 addObject:@"星期一"];
        [weak2 addObject:@"星期二"];
        [weak2 addObject:@"星期三"];
        // 删除数组中的元素
        [weak2 removeObjectAtIndex:0];// 移除第一个
        [weak2 removeLastObject];// 最后一个
        [weak2 removeAllObjects];// 清空
        [weak2 removeObject:@"星期一"];// 移除某个对象
        
        for(NSString *s in weak2)
        {
            NSLog(@"%@",s);
        }
        
#pragma mark 可变数组删除多个元素
        NSMutableArray *mArr1 = [@[@"张三",@"李四",@"王五",@"赵六",@"赵七"] mutableCopy];
        // 删除姓赵的
        // 方式1
        //        BOOL bDeleted;// 记录是否有删除
        //        do
        //        {
        //            bDeleted = NO;
        //            for (int i= 0 ; i<arr1.count; i++)
        //            {
        //                NSString *tmpStr = arr1[i];
        //                if([[tmpStr substringToIndex:1] isEqualToString:@"赵"])
        //                {
        //                    [arr1 removeObject:tmpStr];
        //                    bDeleted = YES;// 删除了
        //                    break;
        //                }
        //            }
        //        }while (bDeleted);// 如果有删除，继续运行
        
        // 方式二
        
        // 1)先找出所有姓赵的，放到一个新的数组中
        NSMutableArray *needDel = [NSMutableArray array];
        for (int i= 0 ; i<mArr1.count; i++)
        {
            NSString *tmpStr = arr1[i];
            if([[tmpStr substringToIndex:1] isEqualToString:@"赵"])
            {
                [needDel addObject:tmpStr];
            }
        }
        // 2)数组删除所有needDel中的元素
        [mArr1 removeObjectsInArray:needDel];// 通过数组删除


#pragma mark 5 数组与字符串转换
        // 拼接成一个字符串@"2016-01-05-a-123-cba"
         NSArray *strArr = @[@"2016",@"01",@"05",@"a",@"123",@"cba"];
//        NSMutableString *strings = [NSMutableString string];
//        for(int i=0;i<str.count;i++)
//        {
//            [strings appendString:str[i]];
//            if(i!=str.count-1)
//            {
//                [strings appendString:@"-"];
//            }
//        }
//        NSLog(@"%@",strings);
        
        // 拼接
        // NSArray -> NSStrring
        NSString *strings = [strArr componentsJoinedByString:@"-"];
        NSLog(@"%@",strings);
        
        // 分割
        //NSString -> NSArray
        NSArray *strArr2 = [@"0510-888812345-123" componentsSeparatedByString:@"-"];
        NSLog(@"%@",strArr2);
        
        
#pragma mark - 附加
        //* 特殊情况,注意一下:
        // NSNumber和NSString如果对象的内容一样,认为是同一个对象
        // 其他类的对象,则不是同一对象
        NSNumber *n = [[NSNumber alloc] initWithInt:15];
        NSNumber *m =@15;
        NSLog(@"%p %p",n,m);
        
        NSMutableArray *arrM = [@[@1,@2,@1,@1] mutableCopy];
        NSLog(@"删除前:%@",arrM);
        [arrM removeObject:@1];
        NSLog(@"删除后:%@",arrM);
        
        NSString *s1 = @"abc123";
        NSString *s2 = [[NSString alloc] initWithString:@"abc123"];
        NSLog(@"%p %p",s1,s2);
        
        NSMutableArray *arrO = [@[@"小明",@"张三",@"小明"] mutableCopy];
        NSLog(@"删除前:%@",arrO);
        [arrO removeObject:@"小明"];
        NSLog(@"删除后:%@",arrO);
        
        //其他的类和自定义的类的对象，哪怕值一样，p1 p2 绝对不是同一个对象
        //        Person *p1 = [[Person alloc] init];
        //        Person *p2 = [[Person alloc] init];
        
        // 综合练习:
        // 用将数组:
        

        
        

    }
    return 0;
}
