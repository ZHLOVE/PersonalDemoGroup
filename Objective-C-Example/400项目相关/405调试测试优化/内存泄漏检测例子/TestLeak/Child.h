//
//  Child.h
//  TestLeak
//
//  Created by qiang on 4/25/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Father;

@interface Child : NSObject

@property (nonatomic,strong) Father *myFather;

@end
