//
//  TPAddressBookTableViewCell.m
//  HiTV
//
//  Created by yy on 15/11/11.
//  Copyright © 2015年 Lanbo Zhang. All rights reserved.
//

#import "TPAddressBookTableViewCell.h"
#import "AddressBook.h"

NSString * const kTPAddressBookTableViewCellIdentifier = @"TPAddressBookTableViewCell";

@interface TPAddressBookTableViewCell ()

@property (nonatomic, weak)   IBOutlet UIImageView *headImgView;
@property (nonatomic, weak)   IBOutlet UILabel     *nameLabel;
@property (nonatomic, weak)   IBOutlet UILabel     *phoneLabel;
@property (nonatomic, weak)   IBOutlet UIButton    *shareButton;
@property (nonatomic, strong) IBOutlet UIImageView *lineImgView;

@end

@implementation TPAddressBookTableViewCell

#pragma mark - init
- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    [self.contentView addSubview:self.lineImgView];
    [self.lineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        make.bottom.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - data
- (void)showData:(AddressBook *)data
{
    self.nameLabel.text = data.name;
    self.phoneLabel.text = data.tel;
}

#pragma mark - button click
- (IBAction)shareButtonClicked:(id)sender
{
    if (self.shareButtonClickBlock) {
        self.shareButtonClickBlock(self);
    }
}

#pragma mark - getter
- (UIImageView *)lineImgView
{
    if (_lineImgView == nil) {
        _lineImgView = [[UIImageView alloc] init];
        _lineImgView.backgroundColor = [UIColor colorWithRed:219/255.0 green:222/255.0 blue:225/255.0 alpha:1.0];
        _lineImgView.alpha = 0.5;
    }
    return _lineImgView;
}

@end
