//
//  StatusCell.m
//  Weibo
//
//  Created by niit on 16/3/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "StatusCell.h"

// 定义之后可以不用带mas_前缀
#define MAS_SHORTHAND
// 定义之后equalTo等于mas_equalTo
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"

@interface StatusCell()

@property (nonatomic,strong) IBOutlet UIImageView *iconImageView;
@property (nonatomic,strong) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) IBOutlet UILabel *contentLabel;
@property (nonatomic,strong) IBOutlet UIImageView *pictureImageView;
@property (nonatomic,strong) IBOutlet UIImageView *vipImageView;

@end

// 1. iconImageView
// 宽、高固定
// 距离顶部、左侧固定

// 2. nameLabel
// 距离顶部、左侧固定
// 高固定

// 3. vipImageView
// 宽、高固定
// 距离左侧元素固定
// 垂直中和左侧元素垂直中线固定

// 4. contentLabel
// 距离左侧、上方、右侧固定

// 5. pictureImageView
// 距离左侧、上方固定
// 宽、高固定

@implementation StatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // 1. 创建界面对象
        self.iconImageView = [[UIImageView alloc] init];
        self.nameLabel = [[UILabel alloc] init];
        self.contentLabel = [[UILabel alloc] init];
        self.pictureImageView = [[UIImageView alloc] init];
        self.vipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip"]];
        
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.pictureImageView];
        [self.contentView addSubview:self.vipImageView];
        
        // 2. 添加约束
        [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(50);
            make.left.equalTo(self.contentView.left).offset(8);
            make.top.equalTo(self.contentView.top).offset(8);
        }];
        
        [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.top).offset(8);
            make.left.equalTo(self.iconImageView.right).offset(8);
            make.height.mas_equalTo(21);
        }];
        
        [self.vipImageView makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(14);
            make.left.equalTo(self.nameLabel.right).offset(8);
            make.centerY.equalTo(self.nameLabel.centerY);
        }];
        
        [self.contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImageView.bottom).offset(10);
            make.left.equalTo(self.contentView.left).offset(10);
            make.right.equalTo(self.contentView.right).offset(-10);
        }];
        self.contentLabel.numberOfLines = 0;
        // 设定UILabel每行文字的最大宽度(理论上设置之后，UILabel的高度更准确)
        self.contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 20;
        
        [self.pictureImageView makeConstraints:^(MASConstraintMaker *make)
        {
            make.top.equalTo(self.contentLabel.bottom).offset(10);
            make.left.equalTo(self.contentView.left).offset(10);
            make.width.height.mas_equalTo(100);
        }];
        
        
    }
    return self;
}

- (void)setStatus:(StatusModel *)status
{
    _status = status;
    
    // 1. 设置数据
    self.iconImageView.image = [UIImage imageNamed:status.icon];
    self.nameLabel.text = status.name;
    self.vipImageView.hidden = !status.vip;
    self.contentLabel.text = status.text;

    if(status.picture == nil)
    {
        self.pictureImageView.hidden = YES;
    }
    else
    {
        self.pictureImageView.hidden = NO;
        self.pictureImageView.image = [UIImage imageNamed:status.picture];
    }
    
    // 2. 强制布局更新
    [self layoutIfNeeded];
    
    // 3. 将单元格的高度存在模型里
    if(self.pictureImageView.hidden)
    {
        _status.cellHeight =  CGRectGetMaxY(self.contentLabel.frame)+10;
    }
    else
    {
        _status.cellHeight = CGRectGetMaxY(self.pictureImageView.frame)+10;
    }
    NSLog(@"%s,计算得到的高度是:%g",__FUNCTION__,_status.cellHeight);
}

@end
