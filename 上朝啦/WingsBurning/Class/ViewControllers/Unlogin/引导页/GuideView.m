//
//  GuideView.m
//  WingsBurning
//
//  Created by MBP on 2016/9/28.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "GuideView.h"


@interface GuideView()

@property (nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *firstLabel;
@property(nonatomic,strong) UILabel *secondLabel;

@end

@implementation GuideView

- (void)setImageName:(NSString *)imageName{
    [self.imageView setImage:[UIImage imageNamed:imageName]];
}

- (void)setFirstStr:(NSString *)firstStr{
    self.firstLabel.text = firstStr;
}

- (void)setSecondStr:(NSString *)secondStr{
    self.secondLabel.text = secondStr;
}


- (void)loadUI{
    __weak typeof (self) weakSelf = self;
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(100 * ratio);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.height.mas_equalTo(246 * ratio);
        make.width.mas_equalTo(weakSelf);
    }];
    [self addSubview:self.firstLabel];
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.imageView.mas_bottom).offset(45 * ratio);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.height.mas_equalTo(27 * ratio);
        make.width.mas_equalTo(weakSelf);
    }];
    [self addSubview:self.secondLabel];
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.firstLabel.mas_bottom).offset(22 * ratio);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.height.mas_equalTo(17 * ratio);
        make.width.mas_equalTo(weakSelf);
    }];
}



#pragma mark-懒加载
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UILabel *)firstLabel{
    if (_firstLabel == nil) {
        _firstLabel = [[UILabel alloc]init];
        _firstLabel.font = [UIFont systemFontOfSize:27];
        _firstLabel.textColor = [UIColor whiteColor];
        _firstLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _firstLabel;
}

- (UILabel *)secondLabel{
    if (_secondLabel == nil) {
        _secondLabel = [[UILabel alloc]init];
        _secondLabel.font = [UIFont systemFontOfSize:17];
        _secondLabel.textColor = [UIColor whiteColor];
        _secondLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _secondLabel;
}

@end

