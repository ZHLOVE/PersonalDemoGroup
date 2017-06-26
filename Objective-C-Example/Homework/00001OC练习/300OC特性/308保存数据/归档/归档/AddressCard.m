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

#pragma mark - init
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
#pragma mark - Print Info
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

#pragma mark - NSCoping
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
    
    //3
    return c;
}

#pragma mark - NSCoding

#define kName @"name"
#define kTel @"tel"
#define kEmail @"email"
#define kAddress @"address"
#define kAge @"age"
#define kType @"type"

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:kName];
    [aCoder encodeObject:self.tel forKey:kTel];
    [aCoder encodeObject:self.email forKey:kEmail];
    [aCoder encodeObject:self.address forKey:kAddress];
    [aCoder encodeInt:self.age forKey:kAge];
    [aCoder encodeInt:self.type forKey:kType];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.name = [aDecoder decodeObjectForKey:kName];
        self.age = [aDecoder decodeIntForKey:kAge];
        self.tel = [aDecoder decodeObjectForKey:kTel];
        self.email = [aDecoder decodeObjectForKey:kEmail];
        self.address = [aDecoder decodeObjectForKey:kAddress];
        self.type = [aDecoder decodeIntForKey:kType];
    }
    return self;
}

@end
