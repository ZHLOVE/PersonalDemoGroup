//
//  TableViewCell.m
//  LGJ
//
//  Created by 马千里 on 16/5/14.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "TableViewCell.h"
// 定义之后可以不用带mas_前缀
#define MAS_SHORTHAND
// 定义之后equalTo等于mas_equalTo
#define MAS_SHORTHAND_GLOBALS
#import <Masonry.h>
@interface TableViewCell ()


@property(nonatomic,assign)  int gid;
@property (nonatomic,strong) UIImageView *foodImageView;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *foodName;
@property (strong, nonatomic)  UILabel *dayLabel;
@property (strong, nonatomic)  UILabel *foodDay;
@property (strong, nonatomic)  UILabel *countLabel;
@property (strong, nonatomic)  UILabel *foodCount;

@end

@implementation TableViewCell


- (void)setModel:(DataModel *)model{
    _model = model;
    //沙盒读取图片
    NSString *imgPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents" ]stringByAppendingPathComponent:model.image];
    self.foodImageView.image = [[UIImage alloc]initWithContentsOfFile:imgPath];
    self.foodName.text = model.name;
    self.foodDay.text = [self dayWithFrom:model.dayFrom andDayTo:model.dayTo];
    self.foodCount.text = model.counts;
    self.gid = model.gid;
    
}

- (NSString *)dayWithFrom:(NSString *)dayFrom andDayTo:(NSString *)dayTo{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    // NSString -> NSDate
    NSDate *dayF = [dateFormat dateFromString:dayFrom];
    NSDate *dayT = [dateFormat dateFromString:dayTo];
    NSTimeInterval second = [dayT timeIntervalSinceDate:dayF]/3600/24;
    NSString *day = [NSString stringWithFormat:@"%1.0f天",second];
    return day;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setupUI];
    }
    return self;
}

#pragma mark 设置UI
- (void)setupUI{
    //添加控件
    self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1];
    [self.contentView addSubview:self.foodImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.dayLabel];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.foodName];
    [self.contentView addSubview:self.foodDay];
    [self.contentView addSubview:self.foodCount];
    //添加约束
    [self.foodImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(0).offset(5);
        make.bottom.equalTo(0).offset(-5);
        make.width.equalTo(self.foodImageView.height);
    }];
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(70);
        make.top.equalTo(self.contentView.top).offset(10);
        make.left.equalTo(self.foodImageView.right).offset(20);
    }];
    [self.dayLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.centerY).offset(35);
        make.width.equalTo(70);
        make.left.equalTo(self.foodImageView.right).offset(20);
    }];
    [self.countLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dayLabel.centerY).offset(35);
        make.left.equalTo(self.foodImageView.right).offset(20);
        make.width.equalTo(70);
        
    }];
    [self.foodName makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.nameLabel.height);
        make.top.bottom.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.right).equalTo(10);
    }];
    [self.foodDay makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.dayLabel.height);
        make.top.bottom.equalTo(self.dayLabel);
        make.left.equalTo(self.dayLabel.right).equalTo(10);
    }];
    [self.foodCount makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.countLabel.height);
        make.top.bottom.equalTo(self.countLabel);
        make.left.equalTo(self.countLabel.right).equalTo(10);
    }];
}

#pragma mark懒加载
//*foodImageView
//*nameLabel;
//*foodName;
//*dayLabel;
//*foodDay;
//*countLabel;
//*foodCount;

- (UIImageView *)foodImageView{
    if (_foodImageView == nil) {
        _foodImageView = [[UIImageView alloc]init];
        _foodImageView.contentMode = UIViewContentModeScaleAspectFill;
        _foodImageView.clipsToBounds = YES;
        //设置圆形
        _foodImageView.layer.cornerRadius=15;
    }
    return _foodImageView;
}

- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [UILabel createLabelWithColor:[UIColor blackColor] fontSize:14];
        _nameLabel.text = @"名称:";
        _nameLabel.textAlignment = NSTextAlignmentRight;
    }
    return _nameLabel;
}

- (UILabel *)dayLabel{
    if (_dayLabel == nil) {
        _dayLabel = [UILabel createLabelWithColor:[UIColor blackColor] fontSize:14];
        _dayLabel.text = @"保质期:";
        _dayLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dayLabel;
}

- (UILabel *)countLabel{
    if (_countLabel == nil) {
        _countLabel = [UILabel createLabelWithColor:[UIColor blackColor] fontSize:14];
        _countLabel.text = @"数量:";
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

- (UILabel *)foodName{
    if (_foodName == nil) {
        _foodName = [UILabel createLabelWithColor:[UIColor blackColor] fontSize:14];
        _foodName.textAlignment = NSTextAlignmentLeft;
    }
    return _foodName;
}

- (UILabel *)foodDay{
    if (_foodDay == nil) {
        _foodDay = [UILabel createLabelWithColor:[UIColor blackColor] fontSize:14];
        _foodDay.textAlignment = NSTextAlignmentLeft;
    }
    return _foodDay;
}

- (UILabel *)foodCount{
    if (_foodCount == nil) {
        _foodCount = [UILabel createLabelWithColor:[UIColor blackColor] fontSize:14];
        _foodCount.textAlignment = NSTextAlignmentLeft;
    }
    return _foodCount;
}

@end
