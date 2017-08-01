//
//  SJPayTypeCell.m
//  ShiJia
//
//  Created by 峰 on 2016/12/14.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJPayTypeCell.h"

@implementation SJPayTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setIsCheck:(BOOL)isCheck{
    if (isCheck) {
        self.selectedImg.image = [UIImage imageNamed:@"xuanzhong"];
    }
    else{
        self.selectedImg.image = [UIImage imageNamed:@"feixuanzhong"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
