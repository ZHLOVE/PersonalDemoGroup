#import "CollectionViewCell.h"
#import "WatchListEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>

@interface CollectionViewCell ()

@property (nonatomic, strong) UIView      *portainView;
@property (nonatomic, strong) UIImageView *backimageView;
@property (nonatomic, strong) UIButton    *stateButton;
@property (nonatomic, strong) UILabel     *programmNameLabel;
@property (nonatomic, strong) UILabel     *lookHistoryLabel;

@property (nonatomic, strong) UIView      *LandView;
@property (nonatomic, strong) UIImageView *tvLogo;
@property (nonatomic, strong) UILabel     *tvName;
@property (nonatomic, strong) UILabel     *tvDescrition;
@property (nonatomic, strong) UILabel     *nowState;



@end


@implementation CollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        _portainView = [UIView new];
        [self.contentView addSubview:_portainView];
        
        _backimageView = [UIImageView new];
        
        [_backimageView setContentMode:UIViewContentModeScaleToFill];
        [_backimageView setClipsToBounds:YES];
        _backimageView.layer.cornerRadius = 3.0f;
        [_backimageView.layer masksToBounds];
        [_portainView addSubview:_backimageView];
        
        //直播标记
        _stateButton = [UIButton new];
        
        _stateButton.backgroundColor =RGB(241, 100, 74, 1);
        _stateButton.titleLabel.font = [UIFont systemFontOfSize:10.];
        [_stateButton setTitleColor:RGB(255, 255, 255, 1) forState:UIControlStateNormal];
        [_portainView addSubview:_stateButton];
        //节目名字
        _programmNameLabel = [UILabel new];
        _programmNameLabel.textColor = RGB(255, 255, 255, 1);
        _programmNameLabel.font = [UIFont systemFontOfSize:17];
//        [_programmNameLabel setAdjustsFontSizeToFitWidth:YES];
        [_portainView addSubview:_programmNameLabel];
        
        //观看历史
        _lookHistoryLabel = [UILabel new];
        _lookHistoryLabel.textColor = RGB(42, 194, 239, 1);
        _lookHistoryLabel.font = [UIFont systemFontOfSize:12];
        
        [_portainView addSubview:_lookHistoryLabel];
        
        [_portainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
        
        //约束条件
        [_backimageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_portainView);
        }];
        
        [_stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_portainView);
            make.top.mas_equalTo(_portainView).offset(15);
            make.size.mas_equalTo(CGSizeMake(45, 16));
        }];
        
        [_programmNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_portainView).offset(10);
            make.bottom.mas_equalTo(_portainView).offset(-27);
            make.right.mas_equalTo(_portainView).offset(-10);
        }];
        
        [_lookHistoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_portainView).offset(10);
            make.bottom.mas_equalTo(_portainView).offset(-10);
            make.right.mas_equalTo(_portainView).offset(-10);
        }];

        
    }
    return self;
}

-(void)setcontentWith:(WatchListEntity *)model{
    
    NSURL *urlImage = [NSURL URLWithString:StringNotEmpty(model.posterAddr)?model.posterAddr:model.verticalPosterAddr];
    [self.backimageView sd_setImageWithURL:urlImage placeholderImage:[UIImage imageNamed:@"default_image"]];
    self.stateButton.hidden = [model.islive boolValue];
    self.programmNameLabel.text = model.programSeriesName;
    self.lookHistoryLabel.text = model.reason;
    
    self.stateButton.hidden =![self live:model];
    if ([OPENFLAG isEqualToString:@"0"]) {
        [_stateButton setTitle:@"最新" forState:UIControlStateNormal];
    }
    else{
        [_stateButton setTitle:@"直播中" forState:UIControlStateNormal];
    }
    
//    if (self.isFullScreen) {
//        NSURL *logoUrl = [NSURL URLWithString:model.channelLogo];
//        [self.tvLogo sd_setImageWithURL:logoUrl];
//        self.tvName.text = model.channelName;
//        self.tvDescrition.text = model.programSeriesDesc;
//    }

    //    self.nowState.text= model.
    
}
//当前时间是否是直播时间内
-(BOOL)live:(WatchListEntity *)entity{
    NSString *stamp = [Utils nowTimeString];
    long long date = [stamp longLongValue];
    if (date >=entity.startTime && date <= entity.endTime&&[entity.contentType isEqualToString:@"live"]) {
        return YES;
    }
    return NO;
}


@end
