//
//  Card.h
//  继承
//
//  Created by niit on 15/12/29.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

// 余额
@property (nonatomic,assign) float money;//=> _money,Card的私有变量,子类没法访问

// 存钱
- (void)addMoney:(float)m;
// 取钱
- (BOOL)pickupMoney:(float)m;

- (void)printMoney;
@end
