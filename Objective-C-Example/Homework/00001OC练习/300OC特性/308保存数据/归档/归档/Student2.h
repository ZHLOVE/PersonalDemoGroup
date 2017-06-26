//
//  Student2.h
//  归档
//
//  Created by niit on 16/1/13.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student2 : NSObject

@property (nonatomic,copy) NSString *stuId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) int age;
@property (nonatomic,assign) int reward;

- (instancetype)initWithDictionary:(NSDictionary *)d;

@end
