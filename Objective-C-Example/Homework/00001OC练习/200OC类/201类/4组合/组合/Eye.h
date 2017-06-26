//
//  Eye.h
//  组合
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "def.h"

@interface Eye : NSObject

@property (nonatomic,assign) Color color;
@property (nonatomic,assign) BOOL bShuang;

- (NSString *)info;

@end
