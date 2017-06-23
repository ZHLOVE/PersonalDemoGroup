//
//  UILabel+Creation.m
//  Weibo
//
//  Created by qiang on 5/5/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "UILabel+Creation.h"

@implementation UILabel (Creation)

+ (UILabel *)createLabelWithColor:(UIColor *)color fontSize:(CGFloat)fontSize
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}


- (void)topAlignment{
    CGSize size = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
    self.numberOfLines = 0;//为了添加\n必须为0
    NSInteger newLinesToPad = (self.frame.size.height - rect.size.height)/size.height;

    for (NSInteger i = 0; i < newLinesToPad; i ++) {
        self.text = [self.text stringByAppendingString:@"\n "];
    }
}

@end
