//
//  Flag.h
//  SelectFlag
//
//  Created by niit on 16/3/9.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlagModel : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *imageName;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)flagWithDict:(NSDictionary *)dict;

@end
