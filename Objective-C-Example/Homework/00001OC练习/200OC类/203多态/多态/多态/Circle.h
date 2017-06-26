//
//  Circle.h
//  多态
//
//  Created by niit on 15/12/30.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Graphics.h"

@interface Circle : Graphics

// 半径
@property (nonatomic,assign) float r;

- (instancetype)initWithR:(float)r;

@end
