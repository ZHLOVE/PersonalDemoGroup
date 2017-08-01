//
//  SJLiveTVVideoDetailMainView.m
//  ShiJia
//
//  Created by yy on 16/6/21.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJLiveTVVideoDetailMainView.h"
#import "SJLiveTVProgramView.h"
#import "SJVideoRecommendView.h"
#import "TVProgram.h"
#import "CornerEntity.h"
#import "CustomView.h"

@interface SJLiveTVVideoDetailMainView  ()
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *viplanesImg;

@property (nonatomic, strong, readwrite) SJLiveTVProgramView *programView;
@property (nonatomic, strong, readwrite) SJVideoRecommendView *recommendView;
//FIXME: 临时方案
@property (nonatomic, strong) UIView   *OneSeriseView;

@property (nonatomic, strong) UIButton *buttonOne;
@property (nonatomic, strong) UIImageView *cornerImg;
@property (nonatomic, strong) CustomView *customView;

@end

@implementation SJLiveTVVideoDetailMainView

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _scroll = [[UIScrollView alloc] init];
        _scroll.showsHorizontalScrollIndicator = NO;
        _scroll.showsVerticalScrollIndicator = NO;
        [self addSubview:_scroll];
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        [_scroll addSubview:_contentView];
        
        _viplanesImg = [[UIImageView alloc]init];
        _viplanesImg.image = [UIImage imageNamed:@"viplogo"];
        _viplanesImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        tapGr.cancelsTouchesInView = NO;
        [_viplanesImg addGestureRecognizer:tapGr];
        [_contentView addSubview:_viplanesImg];

        
        _programView = [[SJLiveTVProgramView alloc] init];
        [_contentView addSubview:_programView];
        
        
        
        
        _seriesTableView = [[SJVideoSeriesTableView alloc] init];
        _seriesTableView.height = 80;
        [_contentView addSubview:_seriesTableView];
        
        
        _recommendView = [[SJVideoRecommendView alloc] init];
        [_contentView addSubview:_recommendView];
        _recommendView.collectionview.scrollEnabled = NO;
        
    }
    return self;
}

-(UIView *)OneSeriseView{
    if (!_OneSeriseView) {
        _OneSeriseView = [UIView new];
        
        _buttonOne  = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonOne.frame =CGRectMake(0, 5, (SCREEN_WIDTH-10- 42) / 6-5, (SCREEN_WIDTH-10- 42) / 6-5);
        _buttonOne.backgroundColor = [UIColor whiteColor];
        _buttonOne.layer.cornerRadius = 3.0f;
        
        [_buttonOne addTarget:self
                       action:@selector(didSelectButton:)
             forControlEvents:UIControlEventTouchUpInside];
        TVProgram *program = self.dataArray[0];
        NSString *title = @"1";
        if ([program.class isSubclassOfClass:[TVProgram class]]&&program.seriesNum) {
            title = [NSString stringWithFormat:@"%d",program.seriesNum.intValue];
        }
        [_buttonOne setTitle:title forState:UIControlStateNormal];
        [_buttonOne setTitleColor:kColorBlueTheme forState:UIControlStateNormal];
        [_OneSeriseView addSubview:_buttonOne];
        
        
        _customView = [[CustomView alloc]initWithFrame:_OneSeriseView.frame];
        [_buttonOne addSubview:_customView];

        
    }
    return _OneSeriseView;
}


-(void)setDataArray:(NSMutableArray *)dataArray{
    
    [_contentView addSubview:self.OneSeriseView];
    [self layoutIfNeeded];
    _dataArray = dataArray;
    if (_dataArray.count>0) {
        TVProgram *program = _dataArray[0];
        NSString *title = @"1";
        if ([program.class isSubclassOfClass:[TVProgram class]]&&program.seriesNum.intValue>0) {
            title = [NSString stringWithFormat:@"%d",program.seriesNum.intValue];
        }
        [_buttonOne setTitle:title forState:UIControlStateNormal];
       /* for (CornerEntity *cornerEntity in program.cornerArray) {
            if (cornerEntity.position.intValue == 1) {
                [_cornerImg setImageWithURL:[NSURL URLWithString:cornerEntity.cornerImg] placeholderImage:nil];
                
            }
        }*/
        _customView.sizeToWidth = 30;
        [_customView useViewCorners:program];
    }

}

