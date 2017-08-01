//
//  SJScreenVedioCell.m
//  ShiJia
//
//  Created by 峰 on 16/7/6.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJScreenVedioCell.h"

@interface SJScreenVedioCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *timeLabel;
@property (nonatomic, strong) UIImageView *seletImage;
@end


@implementation SJScreenVedioCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.seletImage.image =selected?[UIImage imageNamed:@"contact_list_checked"]:nil;
//    self.seletImage.backgroundColor = selected? [UIColor blueColor]:[UIColor redColor];
//    _seletImage.image = [UIImage imageNamed:@"btg_icon_priority_1_selected"];
}
//- (void)setSelected:(BOOL)selected {
//    [super setSelected:selected];
//    
//    self.seletImage.image =  selected?[UIImage imageNamed:@"contact_list_checked"]:nil;
//    
//}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"cell";
    SJScreenVedioCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[SJScreenVedioCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.imageV];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.seletImage];
        [self addCellSubViewsConstrains];
    }
    
    return self;
}



- (void)setCellValueWithModel:(ALAsset *)model {
    _imageV.image        = [UIImage imageWithCGImage:[model thumbnail]];
    _nameLabel.text      = [[model defaultRepresentation] filename];

    NSInteger timeNumber = [[ model valueForProperty:ALAssetPropertyDuration ] integerValue];
    _timeLabel.text      = [self TimeformatFromSeconds:timeNumber];
    
}

- (NSString*)TimeformatFromSeconds:(NSInteger)seconds
{
    
    NSString *str_hour   = [NSString stringWithFormat:@"%02ld",seconds/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    NSString *formattime = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return formattime;
}


-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [UIImageView new];
        
    }
    return _imageV;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = RGB(68, 68, 68, 1);
        _nameLabel.font =[UIFont systemFontOfSize:16.];
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor = RGB(154, 154, 154, 1);
        _timeLabel.font =[UIFont systemFontOfSize:12.];
        [_timeLabel sizeToFit];
    }
    return _timeLabel;
}

-(UIImageView *)seletImage{
    if (!_seletImage) {
        _seletImage = [UIImageView new];
//        _seletImage.backgroundColor = [UIColor yellowColor];
        
    }
    return _seletImage;
}

- (void)addCellSubViewsConstrains{
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(20);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(94, 54));
        
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imageV.mas_right).offset(15);
        make.top.mas_equalTo(_imageV);
        
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel);
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(9);
    }];
    
    [_seletImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-10);
    }];
}

@end
