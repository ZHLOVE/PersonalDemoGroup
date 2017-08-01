//
//  SJMessageCenterCell.m
//  ShiJia
//
//  Created by yy on 16/4/18.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJMessageCenterCell.h"
#import "SJNormalMessageModel.h"
#import "TPMessageCenterDataModel.h"
#import "TPIMNodeModel.h"
#import "TPXmppRoomManager.h"

NSString * const kSJMessageCenterCellIdentifier = @"SJMessageCenterCell";

@interface SJMessageCenterCell ()

@property (nonatomic, strong) IBOutlet UIImageView *avatarImgView;
@property (nonatomic, strong) IBOutlet UIImageView *readImgView;
@property (nonatomic, strong) IBOutlet UILabel     *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel     *detailLabel;
@property (nonatomic, strong) IBOutlet UILabel     *timeLabel;
//@property (nonatomic, strong) UIButton    *deleteButton;
@property (nonatomic, strong) IBOutlet UIImageView *lineImgView;
@property (nonatomic, strong) UIButton             *checkButton;
@property (nonatomic, strong) IBOutlet UIButton    *deleteButton;


@end

@implementation SJMessageCenterCell
#pragma mark - Lifecycle
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    // 选中按钮
    _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_checkButton setImage:[UIImage imageNamed:@"contact_list_uncheck"] forState:UIControlStateNormal];
    [_checkButton addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_checkButton];
    _checkButton.hidden = NO;
    [_checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(-45);
        make.top.equalTo(self).with.offset(20);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    // 头像
    _avatarImgView.layer.cornerRadius = 20.0;
    _avatarImgView.layer.masksToBounds = YES;
   
    // 分割线
    [_lineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        make.bottom.equalTo(self.contentView).with.offset(0);
    }];
    _lineImgView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
//    _lineImgView.alpha = 0.5;
    
    // 未读标志
    _readImgView.layer.cornerRadius = 3.0;
    _readImgView.layer.masksToBounds = YES;
    
    
}

#pragma mark - Public
- (void)showMessage:(TPMessageCenterDataModel *)model
{

    _titleLabel.text = model.from.nickname;
    //_detailLabel.text = model.title;
    _detailLabel.text = [model.title stringByReplacingOccurrencesOfString:model.from.nickname withString:@""];
    
//    _avatarImgView.image = model.faceImg;
//    if (_avatarImgView.image == nil) {
//        _avatarImgView.image = [UIImage imageNamed:@"default_head"];
//    }
    
    if (model.faceImgUrl.length == 0) {
        if ([model.type isEqualToString:@"24"]||[model.type isEqualToString:@"25"]) {
            _avatarImgView.image = [UIImage imageNamed:DEFAULTHEADICON];
        }else{
            _avatarImgView.image = [UIImage imageNamed:DEFAULTHEADICON];
        }
    }
    else{
        [_avatarImgView setImageWithURL:[NSURL URLWithString:model.faceImgUrl] placeholder:[UIImage imageNamed:DEFAULTHEADICON]];
    }
    
    if (model.read) {
        _readImgView.hidden = YES;
        _timeLabel.textColor = [UIColor colorWithHexString:@"9a9a9a"];
        //_titleLabel.textColor = [UIColor colorWithHexString:@""];
        _detailLabel.textColor = [UIColor colorWithHexString:@"9a9a9a"];
    }
    else{
        _readImgView.hidden = NO;
        _timeLabel.textColor = [UIColor colorWithHexString:@"444444"];
        //_titleLabel.textColor = [UIColor colorWithHexString:@""];
        _detailLabel.textColor = [UIColor colorWithHexString:@"444444"];
    }
    
    //time
    if (model.time == 0) {
        return;
    }
    
    NSTimeInterval time = [model.time floatValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *fotmatter = [[NSDateFormatter alloc] init];
    [fotmatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _timeLabel.text = [fotmatter stringFromDate:date];
    
    
}

#pragma mark - Setter
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    /*
    [_checkButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(5);
        make.top.equalTo(self).with.offset(20);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    if (!editing) {
        _checked = NO;
    }
    _checkButton.hidden = !editing;
     */
    //_deleteButton.hidden = !editing;
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    
    if (!_checked) {
        [_checkButton setImage:[UIImage imageNamed:@"contact_list_uncheck"] forState:UIControlStateNormal];
    }
    else{
        [_checkButton setImage:[UIImage imageNamed:@"contact_list_checked"] forState:UIControlStateNormal];
    }
}

- (void)setIsDeleting:(BOOL)isDeleting
{
    _isDeleting = isDeleting;
    _deleteButton.hidden = !isDeleting;
}

#pragma mark - Event
- (void)checkButtonClicked:(id)sedner
{
    self.checked = !self.checked;
    if (self.checkButtonClicked) {
        self.checkButtonClicked(_checked);
    }
}

- (IBAction)deleteButtonClicked:(id)sender
{
    if (self.deleteButtonClicked) {
        self.deleteButtonClicked(self);
    }
}

@end
