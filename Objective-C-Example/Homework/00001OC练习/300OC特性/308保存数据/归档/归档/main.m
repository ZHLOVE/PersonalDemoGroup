//
//  main.m
//  归档
//
//  Created by niit on 16/1/12.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Car.h"
#import "Student.h"
#import "Student2.h"
#import "AddressCard.h"
#import "AddressBook.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
#pragma mark - 一、属性列表 plist
        
        // plist 文件实质上是一个xml文件
        
//        * plist 是property list的缩写。plist中包括一些命名值和使用Core Foundation类型创建的值的列表。这些类型包括CFString, CFNumber, CFBoolean, CFData, CFDate, CFArray, 以及CFDictionary。利用这些类型创建的数据能够高效的组织、存储和访问。plist编程接口使得分级组织的数据类型能够和XML之间相互转换。XML数据可以存储下来以便以后重建原来的一些Core Fundation对象。plist应当用于主要是由字符串和数字组成的数据，否则的话它一般效率都会较低。
//        *list主要有Core Fundation类型构成，也可以将这些类型放入CFDictionary和CFArray中以便构成更复杂的数据类型。在property list中，<plist>表示将property list转换为XML表。
//        *Core Fundationary类型与XML对应关系为：
//        Core Fundation         XML
//        CFString              <string>
//        CFNumber              <real> 或 <integer>
//        CFDate                <date>
//        CFBoolean             <true/> 或 <false/>
//        CFData                <data>
//        CFArray               <array>
//        CFDictionary          <dict>
//        在CFDictionary中数据主要由键值对组成。因此在XML中，CFDictioary成员的键对应为<key>，之后便是它相应的值。
        
#pragma mark 1.NSArray、NSDictionary保存成plist文件
        // 文件路径
//        NSString *dictPath = [NSHomeDirectory() stringByAppendingString:@"/dict.plist"];//plist文件一般后缀是.plist，实际上是文本文件
//        NSString *arrPath = [NSHomeDirectory() stringByAppendingString:@"/arr.plist"];
//        NSArray *arr = @[@"张三",@"李四",@"王五"];
//        NSDictionary *dict = @{@"学号":@"10001",@"姓名":@"张三",@"身高":@180};
        
        // NSArray -> arr.plist
//        [arr writeToFile:arrPath atomically:YES];// 数组写入到文件(以plist格式保存)
        // NSDictionary -> dict.plist
//        [dict writeToFile:dictPath atomically:YES];// 字典写入到文件
        
#pragma mark 2.从plist文件读取出NSArray、NSArray
        // arr.plist -> stuArr
//        NSArray *stuArr = [NSArray arrayWithContentsOfFile:arrPath];// 根据文件内容创建数组,文件需要是plist格式
//        NSLog(@"%@",stuArr);
        // dict.plist -> stuInfo
//        NSDictionary *stuInfo = [NSDictionary dictionaryWithContentsOfFile:dictPath];// 根据文件内容创建字典,文件需要是plist格式
//        NSLog(@"%@",stuInfo);
        
#pragma mark 3.应用:
        // 1) 从plist文件中将信息读取出来恢复成对象
//        NSDictionary *carInfo = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingString:@"/Car.plist"]];
//        Car *aCar = [[Car alloc] initWithDictionary:carInfo];
//        
//        NSLog(@"品牌:%@ 车型:%@ 价格:%i万",aCar.brand,aCar.type,aCar.price);
        
        // 2) 从plist文件中将信息读取出来恢复成对象数组
//        NSArray *carsInfo = [NSArray arrayWithContentsOfFile:[NSHomeDirectory() stringByAppendingString:@"/CarTypes.plist"]];
//        NSMutableArray *cars = [[NSMutableArray alloc] init];
//        for(NSDictionary *dict in carsInfo)
//        {
//            Car *car = [[Car alloc] initWithDictionary:dict];
//            [cars addObject:car];
//        }
//        
//        for(Car *c in cars)
//        {
//            NSLog(@"品牌:%@ 车型:%@ 价格:%i万",c.brand,c.type,c.price);
//        }
        
//练习一下
//1
//1)尝试以不同类型的容易保存整个班级信息,并保存到属性列表文件,观察列表文件的格式
//学号   姓名       年龄   成绩
//10001 zhangsan   18    98
//10002 lisi       20    65
//10003 wangwu     65    76
//NSArray *arr1 = @[@{@"stuId":@"10001",
//                    @"name":@"zhangsan",
//                    @"age":@18,
//                    @"reward":@98},
//                  @{@"stuId":@"10002",
//                    @"name":@"lisi",
//                    @"age":@20,
//                    @"reward":@65},
//                    @{@"stuId":@"0003",@"name":@"wangwu",@"age":@65,@"reward":@76}];
//[arr1 writeToFile:@"stusInfo.plist" atomically:YES];
        
