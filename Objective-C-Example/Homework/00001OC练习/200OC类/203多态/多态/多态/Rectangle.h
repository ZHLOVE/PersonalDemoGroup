//
//  Rectangle.h
//  多态
//
//  Created by niit on 15/12/30.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Graphics.h"

@interface Rectangle : Graphics

@property (nonatomic,assign) float width;
@property (nonatomic,assign) float height;

- (instancetype)initWithWidth:(float)w andHeight:(float)h;
@end
