//
//  XCFTableViewCell.m
//  LGJ
//
//  Created by student on 16/5/17.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "XCFTableViewCell.h"
#import "def.h"

// 定义之后可以不用带mas_前缀
#define MAS_SHORTHAND
// 定义之后equalTo等于mas_equalTo
#define MAS_SHORTHAND_GLOBALS
#import <Masonry.h>

@implementation XCFTableViewCell

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    self.titleLabel.numberOfLines = 0;
//    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(self.titleLabel.frame.size.width, MAXFLOAT)];
//    self.titleLabel.bounds = CGRectMake(0, 0, size.width, size.height);
//
//}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descLabel];
    
    [self.imgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(0).offset(5);
        make.bottom.equalTo(0).offset(-5);
        make.width.equalTo(self.imgView.height);
    }];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.right).offset(10);
        make.top.equalTo(self.imgView.top);
        make.right.equalTo(0);
        make.height.equalTo(50);
    }];
    [self.descLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.right).offset(10);
        make.top.equalTo(self.titleLabel.bottom);
        make.right.equalTo(0);
        make.height.equalTo(50);
    }];
    
   
}


#pragma mark懒加载
- (UIImageView *)imgView{
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc]init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        //设置圆形
        _imgView.layer.cornerRadius=15;
    }
    return _imgView;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel createLabelWithColor:[UIColor blackColor] fontSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)descLabel{
    if (_descLabel == nil) {
        _descLabel = [UILabel createLabelWithColor:[UIColor blackColor] fontSize:14];
        _descLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _descLabel;
}



@end
