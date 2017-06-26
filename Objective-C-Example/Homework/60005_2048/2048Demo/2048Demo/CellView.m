//
//  CellView.m
//  2048Demo
//
//  Created by student on 16/3/21.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "CellView.h"

@implementation CellView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = kCellCornerRadius;
        self.backgroundColor = k2CellColor;
    }
    return self;
}

- (void)setNumber:(int)number{
    _number = number;
    if (_number != 0 ) {
        self.numberLabel.text = [NSString stringWithFormat:@"%i",number];
    }
}

//设置单元格
- (UILabel *)numberLabel{
    if (_numberLabel == nil) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.frame = self.bounds;
//        NSLog(@"%@",NSStringFromCGRect(self.bounds));
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.font = [UIFont systemFontOfSize:40];
        _numberLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _numberLabel.minimumScaleFactor = 0.1;
        [self addSubview:_numberLabel];
    }
    return _numberLabel;
}
@end
