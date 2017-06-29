//
//  Employers.h
//  WingsBurning
//
//  Created by MBP on 16/8/22.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  公司请求列表
 */
@interface Employers : NSObject

@property(nonatomic,copy)NSNumber *page;
@property(nonatomic,copy)NSNumber *per_page;
@property(nonatomic,copy)NSString *name;

@end
