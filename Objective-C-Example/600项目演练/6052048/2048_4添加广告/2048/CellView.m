//
//  CellView.m
//  2048
//
//  Created by niit on 16/3/21.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "CellView.h"


@implementation CellView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = kCellPadding;
        [self changeBackgroundColor];
    }
    return self;
}

- (void)setNumber:(int)number
{
    _number = number;
    
    if(_number != 0)
    {
        self.numberLabel.text = [NSString stringWithFormat:@"%i",number];
    }
    [self changeBackgroundColor];
}

- (UILabel *)numberLabel
{
    if(_numberLabel == nil)
    {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.frame = self.bounds;
        NSLog(@"%@",NSStringFromCGRect(self.bounds));
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = [UIColor whiteColor];
//        _numberLabel.font = [UIFont systemFontOfSize:40];
        _numberLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:50];
        _numberLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _numberLabel.minimumScaleFactor = 0.1;
        [self addSubview:_numberLabel];
    }
    return _numberLabel;
}

- (void)changeBackgroundColor
{
    NSDictionary *colorArr = @{@0:kRGBCell0,@2:kRGBCell2,@4:kRGBCell4,@8:kRGBCell8};
    self.backgroundColor = colorArr[@(self.number)];
}

@end
