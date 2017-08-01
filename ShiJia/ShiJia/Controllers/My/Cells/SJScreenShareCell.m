//
//  SJScreenShareCell.m
//  ShiJia
//
//  Created by 峰 on 16/7/1.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJScreenShareCell.h"

@interface SJScreenShareCell ()

@property (nonatomic, strong) UIImageView *cellBackimage;
@property (nonatomic, strong) UIImageView *cellImageV;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *detailLabel;

@end

@implementation SJScreenShareCell


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *identifier = @"cell";
    SJScreenShareCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[SJScreenShareCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor =[UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self.contentView addSubview:self.cellBackimage];
        [self.contentView addSubview:self.cellImageV];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
        [self addSubviewConstraints];
    }
    
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark -SetValue

- (void)setCellValueWithModel:(SJScreenShareCellModel *)model{
    
    NSString *imageName    = [NSString stringWithFormat:@"%@.png",model.imageName];
    self.cellImageV.image  = [UIImage imageNamed:imageName];
    
    self.titleLabel.text   = model.title;
    self.detailLabel.text  = model.detailString;
    
}


#pragma  mark -UI 白色背景、小图、title、detail &make Constraints

-(UIImageView *)cellBackimage{

    if (!_cellBackimage) {
        
        _cellBackimage = [UIImageView new];
        _cellBackimage.backgroundColor = [UIColor whiteColor];
        _cellBackimage.layer.cornerRadius = 2.0f;
        
    }
    return _cellBackimage;
}

-(UIImageView *)cellImageV{
    if (!_cellImageV) {
     
        _cellImageV = [UIImageView new];
        [_cellImageV sizeToFit];
    
    }
    return _cellImageV;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font =[UIFont boldSystemFontOfSize:19];
        _titleLabel.textColor = RGB(68, 68, 68, 1);
        [_titleLabel sizeToFit];

    }
    return _titleLabel;
}

-(UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = RGB(154, 154, 154, 1);
        [_detailLabel sizeToFit];
    }
    return _detailLabel;

}

-(void)addSubviewConstraints{
    
    [_cellBackimage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsMake(15, 21, 0, 21));
    }];
    
    [_cellImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(50);
        make.centerY.mas_equalTo(_cellBackimage);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_cellBackimage).offset(129);
        make.top.mas_equalTo(_cellImageV);
        make.right.mas_equalTo(_cellBackimage);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel);
        make.bottom.mas_equalTo(_cellImageV);
        make.right.mas_equalTo(self.contentView);
    }];
}

@end
