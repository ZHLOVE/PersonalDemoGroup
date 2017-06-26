//
//  AddressCard.h
//  综合应用
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "def.h"

@interface AddressCard : NSObject<NSCopying>

// 属性:
// 1 名字
// 2 电话号码
// 3 邮箱
// 4 地址
// 5 年龄
// 6 联系人类别(枚举类型 同事、同学、亲戚、朋友)

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *tel;
@property (nonatomic,copy) NSString *email,*address;
@property (nonatomic,assign) int age;
@property (nonatomic,assign) ContactType type;

// 如果很多电话
//@property (nonatomic,strong) NSMutableArray *tels;


- (instancetype)initWithName:(NSString *)n
                      andTel:(NSString *)t
                    andEmail:(NSString *)e
                  andAddress:(NSString *)a
                      andAge:(int)age
                     andType:(ContactType)type;
+ (instancetype)cardWithName:(NSString *)n
                      andTel:(NSString *)t
                    andEmail:(NSString *)e
                  andAddress:(NSString *)a
                      andAge:(int)age
                     andType:(ContactType)type;
- (instancetype)initWithInfoArray:(NSArray *)arr;
- (instancetype)initWithInfoDictionary:(NSDictionary *)dict;

- (void)print;

@end
