//
//  main.m
//  复制对象
//
//  Created by niit on 16/1/11.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Student.h"
#import "AddressCard.h"
#import "AddressBook.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
#pragma mark - Foundation下 NSString NSArray copy 分析
        // NSString
        NSString *str1 = @"abc";
        NSString *str2 = [str1 copy];// 对于NSString copy 不产生新的对象
        NSString *str3 = str1;
        
        NSLog(@"%@,%@,%@",str1,str2,str3);
        NSLog(@"%p,%p,%p",str1,str2,str3);
        
        NSMutableString *mStr1 = [str1 mutableCopy];
        NSMutableString *mStr2 = [mStr1 mutableCopy];
        
        NSLog(@"%@,%@",mStr1,mStr2);
        NSLog(@"%p,%p",mStr1,mStr2);
        
        // NSArray
        NSArray *arr1 = @[@1,@2,@3];
        NSArray *arr2 = [arr1 copy];// 不产生新的对象
        NSMutableArray *mArr1 = [arr2 mutableCopy];
        NSMutableArray *mArr2 = [mArr1 mutableCopy];
        
        NSLog(@"%p,%p,%p,%p",arr1,arr2,mArr1,mArr2);
        
        // 复制对象
//        NSArray *arr = @[@"a",@"b",@"c"];
//        NSArray *arr2 = [arr copy];// 不可变复制品
//        NSMutableArray *mArr = [arr mutableCopy];// 可变复制品

#pragma mark - 自定义类对象的赋值

        Student *stu1 = [[Student alloc] initWithId:@"10001" andName:@"zhangsan" andReward:100];
        Student *stu2 = [stu1 copy];//自定的类需要遵守NSCopying协议的类才可以通过copy实现复制
        stu2.stuName = @"lisi";
        
        NSLog(@"%@",stu1);
        NSLog(@"%@",stu2);
        
        // 练习:
        // 1 找到以前写的联系人类AddressCard，给他加上NSCoping协议
        // 联系人姓名
        // 电话
        // 联系人地址
        // 2 找到以前写的通讯簿类AddressBook，给他加上NSCoping协议
        // 通讯录名称
        // 通讯录联系人卡片数组

        AddressCard *c1 = [[AddressCard alloc] initWithName:@"xiaoming" andTel:@"1380001" andEmail:@"138@qq.com" andAddress:@"zhenzelu-18" andAge:18 andType:kContactTypeClassmate];
        AddressCard *c2 = [c1 copy];
        AddressCard *c3 = [[AddressCard alloc] initWithName:@"lisi" andTel:@"1380001" andEmail:@"138@qq.com" andAddress:@"zhenzelu-18" andAge:18 andType:kContactTypeClassmate];
        AddressCard *c4 = [[AddressCard alloc] initWithName:@"wangwu" andTel:@"1380001" andEmail:@"138@qq.com" andAddress:@"zhenzelu-18" andAge:18 andType:kContactTypeClassmate];
        c2.name = @"zhangsan";
        
//        NSLog(@"%@",c1);
//        NSLog(@"%@",c2);
        
        AddressBook *b1 = [[AddressBook alloc] init];
        [b1 addCard:c1];
        AddressBook *b2 = [b1 copy];
        [b2 addCard:c3];
        [b2 addCard:c4];
        NSLog(@"通讯录1:");
        [b1 print];
        NSLog(@"通讯录2:");
        [b2 print];
        
        // b1 和 b2 里有共同的元素是小明，如果你修改b1里的小明card，b2里的小明card也会被修改
        // 彻底复制后，不会被改变
        AddressCard *c = [b1 findCardByName:@"xiaoming"];
        c.age = 100;
        
        NSLog(@"通讯录2:");
        [b2 print];

    }
    return 0;
}
