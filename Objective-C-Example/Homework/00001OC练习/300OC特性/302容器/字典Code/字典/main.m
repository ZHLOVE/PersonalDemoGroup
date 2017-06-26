//
//  main.m
//  字典
//
//  Created by niit on 16/1/5.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "Person.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        
#pragma mark - 字典
        
#pragma mark 1 创建字典
        NSDictionary *dict1 = [[NSDictionary alloc] init];
        NSDictionary *dict2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"张三",@1002,@"李四",@105,@"王五",@110, nil];
        // 通过2个数组创建,数组的元素个数要一样
        NSDictionary *dict4 = [[NSDictionary alloc] initWithObjects:@[@"张三",@"李四",@"王五"] forKeys:@[@102,@105,@110]];
        // {key1:value1,key2:value2}
        NSDictionary *dict3 = @{@102:@"张三",@105:@"李四",@110:@"王五"};
        
        // 字典
        // 1 key value 一一对应,一个key对象对应一个value对象
        // 2 通过key设置和访问value值
        // 3 如果没有对应的key，就返回空
        // 4 不是排序的
        // 5 key和value可以是任意对象，但key一般为NSNumber或者NSString

#pragma mark  2 访问字典元素
        NSString *name1 = dict3[@102];// 通过下标
        NSString *name2 = [dict3 objectForKey:@101];// 通过方法

        NSLog(@"1002-> %@ 105->%@ 110->%@",dict3[@102],dict3[@105],dict3[@110]);
        
#pragma mark 3 allKeys和alValues
        // 得到所有的key和value
        NSArray *keys = dict3.allKeys;// allKeys 得到字典中所有的key
        NSArray *values = dict3.allValues;// allValues 得到字典中所有的value
        NSLog(@"keys = %@",keys);
        NSLog(@"values = %@",values);
        
#pragma mark 4 遍历字典
        NSLog(@"遍历字典:");
        for(NSNumber *tmpKey in dict3.allKeys)
        {
            NSLog(@"%@ -> %@",tmpKey,dict3[tmpKey]);
        }
        
        
#pragma mark 5 NSMutableDictionary 可变字典
        // 创建可变字典
        NSMutableDictionary *mDict1 = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *mDict4 = [[NSMutableDictionary alloc] initWithCapacity:3];// 指定容量为多少，在小于该容量大小时添加新键值扩充时不耗费cpu,
        NSMutableDictionary *mDict2 = [NSMutableDictionary dictionary];
        NSMutableDictionary *mDict3 = [dict3 mutableCopy]; // 由不可变字典创建一个可变的新对象
        
        // 添加
//        [obj setObject:值 forKey:键];
        [mDict1 setObject:@"小明" forKey:@102];// 方法方式
        mDict1[@105] = @"张三";// 下标方式
        mDict1[@110] = @"李四";
        mDict1[@105] = @"王五";
        
        // 删除
//        [mDict1 removeAllObjects];// 全部清空
//        [mDict1 removeObjectForKey:@105];// 删掉key是105 的键值对
//        [mDict1 removeObjectsForKeys:@[@105,@110]];// 删掉key是105和110的键值对
        
#pragma mark 6 嵌套
        //JSON数据 => 对象数组 对象字典
        
        // 数组嵌套字典
//        NSDictionary *person1 = @{@"tel":@13801234567,@"name":@"小明",@"address":@"震泽18号"};
//        NSDictionary *person2 = @{@"tel":@13801123127,@"name":@"张三",@"address":@"震泽18号-1"};
//        NSDictionary *person3 = @{@"tel":@13011231271,@"name":@"李四",@"address":@"震泽18号-2"};
//        NSArray *stus = @[person1,person2,person3];
//        
//        for (NSDictionary *tmp in stus)
//        {
//            NSLog(@"%@ %@ %@",tmp[@"tel"],tmp[@"name"],tmp[@"address"]);
//        }
        
        // 字典嵌套字典
//        NSDictionary *person1 = @{@"name":@"小明",@"address":@"震泽18号"};
//        NSDictionary *person2 = @{@"name":@"张三",@"address":@"震泽18号-1"};
//        NSDictionary *person3 = @{@"name":@"李四",@"address":@"震泽18号-2"};
//        NSDictionary *stus = @{@13801234567:person1,@13801123127:person2,@13011231271:person3};
//
//        for (NSNumber *tel in stus.allKeys)
//        {
//            NSDictionary *tmpPerson = stus[tel];
//            NSLog(@"%@ %@ %@",tel,tmpPerson[@"name"],tmpPerson[@"address"]);
//        }
        
        // 对象放在一个数组中