//  2)创建一个Student2类
//读取1创建的plist文件,将学生信息读取出来存入到Student类的对象中,再将Student2放入一个数组
//为Student添加一个方法
//- (id)initWithDictionary:(NSDictionary *)d;
        
//        NSArray *arr2 = [NSArray arrayWithContentsOfFile:@"stusInfo.plist"];
//        NSMutableArray *mStus = [NSMutableArray array];
//        for (NSDictionary *d in arr2)
//        {
//            Student2 *stu = [[Student2 alloc] initWithDictionary:d];
//            [mStus addObject:stu];
//        }
//
//        for (Student2 *stu in mStus)
//        {
//            NSLog(@"%@ %@ %i %i",stu.stuId,stu.name,stu.age,stu.reward);
//        }
        
        
//2 定义一个LOL的Hero类(提示:参照前面CarTypes.plist的例子)
//图片名称 icon
//介绍 intro
//名字 name
//从hero.plist把信息读取出来，创建一个Hero类的对象数组，遍历对象数组打印出来

        //3 分析sortednames.plist，,把内容取出来，遍历输出所有名字
//        NSDictionary *nameDict = [NSDictionary dictionaryWithContentsOfFile:@"sortednames.plist"];
//        
//        for(NSString *key in nameDict.allKeys)
//        {
//            NSLog(@"=========================%@",key);
//            
//            NSArray *names = nameDict[key];
//            
//            for (NSString *name in names)
//            {
//                NSLog(@"%@",name);
//            }
//        }
        
        
        //4 分析结构area1.plist的结构,把内容取出来，并遍历输出所有省会及城市
        NSArray *areas = [NSArray arrayWithContentsOfFile:@"area1.plist"];
        for (NSDictionary *provinceDict in areas)
        {
            NSLog(@"省:%@",provinceDict[@"State"]);
            
            NSArray *cities = provinceDict[@"Cities"];// 取出城市列表
            for(NSDictionary *cityDict in cities)
            {
                NSLog(@"城市名:%@",cityDict[@"city"]);
            }
        }
        
        
//5 weibo.plist是一个保存了多条微博数据数plist文件，分析其结构
// 编写一个类用于保存单条微博数据
// 创建一个数组保存所有单挑微博数据对象,遍历输出
        
#pragma mark - 二、归档

        // 归档 NSKeyedArchiver 对象 -> 文件
        // 解档 NSKeyedUnArchiver 文件 -> 对象
        
#pragma mark 1.简单对象归档
//        Student *stu = [[Student alloc] init];
//        stu.name = @"小明";
//        stu.age = 18;
        // 1)归档 stu对象 -> stu.plist
//        [NSKeyedArchiver archiveRootObject:stu toFile:@"stu.plist"];
        
        // 2)解档 stu.plist -> stu对象
//        Student *stu2 = [NSKeyedUnarchiver unarchiveObjectWithFile:@"stu.plist"];
//        NSLog(@"%@",stu2);
        
        // 练习:
        // 1 让AddressCard支持归档,并测试。
//        AddressCard *c1 = [[AddressCard alloc] initWithName:@"xiaoming" andTel:@"1380001" andEmail:@"138@qq.com" andAddress:@"zhenzelu-18" andAge:18 andType:kContactTypeClassmate];
//        [NSKeyedArchiver archiveRootObject:c1 toFile:@"card.plist"];// 已有，覆盖一次
//        
//        AddressCard *c2 = [NSKeyedUnarchiver unarchiveObjectWithFile:@"card.plist"];
//        NSLog(@"%@",c2);
        
#pragma mark 2.复杂对象(含有子对象的对象,子对象的类也要必须实现归档)归档

        
        // 1) 数组归档
        // NSArray NSDictionary已自己支持归档的,数组、字典里的子对象所属的类也要支持归档，数组和字典才能归档。
        
        // 归档 NSMutableArray对象 -> cards.plist
//        AddressCard *c2 = [[AddressCard alloc] initWithName:@"xiaoming" andTel:@"1380001" andEmail:@"138@qq.com" andAddress:@"zhenzelu-18" andAge:18 andType:kContactTypeClassmate];
//        AddressCard *c3 = [[AddressCard alloc] initWithName:@"lisi" andTel:@"1380001" andEmail:@"138@qq.com" andAddress:@"zhenzelu-18" andAge:18 andType:kContactTypeClassmate];
//        
//        NSMutableArray *mArr = [[NSMutableArray alloc] init];
//        [mArr addObject:c2];
//        [mArr addObject:c3];
//        [NSKeyedArchiver archiveRootObject:mArr toFile:@"cards.plist"];
        
        // 解档 cards.plist -> NSMutableArray对象
