//
//  President.h
//  11402PresidentList
//
//  Created by student on 16/3/10.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface President : NSObject

@property(nonatomic,copy) NSString *name,*url;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)PresidentWithDict:(NSDictionary *)dict;

@end