//        Person *p1 = [[Person alloc] initWithTel:@123123123 andName:@"小明" andAddress:@"正则路18号"];
//        Person *p2 = [[Person alloc] initWithTel:@1343423 andName:@"张三" andAddress:@"正则路18号-1"];
//        Person *p3 = [[Person alloc] initWithTel:@156456435 andName:@"李四" andAddress:@"正则路18号-2"];
//        NSArray *stus = @[p1,p2,p3];
//        for (Person *p in stus)
//        {
//            NSLog(@"%@ %@ %@",p.tel,p.name,p.address);
//        }
        
        // 字典 用电话号码索引Person对象
//        Person *p1 = [[Person alloc] initWithTel:@13800000001 andName:@"小明" andAddress:@"正则路18号"];
//        Person *p2 = [[Person alloc] initWithTel:@13800000002 andName:@"张三" andAddress:@"正则路18号-1"];
//        Person *p3 = [[Person alloc] initWithTel:@13800000003 andName:@"李四" andAddress:@"正则路18号-2"];
//        NSDictionary *stus = @{@13800000001:p1,@13800000002:p2,
//                             @13800000003:p3};
//        for (NSNumber *tel in stus.allKeys)
//        {
//            Person *p = stus[tel];
//            NSLog(@"%@ %@ %@",tel,p.name,p.address);
//        }
        
#pragma mark 练习:
        // 1 创建星期英文对应中文的字典 ()
        // Monday -> 星期一
        // Tuesday -> 星期二
        // ...
        
        // 2 创建一个数字对应 甲乙丙丁...的字典
        
        // 3 使用字典保存以下信息,遍历输出
        //车型         价格(万元) //(这行不要保存在字典中,仅打印的时候输出
        //帕萨特2013     25.6
        //北京现代ix3    24.25
        //本田CR-V      20.78
        //宝马1系        24.20
        
        // 4 使用字典保存以下信息，遍历输出
        //  编号      书名  //(这行不要保存在字典中,仅打印的时候输出
        //ISBN-001  Objective-程序设计
        //ISBN-002  iOS7编程详解
        //ISBN-003  Java编程思想
        
        // 5 用一个字典保存一个学生的信息
        // 学号 1001
        // 姓名 小明
        // 数学成绩 90
        // 英语成绩 80
        // 语文成绩 100
        NSDictionary *stu = @{@"学号":@1001,@"姓名":@"小明",@"数学成绩":@90,@"英语成绩":@80};
        // 用下标访问显示输出
//        NSLog(@"%@ %@ %@ %@",stu[@"学号"],stu[@"姓名"],stu[@"数学成绩"],stu[@"英语成绩"]);
        // 遍历字典输出所有键值对
        for(NSString *key in stu.allKeys)
        {
            NSLog(@"key:%@ ->value:%@",key,stu[key]);
        }
        
#pragma mark 综合练习
        // 6 用一个可变数组嵌套可变字典的方式保存一个班级的学生信息
        //学生信息有以下几项内容:学号  姓名 数学 英语 语文
        // 以下信息通过scanf输入，输入一条学生信息后把该学生信息存在一个字典中，并把这个字典添加到可变数组中
        //1001 xiaoming 90 80 100
        //1002 zhangsan 65 75 95
        //1003 lisi 59 78 30
        // 遍历打印输出这个班学生信息
        
        char name[20];
        int stuId;
        int math;
        int english;
        int chinese;
        scanf("%i %s %i %i %i",&stuId,name,&math,&english,&chinese);
        
        // *7 使用以前的RGP游戏的类、改写成新的RPG游戏
        // 一个玩家 10个怪物 一个公主
        // 避开怪物，遇到公主，游戏胜利，遇到怪物，游戏失败
        // 使用现在所学的数组替代C的数组,保存所有游戏角色
        
        // *8 思考,尝试编写一个通讯簿管理程序,要用类实现。(书上有例子，先思考，后参考。)
        // 通讯录类、联系人类
        // 提供以下功能
        // 1 添加联系人
        // 2 删除联系人
        // 3 列出联系人
        // 4 查找联系人
        
        // 1 联系人类
        //AddressCard
        // 名字
        // 电话号码
        // 邮箱
        // 地址
        // 提供多参数初始化的方法
        
        
        
        
        // *注册以下网站的账号，后面会用到。
        // 1 www.csdn.net
        // 2 https://developer.apple.com 注册开发者
        // 3 https://github.com
        // 4 http://git.oschina.net
        
        
        
        
    }
    return 0;
}
