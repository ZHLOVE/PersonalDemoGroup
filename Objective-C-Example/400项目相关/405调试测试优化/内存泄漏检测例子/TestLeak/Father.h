//
//  Father.h
//  TestLeak
//
//  Created by qiang on 4/25/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Child;
@interface Father : NSObject

@property (nonatomic,strong) Child *myChild;

@end
