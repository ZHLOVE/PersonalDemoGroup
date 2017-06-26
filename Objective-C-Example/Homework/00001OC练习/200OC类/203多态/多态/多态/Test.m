//
//  Test.m
//  多态
//
//  Created by niit on 15/12/30.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Test.h"

@implementation Test

- (void)printInfo1
{
    NSLog(@"%s",__func__);
}
- (void)printInfo2:(NSNumber *)a
{
    NSLog(@"%s:%@",__func__,a);
}
- (NSNumber *)printInfo3:(NSNumber *)a andB:(NSNumber *)b
{
    NSLog(@"%s:%@ %@",__func__,a,b);
    return @([a intValue]+[b intValue]);
}

@end
