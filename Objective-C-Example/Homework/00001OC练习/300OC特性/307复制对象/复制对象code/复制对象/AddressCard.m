//
//  AddressCard.m
//  综合应用
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "AddressCard.h"

#import "CommFunc.h"

@implementation AddressCard

//@property (nonatomic,copy) NSString *name;
//@property (nonatomic,copy) NSString *tel;
//@property (nonatomic,copy) NSString *email,*address;
//@property (nonatomic,assign) int age;
//@property (nonatomic,assign) ContactType type;

- (instancetype)initWithName:(NSString *)n
                      andTel:(NSString *)t
                    andEmail:(NSString *)e
                  andAddress:(NSString *)a
                      andAge:(int)age
                     andType:(ContactType)type
{
    self = [super init];
    if (self) {
        self.name  = n;
        self.tel = t;
        self.email = e;
        self.address = a;
        self.age = age;
        self.type = type;
    }
    return self;
}

+ (instancetype)cardWithName:(NSString *)n
                      andTel:(NSString *)t
                    andEmail:(NSString *)e
                  andAddress:(NSString *)a
                      andAge:(int)age
                     andType:(ContactType)type
{
    return [[[self class] alloc] initWithName:n andTel:t andEmail:e andAddress:a andAge:age andType:type];
}


- (instancetype)initWithInfoArray:(NSArray *)arr
{
    self = [super init];
    if (self) {
        self.name  = arr[0];
        self.tel = arr[1];
        self.email = arr[2];
        self.address = arr[3];
        self.age = [arr[4] intValue];
        self.type = [arr[5] intValue];
    }
    return self;
}


- (instancetype)initWithInfoDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.name  = dict[@"name"];
        self.tel = dict[@"tel"];
        self.email = dict[@"email"];
        self.address = dict[@"address"];
        self.age = [dict[@"age"] intValue];
        self.type = [dict[@"type"] intValue];
    }
    return self;
}

- (void)print
{
//    NSLog(@"%@ %@ %@  %@ %i %@",self.name,self.tel,self.email,self.address,self.age,contatctTypeToString(self.type));
    NSLog(@"%@ %@ %@  %@ %i %@",self.name,self.tel,self.email,self.address,self.age,[CommFunc contatctTypeToString:self.type]);
}

// 对象的描述
- (NSString *)description
{
    NSString *str = [[NSString alloc] initWithFormat:@"%@ %@ %@  %@ %i %@",self.name,self.tel,self.email,self.address,self.age,[CommFunc contatctTypeToString:self.type]];
    return str;
}

// 关于本类的描述
+ (NSString *)description
{
    return @"联系人类";
}

//@property (nonatomic,copy) NSString *name;
//@property (nonatomic,copy) NSString *tel;
//@property (nonatomic,copy) NSString *email,*address;
//@property (nonatomic,assign) int age;
//@property (nonatomic,assign) ContactType type;

- (id)copyWithZone:(nullable NSZone *)zone
{
    //1
    AddressCard *c = [[[self class] allocWithZone:zone] init];
    //2
    c.name = self.name;
    c.tel = self.tel;
    c.email = self.email;
    c.address = self.address;
    c.age = self.age;
    c.type = self.type;
    
    c.tels = [[NSMutableArray alloc] init];
//    for (NSString *tel in self.tels)
//    {
//        [book.addresses addObject:[tel copy]];
//    }
    
    //3
    return c;
}


@end