//        NSMutableArray *mArr = [NSKeyedUnarchiver unarchiveObjectWithFile:@"cards.plist"];
//        AddressCard *c4 = [[AddressCard alloc] initWithName:@"wangwu" andTel:@"1380001" andEmail:@"138@qq.com" andAddress:@"zhenzelu-18" andAge:18 andType:kContactTypeClassmate];
//        [mArr addObject:c4];
//        for(AddressCard *c in mArr)
//        {
//            NSLog(@"%@",c);
//        }
        
        // 2) 复杂对象归档
        // AddressBook 要支持归档，他的子元素AddressCard也要支持归档，AddresBook才能支持归档。
        
        // 归档 AddressBook对象 -> book.plist
//        AddressCard *c1 = [[AddressCard alloc] initWithName:@"xiaoming" andTel:@"1380001" andEmail:@"138@qq.com" andAddress:@"zhenzelu-18" andAge:18 andType:kContactTypeClassmate];
//        AddressCard *c2 = [[AddressCard alloc] initWithName:@"lisi" andTel:@"1380001" andEmail:@"138@qq.com" andAddress:@"zhenzelu-18" andAge:18 andType:kContactTypeClassmate];
//        AddressCard *c3 = [[AddressCard alloc] initWithName:@"wangwu" andTel:@"1380001" andEmail:@"138@qq.com" andAddress:@"zhenzelu-18" andAge:18 andType:kContactTypeClassmate];
//        AddressBook *b1 = [[AddressBook alloc] init];
//        b1.bookName = @"同学录";
//        [b1 addCard:c1];
//        [b1 addCard:c2];
//        [b1 addCard:c3];
//        
//        [NSKeyedArchiver archiveRootObject:b1 toFile:@"book.plist"];
        
        // 解档 book.plist -> AddressBook对象
//        AddressBook *b2 = [NSKeyedUnarchiver unarchiveObjectWithFile:@"book.plist"];
//        [b2 print];
//
        
#pragma mark 3.多对象归档到一个文件
        // 归档
        // 一个stu对象、一个b1对象, -> all.plist
//        NSMutableData *mData = [NSMutableData data];// 创建一个可变二进制数据对象
//        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];// 创建一个归档对象,设定归档结果存入mData
//        [archiver encodeObject:stu forKey:@"Student"];// 归档stu对象
//        [archiver encodeObject:b1 forKey:@"Book"];// 归档b1对象
//        [archiver finishEncoding];// 归档结束
//        [mData writeToFile:@"all.plist" atomically:YES];// 数据存入文件
        
        // 解档
        // all.plist -> 一个stu对象、一个b1对象
//        NSData *data = [NSData dataWithContentsOfFile:@"all.plist"];// 从文件中读取出二进制数据
//        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];// 创建解档对象
//        Student *stu = [unArchiver decodeObjectForKey:@"Student"];// 从解档对象中取出学生对象
//        AddressBook *book = [unArchiver decodeObjectForKey:@"Book"];// 从解档对象中取出通讯录对象
//        [unArchiver finishDecoding];// 结束解档
//        
//        NSLog(@"%@",stu);
//        NSLog(@"%@",book);
        
        
#pragma mark - 综合练习
// 1 思考一下:plist方式和归档方式都能实现数据的保存，他们有什么区别？什么时候用归档比较好?什么时候用plist比较好?

// 2 将以下游戏关卡信息,保存到plist文件中 (不用代码,直接xcode创建编辑plist文件)
//             游戏地图文件    小怪物数量 中怪物数量  Boss数量
//   第一关     map1.plist          3       2        0
//   第二关     map2.plist          5       3        1
//   第三关     map3.plist          10      4        3

// 3 改写以前所写一个猜拳游戏,添加排行榜功能。排行榜(模式1 模式2的两个排行榜)要保存下来,记录以前的最高分.
// 制作一个猜拳游戏。玩家可以选择玩哪种模式。
// 模式1:猜拳10次，统计输赢次数结果
// 模式2:一直玩到玩家输10次为止。最后显示输赢次数结果
// 游戏结束后,让玩家输入用户名，记录他的分数到排行榜

// 4 复制两份之前所写通讯录管理程序,实现保存的功能,再次打开程序的时候要将以前输入的联系人信息读取出来。
//1)用plist方式保存通讯录信息,
//2)用归档方式

// **5 制作一个游戏地图编辑器
// 可以制作、编辑、打印游戏地图plist文件
//◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️
//◻️◻️🎄◻️◻️◻️◻️◻️◻️◻️
//◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️
//◻️◻️◻️◻️◻️◻️🎄◻️◻️◻️
//◻️🎄◻️◻️◻️◻️◻️◻️◻️◻️
//◻️◻️◻️◻️◻️◻️◻️◻️🚩◻️
//◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️
        

        
        

    }
    return 0;
}
