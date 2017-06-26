//
//  Round.m
//  类
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Round.h"

@implementation Round

- (float)perimeter
{
    return 2*M_PI*self.r;
}
- (float)area
{
    return M_PI*self.r*self.r;
}
@end
