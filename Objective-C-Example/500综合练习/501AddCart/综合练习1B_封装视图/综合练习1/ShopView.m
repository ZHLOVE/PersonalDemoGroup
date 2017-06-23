//
//  ShopView.m
//  综合练习1
//
//  Created by niit on 16/2/26.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ShopView.h"

#import "Shop.h"

@interface ShopView()

@property (nonatomic,weak) UIImageView *iconView;
@property (nonatomic,weak) UILabel *nameLabel;

@end

@implementation ShopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// 懒加载
- (UIImageView *)iconView
{
    if(_iconView == nil)
    {
         UIImageView *imgView = [[UIImageView alloc] init];
        [self addSubview:imgView];
        _iconView = imgView;
    }
    return _iconView;
}

- (UILabel *)nameLabel
{
    if(_nameLabel == nil)
    {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _nameLabel = label;
    }
    return _nameLabel;
}

// 第一步. 添加对象
// init方法会调用initWithFrame
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        
//        // 添加图片视频
//        UIImageView *imgView = [[UIImageView alloc] init];
//        [self addSubview:imgView];
//        self.iconView = imgView;
//
//        // 添加文本标签
//        UILabel *label = [[UILabel alloc] init];
//        label.font = [UIFont systemFontOfSize:10];
//        label.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:label];
//        self.nameLabel = label;
//    }
//    return self;
//}

// 第2步. 用来布局子控件，一般在这里设定子控件的frame
// 如果当前ShopView尺寸改变的时候,就会自动调用这个方法
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    
    self.iconView.frame = CGRectMake(0, 0, width, height-10);
    self.nameLabel.frame = CGRectMake(0, height-10, width, 10);
}

// 第3步.设置模型
- (void)setShop:(Shop *)tmpShop
{
    _shop = tmpShop;

    self.nameLabel.text = _shop.name;
    self.iconView.image = [UIImage imageNamed:_shop.icon];
}


@end
