//
//  PhotoOrientation.m
//  ShiJia
//
//  Created by 峰 on 16/9/20.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "PhotoOrientation.h"
#import "SJShareButton.h"

@interface PhotoOrientation ()

@property (strong, nonatomic) UIButton *turnRightButton;
@property (nonatomic, strong) UILabel  *rightLabel;
@property (strong, nonatomic) UIButton *turnLeftButton;
@property (nonatomic, strong) UILabel  *leftLabel;

@end

@implementation PhotoOrientation


-(UIButton *)turnLeftButton{
    if (!_turnLeftButton) {
        _turnLeftButton = [UIButton new];
        [_turnLeftButton setImage:[UIImage imageNamed:@"SJGroup2"] forState:UIControlStateNormal];
        _turnLeftButton.tag = 1;
        [_turnLeftButton addTarget:self action:@selector(changePhotoOrientation:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _turnLeftButton;
}

-(UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.text = @"向左转";
        _leftLabel.textColor = [UIColor lightGrayColor];
        _leftLabel.font = [UIFont systemFontOfSize:12.];
    }
    return _leftLabel;
}

-(UIButton *)turnRightButton{
    if (!_turnRightButton) {
        
        _turnRightButton = [UIButton new];
        [_turnRightButton setTitleColor:RGB(68, 68, 68, 1) forState:UIControlStateNormal];
        _turnRightButton.titleLabel.font = [UIFont systemFontOfSize:12.];
        _turnRightButton.tag = 0;
        [_turnRightButton setImage:[UIImage imageNamed:@"SJGroup"] forState:UIControlStateNormal];
        [_turnRightButton addTarget:self action:@selector(changePhotoOrientation:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _turnRightButton;
}
-(UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        _rightLabel.text = @"向右转";
        _rightLabel.textColor = [UIColor lightGrayColor];
        _rightLabel.font = [UIFont systemFontOfSize:12.];
    }
    return _rightLabel;
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self addSubview:self.turnRightButton];
        [self addSubview:self.rightLabel];
        [self addSubview:self.turnLeftButton];
        [self addSubview:self.leftLabel];
        [self addSubViewContrations];
    }
    return self;
}

-(void)addSubViewContrations{

    [_turnRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(46);
    }];
    
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_turnRightButton.mas_bottom);
        make.height.mas_equalTo(24);
    }];
    
    [_turnLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_rightLabel.mas_bottom);
        make.height.mas_equalTo(46);
    }];
    
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(24);
    }];
}

- (void)changePhotoOrientation:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (_ChangeOrientationBlock) {
        self.ChangeOrientationBlock(button);
    }
}

@end
