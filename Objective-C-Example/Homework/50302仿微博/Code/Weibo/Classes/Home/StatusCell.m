//
//  StatusCell.m
//  Weibo
//
//  Created by qiang on 5/5/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "StatusCell.h"

#import "UILabel+Creation.h"
#import "UIButton+Creation.h"


// 定义之后可以不用带mas_前缀
#define MAS_SHORTHAND
// 定义之后equalTo等于mas_equalTo
#define MAS_SHORTHAND_GLOBALS
#import <Masonry.h>

#import <UIImageView+WebCache.h>

@interface StatusCell()

// 头像
@property (nonatomic,strong) UIImageView *iconView;
// 认证的图标
@property (nonatomic,strong) UIImageView *verifiedView;
// 名字
@property (nonatomic,strong) UILabel *nameLabel;
// 用户等级
@property (nonatomic,strong) UIImageView *vipView;
// 时间
@property (nonatomic,strong) UILabel *timeLabel;
// 来源
@property (nonatomic,strong) UILabel *sourceLabel;
// 正文
@property (nonatomic,strong) UILabel *contentLabel;

// 底部视图
@property (nonatomic,strong) UIView *footerView;
// 转发按钮
@property (nonatomic,strong) UIButton *retweetBtn;
// 评论按钮
@property (nonatomic,strong) UIButton *unlikeBtn;
// 赞按钮
@property (nonatomic,strong) UIButton *commonBtn;

@end

@implementation StatusCell

- (void)setStatus:(Status *)status
{
    _status = _status;
    
    // 1. 设置内容
    // 用户名字
    self.nameLabel.text = status.user.name;
    // 头像
    [self.iconView sd_setImageWithURL:status.user.imageURL];
    // 认证类型图片
    self.verifiedView.image = status.user.verifiedImage;
    // 等级
    self.vipView.image = status.user.mbrankImage;
    // 正文
    self.contentLabel.text = status.text;
    
    // 时间
    self.timeLabel.text = status.created_at;
    self.sourceLabel.text = status.source;
    
    // 2. 重新布局下
    [self layoutIfNeeded];
    
    // 3. 得到当前单元格的高度
    status.cellHeight = CGRectGetMaxY(self.footerView.frame);
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    // 1. 添加子控件
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.verifiedView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.vipView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.sourceLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.footerView];
    
    [self.footerView addSubview:self.retweetBtn];
    [self.footerView addSubview:self.unlikeBtn];
    [self.footerView addSubview:self.commonBtn];
    
    // 2. 添加约束，布局子控件
    [self.iconView makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(50);// 宽高 50*50
        make.top.left.equalTo(self.contentView).offset(10);// 距离左边顶部 10
    }];
    
    [self.verifiedView makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(17);// 17*17
        make.right.bottom.equalTo(self.iconView);// 和iconView 右下角对齐
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.right).offset(10);
        make.top.equalTo(self.iconView);
    }];
    
    [self.vipView makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(14);
        make.left.equalTo(self.nameLabel.right).offset(5);
        make.top.equalTo(self.iconView);
    }];
    
    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.right).offset(10);
        make.bottom.equalTo(self.iconView);
    }];
    
    [self.sourceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.right).offset(10);
       make.bottom.equalTo(self.iconView);
    }];
    // 正文
    [self.contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.iconView.bottom).offset(10);
    }];
    
    // footerView 及里面的按钮
    [self.footerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(40);
        make.top.equalTo(self.contentLabel.bottom);
    }];
    
    [self.retweetBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.footerView);
    }];
    
    [self.unlikeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.footerView);
        make.left.equalTo(self.retweetBtn.right);
        make.width.equalTo(self.retweetBtn);
    }];
    
    [self.commonBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.footerView);
        make.left.equalTo(self.unlikeBtn.right);
        make.width.equalTo(self.retweetBtn);
    }];
    
}


#pragma mark - 懒加载
- (UIImageView *)iconView
{
    if(_iconView == nil)
    {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_default_big"]];
    }
    return _iconView;
}

- (UIImageView *)verifiedView
{
    if(_verifiedView == nil)
    {
        _verifiedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_membership"]];
    }
    return _verifiedView;
}

- (UIImageView *)vipView
{
    if(_vipView == nil)
    {
        _vipView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_vip"]];
    }
    return _vipView;
}

- (UILabel *)nameLabel
{
    if(_nameLabel == nil)
    {
        _nameLabel = [UILabel createLabelWithColor:[UIColor darkGrayColor] fontSize:14];
    }
    return _nameLabel;
}


- (UILabel *)timeLabel
{
    if(_timeLabel == nil)
    {
        _timeLabel = [UILabel createLabelWithColor:[UIColor darkGrayColor] fontSize:14];
    }
    return _timeLabel;
}


- (UILabel *)sourceLabel
{
    if(_sourceLabel == nil)
    {
        _sourceLabel = [UILabel createLabelWithColor:[UIColor darkGrayColor] fontSize:14];
    }
    return _sourceLabel;
}

- (UILabel *)contentLabel
{
    if(_contentLabel == nil)
    {
        _contentLabel = [UILabel createLabelWithColor:[UIColor darkGrayColor] fontSize:14];
        
        // 多行
        _contentLabel.numberOfLines = 0;
        // 宽度
        _contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 20;
        
    }
    return _contentLabel;
}

- (UIView *)footerView
{
    if(_footerView == nil)
    {
        _footerView = [[UIView alloc] init];
    }
    return _footerView;
}

- (UIButton *)retweetBtn
{
    if(_retweetBtn == nil)
    {
        _retweetBtn = [UIButton createButtonWithTitle:@"转发" imageName:@"timeline_icon_retweet"];
    }
    return _retweetBtn;
}

- (UIButton *)unlikeBtn
{
    if(_unlikeBtn == nil)
    {
        _unlikeBtn = [UIButton createButtonWithTitle:@"赞" imageName:@"timeline_icon_unlike"];
    }
    return _unlikeBtn;
}

- (UIButton *)commonBtn
{
    if(_commonBtn == nil)
    {
        _commonBtn = [UIButton createButtonWithTitle:@"评论" imageName:@"timeline_icon_comment"];
    }
    return _commonBtn;
}
@end
