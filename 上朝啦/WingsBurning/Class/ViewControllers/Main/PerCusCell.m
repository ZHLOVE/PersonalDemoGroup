//
//  PerCusCell.m
//  WingsBurning
//
//  Created by MBP on 2016/12/22.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "PerCusCell.h"


@interface PerCusCell()

@property(nonatomic,strong) UIView *backGreenView;
@property(nonatomic,strong) CAGradientLayer *greenLayer;
@property(nonatomic,strong) UIView *backView;
@property(nonatomic,strong) UIView *portraitImageRim;
@property(nonatomic,strong) UIImageView *portraitImage;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UITextView *compLabel;

@end

@implementation PerCusCell
- (void)setEmployee:(EmployeeM *)employee{
    NSData *imgData = [Verify getImage];
    UIImage *img = [[UIImage alloc]initWithData:imgData];
    if (img) {
        [_portraitImage setImage:img];
    }else{
        [_portraitImage sd_setImageWithURL:[NSURL URLWithString:employee.avatar_url] placeholderImage:[UIImage imageNamed:@"leftView_touxiang"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
            [Verify saveEmployeeImage:imgData];
        }];
    }
    _nameLabel.text = employee.name;
}

- (void)setEmployer:(EmployerM *)employer{
    _compLabel.text = employer.name;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.greenLayer.frame = self.backGreenView.frame;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI{
    __weak typeof (self) weakSelf = self;
    [self addSubview:self.backGreenView];
    [self.backGreenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(weakSelf);
    }];
    [self.backGreenView.layer addSublayer:self.greenLayer];
    [self addSubview:self.portraitImageRim];
    [self.portraitImageRim mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(18 * ratio);
        make.top.mas_equalTo(weakSelf).offset(40 * ratio);
        make.height.mas_equalTo(92 * ratio);
        make.width.mas_equalTo(74 * ratio);
    }];
    [self addSubview:self.portraitImage];
    [self.portraitImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(88 *ratio);
        make.width.mas_equalTo(70 * ratio);
        make.centerX.mas_equalTo(weakSelf.portraitImageRim.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.portraitImageRim.mas_centerY);
    }];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.portraitImageRim).offset(22 * ratio);
        make.left.mas_equalTo(weakSelf.portraitImageRim.mas_right).offset(20 * ratio);
        make.height.mas_equalTo(18 * ratio);
    }];
    [self addSubview:self.compLabel];
    [self.compLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(64 * ratio);
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(15 * ratio);
        make.left.mas_equalTo(weakSelf.portraitImageRim.mas_right).offset(15 * ratio);
        make.width.mas_equalTo(140 * ratio);
    }];
}


#pragma mark-控件设置
- (UIView *)backView{
    if (_backView == nil) {
        _backView = [[UIView alloc]init];
        _backView.frame = self.bounds;
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIView *)backGreenView{
    if (_backGreenView == nil) {
        _backGreenView = [[UIView alloc]init];
    }
    return _backGreenView;
}

- (CAGradientLayer *)greenLayer{
    if (_greenLayer == nil) {
        _greenLayer = [CAGradientLayer layer];
        _greenLayer.colors = @[(id)[UIColor colorWithHexString:@"#0edf6f"].CGColor,
                               (id)[UIColor colorWithHexString:@"#02ca72"].CGColor];
        _greenLayer.locations = @[@(0.0f),@(1.0f)];
        _greenLayer.startPoint = CGPointMake(0, 0);
        _greenLayer.endPoint = CGPointMake(1, 1);
    }
    return _greenLayer;
}

- (UIView *)portraitImageRim{
    if (_portraitImageRim == nil) {
        _portraitImageRim = [[UIView alloc]init];
        _portraitImageRim.layer.borderWidth = 1.0;
        _portraitImageRim.layer.borderColor = [UIColor whiteColor].CGColor;
        _portraitImageRim.layer.cornerRadius = 4.0;
    }
    return _portraitImageRim;
}

- (UIImageView *)portraitImage{
    if (_portraitImage == nil) {
        _portraitImage = [[UIImageView alloc]init];
        _portraitImage.layer.cornerRadius = 2.0;
        _portraitImage.contentMode = UIViewContentModeScaleAspectFill;
        _portraitImage.image = [UIImage imageNamed:@"leftView_touxiang"];
        _portraitImage.layer.masksToBounds = YES;
        _portraitImage.userInteractionEnabled = YES;
    }
    return _portraitImage;
}

- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"童梓潼";
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:15 * ratio];
    }
    return _nameLabel;
}

- (UITextView *)compLabel{
    if (_compLabel == nil) {
        _compLabel = [[UITextView alloc]init];
        _compLabel.backgroundColor = [UIColor clearColor];
        _compLabel.editable = NO;
        _compLabel.textColor = [UIColor whiteColor];
        _compLabel.font = [UIFont systemFontOfSize:12];
        [_compLabel sizeToFit];
        _compLabel.userInteractionEnabled = NO;
    }
    return _compLabel;
}



@end
