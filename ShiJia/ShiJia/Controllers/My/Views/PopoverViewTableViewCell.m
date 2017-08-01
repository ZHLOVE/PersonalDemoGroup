//
//  PopoverViewTableViewCell.m
//  TakeoutUserApp
//
//  Created by iss on 14-9-10.
//  Copyright (c) 2014年 YouYan. All rights reserved.
//

#import "PopoverViewTableViewCell.h"
@interface PopoverViewTableViewCell ()



@end

@implementation PopoverViewTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
//    [self.lineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(0.5);
//    }];
    self.backgroundColor = kColorLightGrayBackground;
    self.contentView.backgroundColor = kColorLightGrayBackground;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    if (checked) {
        self.checkImgView.image = [UIImage imageNamed:@"contact_list_checked"];
        self.titleLabel.textColor = kColorBlueTheme;
    }
    else{
        self.checkImgView.image = [UIImage imageNamed:@"contact_list_uncheck"];
        self.titleLabel.textColor = [UIColor darkGrayColor];
    }
}
//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    [super setHighlighted:highlighted animated:animated];
//    
//    if (highlighted) {
//        [self setBackgroundColor:HIGHTLIGHTED_GRAY_WEIXINSTYLE_COLOR];
//    }
//    else{
//        [self setBackgroundColor:[UIColor whiteColor]];
//    }
//}

////画底边线条
//-(void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(context, MAIN_SP_COLOR.CGColor);//线条颜色
//    CGContextSetLineWidth(context, 0.5);
//    CGContextMoveToPoint(context, 0, self.contentView.frame.size.height);//起点
//    CGContextAddLineToPoint(context, self.contentView.frame.size.width, self.contentView.frame.size.height);//终点
//    CGContextStrokePath(context);
//}

@end
