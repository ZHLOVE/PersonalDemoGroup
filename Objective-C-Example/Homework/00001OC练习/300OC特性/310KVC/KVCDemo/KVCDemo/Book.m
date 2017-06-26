//
//  Book.m
//  KVCDemo
//
//  Created by niit on 16/1/13.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Book.h"

@implementation Book

//使用KVC简化初始化方法
- (instancetype)initWithDictionary:(NSDictionary *)d
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:d];// 字典中的key 必须和你的属性一致才行
        
//        self.bookName = d[@"bookName"];
//        self.bookArtist = d[@"bookArtist"];
//        self.price = d[@"price"];
        
    }
    return self;
}

+ (instancetype)bookWithDictionary:(NSDictionary *)d
{
    Book *b = [[Book alloc] initWithDictionary:d];
    return b;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"书名:%@ 作者:%@",self.bookName,self.bookArtist];
//    return [NSString stringWithFormat:@"书名:%@ 作者:%@",bookName,bookArtist];
}

// 如果有不一致的，必须处理一下不一致的属性
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"name"])
    {
        [self setValue:value forKey:@"bookName"];
    }
}
@end
