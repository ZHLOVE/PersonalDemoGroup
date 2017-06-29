//
//  PersonInfoCell.m
//  WingsBurning
//
//  Created by MBP on 2016/12/20.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "PersonInfoCell.h"

@interface PersonInfoCell()


@end

@implementation PersonInfoCell

- (void)setEmployee:(EmployeeM *)employee{
    _employee = employee;
    NSData *imgData = [Verify getImage];
    UIImage *img = [[UIImage alloc]initWithData:imgData];
    if (img) {
        [_porInfoImgView setImage:img];
    }else{
        [_porInfoImgView sd_setImageWithURL:[NSURL URLWithString:self.employee.avatar_url] placeholderImage:[UIImage imageNamed:@"default_touxiang"]];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadUI];
    }
    return self;
}

#pragma mark-布局
- (void)loadUI{
    [self.contentView addSubview:self.porInfoImgView];
}

- (UIImageView *)porInfoImgView{
    if (_porInfoImgView == nil) {
        _porInfoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 76*ratio, 7 * ratio, 37 * ratio, 46 * ratio)];
        _porInfoImgView.layer.cornerRadius = 4.0;
        _porInfoImgView.contentMode = UIViewContentModeScaleAspectFill;
        _porInfoImgView.image = [UIImage imageNamed:@"default_touxiang"];
        _porInfoImgView.layer.masksToBounds = YES;
    }
    return _porInfoImgView;
}



@end
