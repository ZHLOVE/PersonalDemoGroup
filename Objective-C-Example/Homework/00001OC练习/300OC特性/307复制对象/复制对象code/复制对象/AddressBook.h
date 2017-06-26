//
//  AddressBook.h
//  综合应用
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AddressCard.h"

@interface AddressBook : NSObject<NSCopying>

@property (nonatomic,copy) NSString *bookName;
@property (nonatomic,strong) NSMutableArray *addresses;

// 添加
- (void)addCard:(AddressCard *)card;
// 查找联系人
- (AddressCard *)findCardByName:(NSString *)n;// 通过name查找,返回找到的联系人对象AddressCard,查找不到返回nil
// 删除联系人
- (void)removeCardByName:(NSString *)n;// 删除指定的联系人
- (void)removeCard:(AddressCard *)card;// 删除某联系人
// 列出联系人
- (void)print;


@end
