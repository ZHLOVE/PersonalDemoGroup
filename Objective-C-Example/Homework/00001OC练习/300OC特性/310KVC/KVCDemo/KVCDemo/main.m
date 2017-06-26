//
//  main.m
//  KVCDemo
//
//  Created by niit on 16/1/13.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Book.h"
#import "BookStore.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        
#pragma mark - KVC
        // 设置方法 (属性或者实例变量)
        //- (void)setValue:(nullable id)value forKey:(NSString *)key;
        // 获取方法
        //- (nullable id)valueForKey:(NSString *)key;
        
        Book *b1 = [[Book alloc] init];
//        b1.bookName = @"Objective-C 程序设计";// [b1 setBookName:@""];
//        b1.bookArtist = @"乔布斯";
        
        // 设置
        [b1 setValue:@"Objective-C程序设计" forKey:@"bookName"];
        [b1 setValue:@"乔布斯" forKey:@"bookArtist"];
        // 获取
        NSLog(@"%@ %@",[b1 valueForKey:@"bookName"],[b1 valueForKey:@"bookArtist"]);
        
#pragma mark - 通过动态改变key,设置不同的属性
        //        b1.v1 = 1;
        //        b1.v2 = 2;
        //        //...
        //        b1.v10 = 10;
        
        // =>
        for (int i=1; i<10; i++)
        {
            NSString *str = [NSString stringWithFormat:@"v%i",i];
            [b1 setValue:@(i) forKey:str];
        }
        
#pragma mark - 使用KVC简化 通过字典初始化对象的方法
////        NSArray *arr = @[@{@"bookName":@"Objective-C",@"bookArtist":@"乔布斯"},
////                         @{@"bookName":@"iOS 9.0编程大全",@"bookArtist":@"库克"},
////                         @{@"bookName":@"iOS 10.0编程",@"bookArtist":@"强"}];
        NSArray *arr = @[@{@"name":@"Objective-C",@"bookArtist":@"乔布斯",@"price":@13},
                         @{@"name":@"iOS 9.0",@"bookArtist":@"库克",@"price":@13},
                         @{@"name":@"iOS 10.0",@"bookArtist":@"强",@"price":@130}];
        NSMutableArray *mArr = [NSMutableArray array];
        for(NSDictionary *d in arr)
        {
            Book *b = [Book bookWithDictionary:d];
            [mArr addObject:b];
        }
//        for (Book *b in mArr)
//        {
//            NSLog(@"%@",b);
//        }
        
#pragma mark - 通过KeyPath对 对象中的子属性进行设置和读取
        // 获取
//        - (nullable id)valueForKeyPath:(NSString *)keyPath;
        // 设置
//        - (void)setValue:(nullable id)value forKeyPath:(NSString *)keyPath;
        
        BookStore *bookStore = [[BookStore alloc] init];
        bookStore.aBook = b1;
        
        // 属性
//        bookStore.aBook.bookName = @"iOS编程";
        // KVC
        [bookStore.aBook setValue:@"iOS编程" forKey:@"bookName"];
        [bookStore setValue:@"iOS编程" forKeyPath:@"aBook.bookName"];// KeyPath
        
#pragma mark - 对数组的运算
        //@avg  @max @min @sum @count
        //@distinctUnionOfObjects 清除重复值 @unionOfObjects 保留重复值
        
        bookStore.books = mArr;
        NSLog(@"%@",[bookStore valueForKeyPath:@"books.bookName"]);// 所有书名的数组
        NSLog(@"%@",[bookStore valueForKeyPath:@"books.@count"]);// 数量
        NSLog(@"%@",[bookStore valueForKeyPath:@"books.price"]);// 所有的价格数组
        NSLog(@"%@",[bookStore valueForKeyPath:@"books.@distinctUnionOfObjects.price"]);// 排除相同价格的价格数组
        NSLog(@"%@",[bookStore valueForKeyPath:@"books.@avg.price"]);// 平均价格
        NSLog(@"%@",[bookStore valueForKeyPath:@"books.@max.price"]);// 最高价格
        NSLog(@"%@",[bookStore valueForKeyPath:@"books.@min.price"]);// 最低价格
        NSLog(@"%@",[bookStore valueForKeyPath:@"books.@sum.price"]);// 总价格
        
#pragma mark -
        // 根据数组列出的key获取对象属性的值放入一个字典
        //- (NSDictionary<NSString *, id> *)dictionaryWithValuesForKeys:(NSArray<NSString *> *)keys;
        // 通过字典设置对象的属性值
        //- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *, id> *)keyedValues;
        
        NSDictionary *dict = [bookStore.aBook dictionaryWithValuesForKeys:@[@"bookName",@"price"]];
        NSLog(@"%@",dict);
        
        // 结果:
//        {
//            bookName = "iOS编程";
//            price = 0;
//        }
        
#pragma mark - 练习
// 1 Student类
// 学号 姓名 年龄
// 在main中使用KVC中修改它的姓名和年龄
// 提供以下方法
// - (id)initWithDictionary:(NSDictionary *)d;
// + (id)studentWithDictionary:(NSDictionary *)d;

// 2 修改之前所写的LOL的Hero类,并测试
// 使用setValuesForKeysWithDictionary,简化之前所写的初始化方法

// 3 修改之前所写的保存单条微博信息的类,,并测试
// 使用setValuesForKeysWithDictionary,简化之前所写的初始化方法
        
        
    }
    return 0;
}