/*#ifdef BeiJing
//北京Taipan上线，隐藏vip相关
- (void)layoutSubviews
{
    [super layoutSubviews];
    _viplanesImg.hidden = YES;
    _scroll.frame = self.bounds;
    
    _OneSeriseView.frame =CGRectMake(10, 120, W-20, 90);
    
    _programView.frame = CGRectMake(0, 0, _contentView.frame.size.width, kSJLiveTVProgramViewHeight);
    _seriesTableView.frame = CGRectMake(10, kSJLiveTVProgramViewHeight, W-20, _seriesTableView.height);
    _recommendView.frame = CGRectMake(0, kSJLiveTVProgramViewHeight+_seriesTableView.height, _contentView.frame.size.width, _recommendView.height);
    
    _contentView.frame = CGRectMake(0, 0, _scroll.frame.size.width, kSJLiveTVProgramViewHeight + _recommendView.height+_seriesTableView.height);
    _scroll.contentSize = _contentView.frame.size;
}
#else*/
- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([[HiTVGlobals sharedInstance].disable_moudles containsObject:@"mc-version64"]|[HiTVGlobals sharedInstance].VIP) {
        _viplanesImg.hidden = YES;
        _scroll.frame = self.bounds;
        
        _OneSeriseView.frame =CGRectMake(10, 120, W-20, 90);
        
        _programView.frame = CGRectMake(0, 0, _contentView.frame.size.width, kSJLiveTVProgramViewHeight);
        _seriesTableView.frame = CGRectMake(10, kSJLiveTVProgramViewHeight, W-20, _seriesTableView.height);
        _recommendView.frame = CGRectMake(0, kSJLiveTVProgramViewHeight+_seriesTableView.height, _contentView.frame.size.width, _recommendView.height);
        
        _contentView.frame = CGRectMake(0, 0, _scroll.frame.size.width, kSJLiveTVProgramViewHeight + _recommendView.height+_seriesTableView.height);
        _scroll.contentSize = _contentView.frame.size;
    }
    else{
        _viplanesImg.hidden = NO;

        _scroll.frame = self.bounds;
        float h = 10;
        _OneSeriseView.frame =CGRectMake(10, 120+_viplanesImg.frame.size.height+h, W-20, 90);
        
        _viplanesImg.frame = CGRectMake(10, h, _contentView.frame.size.width-20, (_contentView.frame.size.width-20) *112/710);
        
        _programView.frame = CGRectMake(0, _viplanesImg.frame.size.height+h, _contentView.frame.size.width, kSJLiveTVProgramViewHeight);
        _seriesTableView.frame = CGRectMake(10, kSJLiveTVProgramViewHeight+_viplanesImg.frame.size.height+h, W-20, _seriesTableView.height);
        _recommendView.frame = CGRectMake(0, kSJLiveTVProgramViewHeight+_seriesTableView.height+_viplanesImg.frame.size.height+h+10, _contentView.frame.size.width, _recommendView.height);
        
        
        _contentView.frame = CGRectMake(0, 0, _scroll.frame.size.width, kSJLiveTVProgramViewHeight + _recommendView.height+_seriesTableView.height+_viplanesImg.frame.size.height+h);
        _scroll.contentSize = _contentView.frame.size;
    }
}
//#endif

- (void)didSelectButton:(id)sender {
    if (self.didSelect) {
        self.didSelect(0);
    }
    
}
#pragma mark - Event
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    if (self.vipLanesImgTapped) {
        self.vipLanesImgTapped();
    }
}
@end
