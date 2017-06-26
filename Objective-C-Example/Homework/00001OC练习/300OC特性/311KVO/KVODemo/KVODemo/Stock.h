//
//  Stock.h
//  KVODemo
//
//  Created by niit on 16/1/19.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stock : NSObject

// 股票名字
@property (nonatomic,copy) NSString *name;
// 价格
@property (nonatomic,assign) float price;

- (instancetype)initWithName:(NSString *)n andPrice:(float)p;

@end
