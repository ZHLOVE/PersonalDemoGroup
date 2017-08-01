//
//  RecentTableViewCell.m
//  HiTV
//
//  Created by cs090_jzb on 15/8/10.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "RecentTableViewCell.h"

NSString* const cRecentListCellID = @"RecentTableViewCell";

@implementation RecentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   // [self.fitVideoImg setContentMode:UIViewContentModeScaleAspectFit];
    [self.fitVideoImg setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.fitVideoImg.contentMode =  UIViewContentModeScaleAspectFill;
    self.fitVideoImg.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.fitVideoImg.clipsToBounds  = YES;
    [self.selectedBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self setupCorner];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //self.selectedBgBtn.hidden = self.selectedBtn.hidden;
    
}

-(IBAction)deleteButtonClick:(id)sender{
    [self.m_delegate deleteRecentVideo:self.recentVideo];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCorner{
    
    CGRect rect = CGRectMake(0, 0, self.offlineTag.frame.size.width, self.offlineTag.size.height);
    CGSize radio = CGSizeMake(3, 0);//圆角尺寸
    UIRectCorner corner = UIRectCornerTopRight|UIRectCornerBottomRight;//这只圆角位置
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:radio];
    CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];//创建shapelayer
    masklayer.frame = self.offlineTag.bounds;
    masklayer.path = path.CGPath;//设置路径
    self.offlineTag.layer.mask = masklayer;
    self.offlineTag.layer.masksToBounds = YES;
    
}


@end
