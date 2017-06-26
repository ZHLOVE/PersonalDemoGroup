//
//  main.m
//  谓词Demo
//
//  Created by niit on 16/1/20.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Person.h"

// 这个函数是提供给sortedArrayUsingFunction所使用的,格式必须按照这样的格式去写,是sortedArrayUsingFunction规定的。
// sortedArrayUsingFunction内部也是两两比较,你提供的方法告诉它两两进行比较的规则:当两个对象进行比较,哪个在前,哪个在后。
NSInteger customSort(id obj1,id obj2,void *content)
{
    Person *p1 = obj1;
    Person *p2 = obj2;
    
    // 成绩比较
    if(p1.age<p2.age)
    {
        return NSOrderedDescending;
    }
    else if(p1.age>p2.age)
    {
        return NSOrderedAscending;
    }
    else
    {
        return NSOrderedSame;
    }
}


int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        
#pragma mark - 数组的筛选(使用谓词NSPredicate)
        
#pragma mark 例子1 字符串数组
//        pre = [NSPredicate predicateWithFormat:@"self matches %@",regex];// 如果是字符串数组,使用 self
//        NSArray *strArr = @[@"Abcde",@"acdb",@"akdf123",@"asdfasdf",@"A1e"];
//        for(NSString *str in strArr)
//        {
//            if([pre evaluateWithObject:str])
//            {
//                NSLog(@"%@",str);
//            }
//        }
        
#pragma mark 例子2 对象数组
        Person *p1 = [[Person alloc] initWithName:@"张三" andAge:17 andReward:100];
        Person *p2 = [[Person alloc] initWithName:@"李四" andAge:16 andReward:100];
        Person *p3 = [[Person alloc] initWithName:@"王五" andAge:15 andReward:100];
        Person *p4 = [[Person alloc] initWithName:@"张虎虎" andAge:20 andReward:700];
        Person *p5 = [[Person alloc] initWithName:@"赵小张" andAge:18 andReward:100];
        Person *p6 = [[Person alloc] initWithName:@"赵小六" andAge:21 andReward:60];
        Person *p7 = [[Person alloc] initWithName:@"Abcde" andAge:30 andReward:50];
        Person *p8 = [[Person alloc] initWithName:@"Abe" andAge:30 andReward:50];
        NSArray *arr = @[p1,p2,p3,p4,p5,p6,p7,p8];
//        for(Person *p in arr)
//        {
//            NSLog(@"%@",p);
//        }
        
        // 谓词的主要功能:筛选、查找
//        NSPredicate *pre;
//        pre = [NSPredicate predicateWithFormat:@"age<=17"];
//        pre = [NSPredicate predicateWithFormat:@"age>=%i",18];
//        pre = [NSPredicate predicateWithFormat:@"name in {'张三','李四'}"];// in 在某个范围内
        //条件与 &&,AND
        //条件或 ||,OR
        //非  !,NOT
//        pre = [NSPredicate predicateWithFormat:@"age<17 && name in {'张三','李四'}"];
//        pre = [NSPredicate predicateWithFormat:@"name like '张*'"];// 以张开头,*代表多个字符:张三 张虎虎
//        pre = [NSPredicate predicateWithFormat:@"name like '张?'"];// 以张开头,?代表一个字符:张三
//        pre = [NSPredicate predicateWithFormat:@"name contains '张'"];// 包含张
//        pre = [NSPredicate predicateWithFormat:@"name beginswith '张'"];// 以张开头
//        pre = [NSPredicate predicateWithFormat:@"name endswith '张'"];// 以张结尾
        
        // 使用正则表达式.(什么是正则表达式,见<<正则表达式30分钟入门>>)
        // 具体用处:可验证用户输入的用户名、邮箱地址、手机号码的格式是否正确
//        NSString *regex = @"^A.+e$";// 正则表达式,以A开头,以e结尾的字符串
//        pre = [NSPredicate predicateWithFormat:@"name matches %@",regex];
        
        // 用法一:
//            - (BOOL)evaluateWithObject:(nullable id)object;
//        for(Person *p in arr)
//        {
//            if([pre evaluateWithObject:p])// 用谓词判断对象是否符合谓词条件
//            {
//                NSLog(@"%@",p);
//            }
//        }
        
        // 用法二:
//- (NSArray<ObjectType> *)filteredArrayUsingPredicate:(NSPredicate *)predicate; //数组用谓词过滤，产生一个个符合条件的对象数组
//        NSArray *newArr = [arr filteredArrayUsingPredicate:pre];
//        for(Person *p in newArr)
//        {
//            NSLog(@"%@",p);
//        }
        
        

        
#pragma mark - 数组的排序
        
        NSArray *numArr = @[@1,@5,@3,@12,@9,@2];
        NSLog(@"排序前:%@",numArr);
        
        NSArray *sortedArr;
        
#pragma mark 1.使用某方法进行排序
//- (NSArray<ObjectType> *)sortedArrayUsingSelector:(SEL)comparator;
        
//- (NSComparisonResult)compare:(NSNumber *)decimalNumber;        
//        sortedArr = [numArr sortedArrayUsingSelector:@selector(compare:)];
//        NSLog(@"排序后:%@",sortedArr);

#pragma mark 2.使用自定义函数
//- (NSArray<ObjectType> *)sortedArrayUsingFunction:(NSInteger (*)(ObjectType, ObjectType, void * __nullable))comparator context:(nullable void *)context;        
//        sortedArr = [arr sortedArrayUsingFunction:customSort context:nil];
//        NSLog(@"排序后:%@",sortedArr);
        
#pragma mark 3.使用block
//        sortedArr = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//            Person *p1 = obj1;
//            Person *p2 = obj2;
//            
//            // 成绩比较
//            if(p1.age<p2.age)
//            {
//                return NSOrderedDescending;
//            }
//            else if(p1.age>p2.age)
//            {
//                return NSOrderedAscending;
//            }
//            else
//            {
//                return NSOrderedSame;
//            }
//        }];
//        NSLog(@"排序后:%@",sortedArr);
        
#pragma mark 4.使用NSSortDescriptor 排序条件
//- (NSArray<ObjectType> *)sortedArrayUsingDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors;    // returns a new array by sorting the objects of the receiver        
//        NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:NO];//年龄排序 从小到大
//        NSSortDescriptor *sort2 = [[NSSortDescriptor alloc] initWithKey:@"reward" ascending:NO];//年龄排序 从大到小
//        NSArray *sorts = @[sort1,sort2];// 条件数组
//        sortedArr = [arr sortedArrayUsingDescriptors:sorts];
//        
//        for (Person *p in sortedArr)
//        {
//            NSLog(@"%@",p);
//        }
        

#pragma mark 练习
//定义一个Student类,有属性姓名 英语 数学 语文
//在main中测试，创建一个存Student的数组，以下数据
//姓名	英语	数学	语文
//张三	99	60	66
//张四	50	98	60
//王晓明	60	88	95
//乔布斯	35	88	20
//库克	70	37	38

//1 筛选练习
//1) 查询显示所有分数都及格的学生
//2) 查询显示乔布斯的英语成绩
//3) 查询姓张的学生成绩
//4) 得到一个符合条件(数学成绩不及格)的学生数组
//
//2 排序练习(使用不同方式)
//1) 按照英语成绩从高到底输出
//2) 按照总分成绩从弟祷告输出
//3) 按照数学成绩,如果数学成绩一样，在再按照语文成绩排序
        
        

    }
    return 0;
}
