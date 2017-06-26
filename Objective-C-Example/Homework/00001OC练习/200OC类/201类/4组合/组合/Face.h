//
//  Face.h
//  组合
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Eye.h"
#import "Nose.h"

@interface Face : NSObject

// 眼睛
@property (nonatomic,strong) Eye *eye;
// 鼻子
@property (nonatomic,strong) Nose *nose;

- (NSString *)info;

@end
