//
//  StatusCell.m
//  Weibo
//
//  Created by niit on 16/3/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "StatusCell.h"

@interface StatusCell()

@property (nonatomic,weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *contentLabel;
@property (nonatomic,weak) IBOutlet UIImageView *pictureImageView;
@property (nonatomic,weak) IBOutlet UIImageView *vipImageView;

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

// awakeFromNib只有从xib、storyboard的原型单元格创建，才会调用该方法
// 因为有些在界面上面没法直接，需要代码根据情况，比如设备的屏幕宽度
- (void)awakeFromNib {
    // Initialization code
    
    // 设定UILabel每行文字的最大宽度(理论上设置之后，UILabel的高度更准确)
    self.contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
}

@end
