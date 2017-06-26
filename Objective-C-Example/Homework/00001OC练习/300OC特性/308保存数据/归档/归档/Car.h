//
//  Car.h
//  归档
//
//  Created by niit on 16/1/12.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Car : NSObject

@property (nonatomic,copy) NSString *brand;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,assign) int price;

- (instancetype)initWithDictionary:(NSDictionary *)d;

@end
