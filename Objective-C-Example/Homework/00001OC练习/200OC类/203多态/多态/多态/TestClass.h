//
//  TestClass.h
//  多态
//
//  Created by niit on 15/12/30.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Graphics.h"

@interface TestClass : Graphics

- (void)printInfo;

- (void)printInfo2:(NSNumber *)a;

- (void)printInfo3:(NSNumber *)a andB:(NSNumber *)b;

- (NSNumber *)printInfo4:(NSNumber *)a andB:(NSNumber *)b;

@end
