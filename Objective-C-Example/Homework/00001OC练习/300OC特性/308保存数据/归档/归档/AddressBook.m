//
//  AddressBook.m
//  综合应用
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "AddressBook.h"

@implementation AddressBook

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.addresses = [NSMutableArray array];
    }
    return self;
}

// 添加
- (void)addCard:(AddressCard *)card
{
    [self.addresses addObject:card];
}

// 查找联系人
- (AddressCard *)findCardByName:(NSString *)n;// 通过name查找,返回找到的联系人对象AddressCard,查找不到返回nil
{
    for (AddressCard *c in self.addresses)
    {
        if([c.name isEqualToString:n])
        {
            return c;
        }
    }
    return nil;// 如果没找到
}
// 删除联系人
- (void)removeCardByName:(NSString *)n// 删除指定的联系人
{
    for (AddressCard *c in self.addresses)
    {
        if([c.name isEqualToString:n])
        {
            [self.addresses removeObject:c];
            break;
        }
    }
}
- (void)removeCard:(AddressCard *)card// 删除某联系人
{
    [self.addresses removeObject:card];
}

// 列出联系人
- (void)print
{
    NSLog(@"%@",self.bookName);
    for (AddressCard *c in self.addresses)
    {
        NSLog(@"%@",c);
    }
}

- (NSString *)description
{
    NSMutableString *mStr = [NSMutableString string];
    
    [mStr appendFormat:@"bookName:%@\n",self.bookName];
    for (AddressCard *c in self.addresses)
    {
        [mStr appendFormat:@"%@\n",c];
    }
    return mStr;
}
#pragma mark NSCoping

- (id)copyWithZone:(nullable NSZone *)zone
{
    AddressBook *book = [[[self class] allocWithZone:zone] init];
    
    book.bookName = self.bookName;
    
    // 1 浅拷贝
//    book.addresses = self.addresses;
    // 2 不完全深拷贝，数组复制了一份，但是原先的子对象还是一样
//    book.addresses = [self.addresses mutableCopy];
    // 3 彻底深拷贝，子对象完全复制一份新的
    // 子对象的类要负责实现自己类的深拷贝
    book.addresses = [[NSMutableArray alloc] init];
    for (AddressCard *c in self.addresses)
    {
        [book.addresses addObject:[c copy]];
    }
    
    return book;
}


#pragma mark - NSCoding

//@property (nonatomic,copy) NSString *bookName;
//@property (nonatomic,strong) NSMutableArray *addresses;

#define kBookName @"bookName"
#define kAddresses @"Addresses"

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.bookName forKey:kBookName];
    [aCoder encodeObject:self.addresses forKey:kAddresses];
    
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.bookName = [aDecoder decodeObjectForKey:kBookName];
        self.addresses = [aDecoder decodeObjectForKey:kAddresses];
    }
    return self;
}

@end
