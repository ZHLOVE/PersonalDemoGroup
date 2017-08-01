//
//  SJCacheVideoTableViewCell.m
//  ShiJia
//
//  Created by yy on 16/3/14.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJCacheVideoCell.h"

static CGFloat kLeftMargin         = 20.0; //图标左边距
static CGFloat kTopMargin          = 10.0; //图标上边距
static CGFloat kVideoImgViewWidth  = 90.0; //图标宽度
static CGFloat kVideoImgViewHeight = 50.0; //图标高度
static CGFloat kLabelHeight        = 20.0; //label高度
static CGFloat kDeleteButtonWidth  = 20.0; //删除按钮宽度/高度
static CGFloat kProgressViewHeight = 2.0;  //进度条高度
static CGFloat kLineImgViewHeight  = 1.0;  //分割线高度

@interface SJCacheVideoContentView ()

@property (nonatomic, strong) UIImageView    *videoImgView;
@property (nonatomic, strong) UILabel        *infoLabel;
@property (nonatomic, strong) UILabel        *nameLabel;
@property (nonatomic, strong) UILabel        *progressLabel;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIButton       *deleteButton;
@property (nonatomic, strong) UIImageView    *lineImgView;

@end

@implementation SJCacheVideoContentView

#pragma mark - Lifecycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
   
    if (self) {
    
        // video image view
        _videoImgView = [[UIImageView alloc] init];
        _videoImgView.contentMode = UIViewContentModeScaleAspectFit;
        _videoImgView.image = [UIImage imageNamed:@"video_image_test"];
        [self addSubview:_videoImgView];
        
        // info label
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textAlignment = NSTextAlignmentRight;
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.font = [UIFont systemFontOfSize:12.0];
        _infoLabel.textColor = [UIColor whiteColor];
        [self addSubview:_infoLabel];
        _infoLabel.text = @"2个视频";
        
        
        // name label
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:15.0];
        _nameLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_nameLabel];
        _nameLabel.text = @"琅琊榜";
        
        // progress label
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.backgroundColor = [UIColor clearColor];
        _progressLabel.font = [UIFont systemFontOfSize:14.0];
        _progressLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_progressLabel];
        _progressLabel.text = @"100M / 128M";
        
        // progress view
        _progressView = [[UIProgressView alloc] init];
        [_progressView setProgressTintColor:[UIColor colorWithHexString:@"c1c1c1"]];
        [_progressView setTrackTintColor:[UIColor colorWithHexString:@"91daef"]];
        [self addSubview:_progressView];
        
        // delete button
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"delete_btn_nor"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //分割线
        _lineImgView = [[UIImageView alloc] init];
        _lineImgView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
        [self addSubview:_lineImgView];
        
        [self addSubview:_deleteButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _videoImgView.frame = CGRectMake(kLeftMargin, kTopMargin, kVideoImgViewWidth, kVideoImgViewHeight);
    
    _infoLabel.frame = CGRectMake(kLeftMargin, kTopMargin + kVideoImgViewHeight - kLabelHeight, kVideoImgViewWidth, kLabelHeight);
    
    CGFloat originx = kLeftMargin + kTopMargin + kVideoImgViewWidth;
    CGFloat labelWidth = self.frame.size.width - originx - kLeftMargin - kTopMargin - kDeleteButtonWidth;
    
    _nameLabel.frame = CGRectMake(originx, kTopMargin, labelWidth, kLabelHeight);
    
    _progressLabel.frame = CGRectMake(originx, _nameLabel.frame.origin.y + _nameLabel.frame.size.height, labelWidth, kLabelHeight);
    
    _progressView.frame = CGRectMake(originx, _progressLabel.frame.origin.y + _progressLabel.frame.size.height + kTopMargin / 2.0, labelWidth, kProgressViewHeight);
    
    _deleteButton.frame = CGRectMake(self.frame.size.width - kLeftMargin - kDeleteButtonWidth, (self.frame.size.height - kDeleteButtonWidth) / 2.0, kDeleteButtonWidth, kDeleteButtonWidth);
    
    _lineImgView.frame = CGRectMake(0, self.frame.size.height - kLineImgViewHeight, self.frame.size.width, kLineImgViewHeight);
}

#pragma mark - Event
- (void)deleteButtonClicked:(id)sender
{
    
}


@end



#pragma mark -

@interface SJCacheVideoCell ()

@property (nonatomic, strong) SJCacheVideoContentView *mainView;

@end


@implementation SJCacheVideoCell
#pragma mark - Lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _mainView = [[SJCacheVideoContentView alloc] init];
        [self.contentView addSubview:_mainView];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame  = self.bounds;
    _mainView.frame = self.contentView.bounds;
}

#pragma mark - Setter
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
