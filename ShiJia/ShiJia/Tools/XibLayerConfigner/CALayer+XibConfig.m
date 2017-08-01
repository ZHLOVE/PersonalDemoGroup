//
//  CALayer+XibConfig.m
//  AI3
//
//  Created by 峰 on 2017/1/11.
//  Copyright © 2017年 峰. All rights reserved.
//

#import "CALayer+XibConfig.h"

@implementation CALayer (XibConfig)

-(void)setBorderUIColor:(UIColor*)color{

    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor{

    return [UIColor colorWithCGColor:self.borderColor];
}
@end
