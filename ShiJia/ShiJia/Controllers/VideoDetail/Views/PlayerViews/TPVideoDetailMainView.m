//
//  TPVideoDetailMainView.m
//  ShiJia
//
//  Created by yy on 16/6/24.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "TPVideoDetailMainView.h"
#import "SJVideoInfoView.h"
#import "SJVideoRecommendView.h"
#import "TPVideoDetailCell.h"
#import "WatchFocusVideoProgramEntity.h"
#import "VideoSource.h"

static CGFloat kLineImgWidth = 10.0;
static CGFloat kLineImgHeight = 16.0;
static CGFloat kLineImgOriginx = 10.0;
static CGFloat kInnerPadding = 10.0;
static CGFloat kLabelHeight = 20.0;
static NSInteger kColumnCount = 6;

@interface TPVideoDetailMainView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIImageView *_lineImgView;
}

@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *viplanesImg;

@property (nonatomic, strong, readwrite) SJVideoInfoView *infoView;
@property (nonatomic, strong, readwrite) SJVideoRecommendView *recommendView;
@property (nonatomic, strong) UILabel *seriesLabel;

@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@property (nonatomic, strong) UIButton *showMoreButton;
@property (nonatomic, assign) BOOL     showMoreSeries;

@property (nonatomic, strong) UIControl *subViewContrl;
@property (nonatomic, strong) UIView   *moreSeriesView;
@property (nonatomic, assign) CGFloat  pointY;

@end

@implementation TPVideoDetailMainView

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];

    if (self) {

        // scroll view
        _scroll = [[UIScrollView alloc] init];
        [self addSubview:_scroll];


        // content view
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

        // 简介
        _infoView = [[SJVideoInfoView alloc] init];
        [_contentView addSubview:_infoView];

        _lineImgView = [[UIImageView alloc] init];
        //_lineImgView.backgroundColor = kColorBlueTheme;
        _lineImgView.image = [UIImage imageNamed:@"Triangle"];
        [self addSubview:_lineImgView];

        // 剧集标题
        _seriesLabel = [[UILabel alloc] init];
        _seriesLabel.backgroundColor = [UIColor clearColor];
        _seriesLabel.font = [UIFont systemFontOfSize:14.0];
        _seriesLabel.textColor = [UIColor blackColor];
        _seriesLabel.text = @"选集";
        //[_contentView addSubview:_seriesLabel];

        // 剧集
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        _collectionview.backgroundColor = [UIColor clearColor];
        //        [_contentView addSubview:_collectionview];
        [_collectionview registerNib:[UINib nibWithNibName:kTPVideoDetailCellIdentifier bundle:nil] forCellWithReuseIdentifier:kTPVideoDetailCellIdentifier];
        _collectionview.scrollEnabled = NO;

        [_contentView addSubview:self.showMoreButton];


        // 推荐
        _recommendView = [[SJVideoRecommendView alloc] init];
        [_contentView addSubview:_recommendView];
        _recommendView.collectionview.scrollEnabled = NO;

        [_infoView addObserver:self forKeyPath:NSStringFromSelector(@selector(height)) options:NSKeyValueObservingOptionNew context:nil];
        _lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];


        UIDevice *device = [UIDevice currentDevice]; //Get the device object
        [device beginGeneratingDeviceOrientationNotifications]; //Tell it to start monitoring the accelerometer for orientation
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; //Get the notification centre for the app
        [nc addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:device];

    }
    return self;
}

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UIDevice *device = [UIDevice currentDevice];
    [nc removeObserver:self name:UIDeviceOrientationDidChangeNotification object:device];

    [_infoView removeObserver:self forKeyPath:NSStringFromSelector(@selector(height))];
}
//北京Taipan上线，隐藏vip相关
/*#ifdef BeiJing
- (void)layoutSubviews
{
    [super layoutSubviews];
    _viplanesImg.hidden = YES;
    _scroll.frame = self.bounds;
    
    // 简介view
    _infoView.frame = CGRectMake(0,
                                 0,
                                 _scroll.frame.size.width,
                                 _infoView.height);
    
    
    float h = _infoView.frame.origin.y + _infoView.frame.size.height + kInnerPadding;
    
    if (self.zongyi) {
        //        [_seriesLabel removeFromSuperview];
        //        [_collectionview removeFromSuperview];
        self.seriesTableView.frame = CGRectMake(10, h-20, W-20, self.seriesTableView.height);
        h += self.seriesTableView.height-20;
    }
    else{
        // 剧集标题
        //        [self.seriesTableView removeFromSuperview];
        _lineImgView.frame = CGRectMake(kLineImgOriginx, _infoView.frame.origin.y + _infoView.frame.size.height + kInnerPadding + (kLabelHeight - kLineImgHeight) / 2.0, kLineImgWidth, kLineImgHeight);
        
        
        _seriesLabel.frame = CGRectMake(_lineImgView.frame.origin.x + kLineImgWidth + kInnerPadding,
                                        _infoView.frame.origin.y + _infoView.frame.size.height + kInnerPadding,
                                        _scroll.frame.size.width - kInnerPadding * 2,
                                        kLabelHeight);
        h += _seriesLabel.frame.size.height ;
        // 剧集view
        NSInteger rowcount = _list.count % kColumnCount == 0 ? _list.count / kColumnCount :(_list.count / kColumnCount + 1);
        if (_list.count>18) {
            rowcount = 3;
        }
        
        CGFloat rowheight = (self.frame.size.width - kInnerPadding * (kColumnCount + 1)) / kColumnCount;
        
        _collectionview.frame = CGRectMake(0,
                                           h,
                                           _scroll.frame.size.width,
                                           rowcount * rowheight + kInnerPadding * rowcount);
        
        h += _collectionview.height;
        if (_list.count>18) {
            
            _showMoreButton.frame = CGRectMake(10, h+10, SCREEN_WIDTH-20, 40);
            
            h +=50;
        }
        
    }
    // 推荐view
    //_recommendView.frame = CGRectMake(0, _collectionview.frame.origin.y + _collectionview.frame.size.height + kInnerPadding+_seriesTableView.height, _scroll.frame.size.width, _recommendView.height);
    
    
    
    
    _recommendView.frame = CGRectMake(0, h, _scroll.frame.size.width, _recommendView.height);
    
    _contentView.frame = CGRectMake(0, 0, _scroll.frame.size.width, _recommendView.frame.origin.y + _recommendView.height);
    
    _scroll.contentSize = _contentView.size;
    
}
#else*/
- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([[HiTVGlobals sharedInstance].disable_moudles containsObject:@"mc-version64"]|[HiTVGlobals sharedInstance].VIP) {
        _viplanesImg.hidden = YES;
        _scroll.frame = self.bounds;

        // 简介view
        _infoView.frame = CGRectMake(0,
                                     0,
                                     _scroll.frame.size.width,
                                     _infoView.height);


        float h = _infoView.frame.origin.y + _infoView.frame.size.height + kInnerPadding;

        if (self.zongyi) {
            self.seriesTableView.frame = CGRectMake(10, h-20, W-20, self.seriesTableView.height);
            h += self.seriesTableView.height-20;
        }
        else{
            // 剧集标题
            _lineImgView.frame = CGRectMake(kLineImgOriginx, _infoView.frame.origin.y + _infoView.frame.size.height + kInnerPadding + (kLabelHeight - kLineImgHeight) / 2.0, kLineImgWidth, kLineImgHeight);


            _seriesLabel.frame = CGRectMake(_lineImgView.frame.origin.x + kLineImgWidth + kInnerPadding,
                                            _infoView.frame.origin.y + _infoView.frame.size.height + kInnerPadding,
                                            _scroll.frame.size.width - kInnerPadding * 2,
                                            kLabelHeight);
            h += _seriesLabel.frame.size.height ;
            // 剧集view
            NSInteger rowcount = _list.count % kColumnCount == 0 ? _list.count / kColumnCount :(_list.count / kColumnCount + 1);
            if (_list.count>18) {
                rowcount = 3;
            }

            CGFloat rowheight = (self.frame.size.width - kInnerPadding * (kColumnCount + 1)) / kColumnCount;

            _collectionview.frame = CGRectMake(0,
                                               h,
                                               _scroll.frame.size.width,
                                               rowcount * rowheight + kInnerPadding * rowcount);

            h += _collectionview.height;
            if (_list.count>18) {

                _showMoreButton.frame = CGRectMake(10, h+10, SCREEN_WIDTH-20, 40);

                h +=50;
            }

        }
        _recommendView.frame = CGRectMake(0, h, _scroll.frame.size.width, _recommendView.height);

        _contentView.frame = CGRectMake(0, 0, _scroll.frame.size.width, _recommendView.frame.origin.y + _recommendView.height);

        _scroll.contentSize = _contentView.size;
    }
    else{
        _viplanesImg.hidden = NO;
        _scroll.frame = self.bounds;
        float topH = 10;
        _viplanesImg.frame = CGRectMake(10, topH, _contentView.frame.size.width-20, (_contentView.frame.size.width-20) *112/710);

        // 简介view
        _infoView.frame = CGRectMake(0,
                                     _viplanesImg.frame.size.height+topH,
                                     _scroll.frame.size.width,
                                     _infoView.height);


        float h = _infoView.frame.origin.y + _infoView.frame.size.height + kInnerPadding;

        if (self.zongyi) {
            self.seriesTableView.frame = CGRectMake(10, h-20, W-20, self.seriesTableView.height);
            h += self.seriesTableView.height-20;
        }
        else{
            // 剧集标题
            _lineImgView.frame = CGRectMake(kLineImgOriginx, _infoView.frame.origin.y + _infoView.frame.size.height + kInnerPadding + (kLabelHeight - kLineImgHeight) / 2.0, kLineImgWidth, kLineImgHeight);


            _seriesLabel.frame = CGRectMake(_lineImgView.frame.origin.x + kLineImgWidth + kInnerPadding,
                                            _infoView.frame.origin.y + _infoView.frame.size.height + kInnerPadding,
                                            _scroll.frame.size.width - kInnerPadding * 2,
                                            kLabelHeight);
            h += _seriesLabel.frame.size.height;
            // 剧集view
            NSInteger rowcount = _list.count % kColumnCount == 0 ? _list.count / kColumnCount :(_list.count / kColumnCount + 1);
            if (_list.count>18) {
                rowcount = 3;
            }

            CGFloat rowheight = (self.frame.size.width - kInnerPadding * (kColumnCount + 1)) / kColumnCount;

            _collectionview.frame = CGRectMake(0,
                                               h,
                                               _scroll.frame.size.width,
                                               rowcount * rowheight + kInnerPadding * rowcount);

            h += _collectionview.height;
            if (_list.count>18) {

                _showMoreButton.frame = CGRectMake(10, h+10, SCREEN_WIDTH-20, 40);

                h +=50;
            }

        }
        // 推荐view
        //_recommendView.frame = CGRectMake(0, _collectionview.frame.origin.y + _collectionview.frame.size.height + kInnerPadding+_seriesTableView.height, _scroll.frame.size.width, _recommendView.height);




        _recommendView.frame = CGRectMake(0, h+10, _scroll.frame.size.width, _recommendView.height);

        _contentView.frame = CGRectMake(0, 0, _scroll.frame.size.width, _recommendView.frame.origin.y + _recommendView.height);

        _scroll.contentSize = _contentView.size;
    }


}
//#endif

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    _showMoreButton.hidden = _list.count>18?NO:YES;
    if (view==_collectionview) {
        return _list.count>18?18:_list.count;
    }else return _list.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    TPVideoDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTPVideoDetailCellIdentifier forIndexPath:indexPath];

  cell.text = [self setCellText:indexPath cell:cell];
    if ( indexPath.row == _lastIndexPath.row ) {
        cell.style = TPVideoDetailCellStylePlaying;
    }
    cell.model = _list[indexPath.row];

    /*WatchFocusVideoProgramEntity *entity = _list[indexPath.row];
     if ([entity.class isSubclassOfClass:[WatchFocusVideoProgramEntity class]]&&entity.seriesNum) {
     cell.text = entity.seriesNum;
     }
     else{
     cell.text = [NSString stringWithFormat:@"%zd",indexPath.row + 1];
     }*/
    //cell.label.textColor = [UIColor darkGrayColor];

    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TPVideoDetailCell *cell = (TPVideoDetailCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.style == TPVideoDetailCellStyleCannotPlay) {
        [OMGToast showWithText:@"该集已下线"];
        return;
    }
    TPVideoDetailCell *lastCell = (TPVideoDetailCell *)[collectionView cellForItemAtIndexPath:_lastIndexPath];
    
    lastCell.style = TPVideoDetailCellStyleNormal;

    lastCell.text = [self setCellText:_lastIndexPath cell:lastCell];

    cell.text = [self setCellText:indexPath cell:lastCell];
    
    cell.style = TPVideoDetailCellStylePlaying;

    self.currentVideoIndex = indexPath.row;

    if (collectionView!=_collectionview) {
        [self hiddenMoreView];
    }

    if (self.didSelectItemAtIndex) {
        self.didSelectItemAtIndex(indexPath.row);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (collectionView.frame.size.width - kInnerPadding * (kColumnCount + 1)) / kColumnCount;
    return CGSizeMake(width, width);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kInnerPadding, kInnerPadding, kInnerPadding, kInnerPadding);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return kInnerPadding-0.5;
}

- (CGFloat)collectionView:(UICollectionView * )collectionView
                   layout:(UICollectionViewLayout * )collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kInnerPadding;
}
-(NSString *)setCellText:(NSIndexPath *)indexPath cell:(TPVideoDetailCell *)cell{
    WatchFocusVideoProgramEntity *entity = _list[indexPath.row];
    if ([entity.class isSubclassOfClass:[WatchFocusVideoProgramEntity class]]&&entity.seriesNum) {
        return entity.seriesNum;
    }
    else if([entity.class isSubclassOfClass:[VideoSource class]]){
        VideoSource *videoSource = (VideoSource *)entity;
        
        if (videoSource.sourceID.length == 0 && videoSource.actionURL.length == 0) {
            cell.style = TPVideoDetailCellStyleCannotPlay;
            return videoSource.setNumber;
        }
        else{
            if (self.programSetId) {
                NSArray *videoList = [NSUserDefaultsManager getObjectForKey:self.programSetId];
                if ([videoList containsObject:videoSource.sourceID]/*&&cell.style == TPVideoDetailCellStyleNormal*/) {
                    cell.style = TPVideoDetailCellStyleHasPlayed;
                    
                }
                else{
                    cell.style = TPVideoDetailCellStyleNormal;
                }
            }
            

            if (videoSource.setNumber.length >0 && [videoSource.setNumber intValue] != 0) {
                return videoSource.setNumber;
            }
            else{
                cell.label.textColor = [UIColor darkGrayColor];
                return [NSString stringWithFormat:@"%zd",indexPath.row + 1];
            }
        }
    }
    else{
        return [NSString stringWithFormat:@"%zd",indexPath.row + 1];
    }
}
#pragma mark - KVO & Notification
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(height))]) {
        [self setNeedsLayout];
    }
}

- (void)orientationChanged:(NSNotification *)note  {

    UIDeviceOrientation o = [[UIDevice currentDevice] orientation];
    switch (o) {
        case UIDeviceOrientationPortrait:
            [self.collectionview reloadData];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
             //[self.collectionview reloadData];
            break;
        case UIDeviceOrientationLandscapeLeft:
            if (_showMoreSeries == YES) {
                [self hiddenMoreView];
            }

            break;
        case UIDeviceOrientationLandscapeRight:
            if (_showMoreSeries == YES) {
                [self hiddenMoreView];
            }
            break;
        default:
            break;
    }
}

#pragma mark - Subviews
- (void)showMoreSerise:(id)sender
{
    _subViewContrl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _subViewContrl.backgroundColor=RGB(0, 0, 0, 0.3);
    [_subViewContrl addTarget:self action:@selector(hiddenMoreView) forControlEvents:UIControlEventTouchUpInside];
    _moreSeriesView = [UIView new];
    _moreSeriesView.backgroundColor = kColorLightGrayBackground;

    self.showMoreSeries = YES;

    UIView *headView = [[UIView alloc]init];
    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    headView.backgroundColor = [UIColor whiteColor];

    UIImageView *lineView = [UIImageView new];
    //lineView.backgroundColor = kColorBlueTheme;
    lineView.image = [UIImage imageNamed:@"Triangle"];
    lineView.frame = CGRectMake(10, 10, 10, 20);
    [headView addSubview:lineView];

    UILabel *_titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:15.0];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.text = @"选集";
    _titleLabel.frame = CGRectMake(lineView.origin.x+lineView.frame.size.width+10, 5, 40, 30);
    [headView addSubview:_titleLabel];

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = [UIColor clearColor];
    closeBtn.frame = CGRectMake(SCREEN_WIDTH-40, 10, 18, 18);
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(hiddenMoreView) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:closeBtn];

    [_moreSeriesView addSubview:headView];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionview2 = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionview2.delegate = self;
    collectionview2.dataSource = self;
    collectionview2.backgroundColor = [UIColor clearColor];

    [collectionview2 registerNib:[UINib nibWithNibName:kTPVideoDetailCellIdentifier bundle:nil] forCellWithReuseIdentifier:kTPVideoDetailCellIdentifier];
    collectionview2.scrollEnabled = YES;

    //    NSInteger rowcount = _list.count % kColumnCount == 0 ? _list.count / kColumnCount :(_list.count / kColumnCount + 1);
    //    CGFloat rowheight = (SCREEN_WIDTH- kInnerPadding * (kColumnCount + 1)) / kColumnCount;

    collectionview2.frame = CGRectMake(0,40,SCREEN_WIDTH,SCREEN_HEIGHT-9*SCREEN_WIDTH/16-100);
    [collectionview2 reloadData];
    [_moreSeriesView addSubview:collectionview2];

    CATransition *animation = [CATransition  animation];
    //    animation.delegate = self;
    animation.duration = 0.2f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [_moreSeriesView.layer addAnimation:animation forKey:@"animation1"];

    _moreSeriesView.frame = CGRectMake(0,60+9*SCREEN_WIDTH/16,SCREEN_WIDTH,SCREEN_HEIGHT-9*SCREEN_WIDTH/16-60);
    [_subViewContrl addSubview:_moreSeriesView];

    [[UIApplication sharedApplication].keyWindow addSubview:_subViewContrl];
}

- (void)hiddenMoreView
{
    CATransition *animation = [CATransition  animation];
    self.showMoreSeries = NO;
    //    animation.delegate = self;
    animation.duration = 0.2f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [_moreSeriesView.layer addAnimation:animation forKey:@"animtion2"];
    _moreSeriesView.frame = CGRectMake(0,SCREEN_HEIGHT+10,SCREEN_WIDTH,SCREEN_HEIGHT-9*SCREEN_WIDTH/16);


    [UIView animateWithDuration:0.2 animations:^{
        _subViewContrl.alpha = 0;
    }completion:^(BOOL finished) {
        //           [_moreSeriesView removeFromSuperview];
        [_subViewContrl removeFromSuperview];
    }];

}

#pragma mark - Setter
- (void)setList:(NSArray *)list
{
    _list = list;
    [_lineImgView removeFromSuperview];
    [_seriesLabel removeFromSuperview];
    [_collectionview removeFromSuperview];
    [_contentView addSubview:_collectionview];
    [_contentView addSubview:_seriesLabel];
    [_contentView addSubview:_lineImgView];
    [_collectionview reloadData];
    [self setNeedsLayout];
}


- (void)setCurrentVideoIndex:(NSInteger)currentVideoIndex
{
    if (currentVideoIndex != _lastIndexPath.row) {
        TPVideoDetailCell *lastCell = (TPVideoDetailCell *)[_collectionview cellForItemAtIndexPath:_lastIndexPath];
        lastCell.style = TPVideoDetailCellStyleNormal;
        
        //lastCell.text = [NSString stringWithFormat:@"%zd",_lastIndexPath.row + 1];
        lastCell.text = [self setCellText:_lastIndexPath cell:lastCell];

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentVideoIndex inSection:0];

        TPVideoDetailCell *cell = (TPVideoDetailCell *)[_collectionview cellForItemAtIndexPath:indexPath];
        // cell.text = [NSString stringWithFormat:@"%zd",indexPath.row + 1];
        cell.text = [self setCellText:indexPath cell:cell];

        cell.style = TPVideoDetailCellStylePlaying;
        _lastIndexPath = indexPath;
    }
    _currentVideoIndex = currentVideoIndex;

}

- (void)setZongyi:(BOOL)zongyi
{
    _zongyi = zongyi;
    if (zongyi) {
        [_collectionview removeFromSuperview];
        [_seriesLabel removeFromSuperview];
        [_lineImgView removeFromSuperview];
        [self.seriesTableView removeFromSuperview];
        [_contentView addSubview:self.seriesTableView];
        self.seriesTableView.hidden = NO;
        [self setNeedsLayout];
    }
    else{
        [self.seriesTableView removeFromSuperview];
        [_contentView addSubview:_collectionview];
        [_contentView addSubview:_seriesLabel];
        [_contentView addSubview:_lineImgView];
        [self setNeedsLayout];
    }

}

- (SJVideoSeriesTableView *)seriesTableView
{
    if (!_seriesTableView) {
        _seriesTableView = [[SJVideoSeriesTableView alloc] init];
        _seriesTableView.height = 80;
        //        [_contentView addSubview:_seriesTableView];
    }
    return _seriesTableView;
}

- (UIButton *)showMoreButton
{
    if (!_showMoreButton) {
        _showMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _showMoreButton.backgroundColor = [UIColor whiteColor];
        _showMoreButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_showMoreButton setTitle:@"查看更多" forState:UIControlStateNormal];
        [_showMoreButton setTitleColor:kColorBlueTheme forState:UIControlStateNormal];
        [_showMoreButton addTarget:self action:@selector(showMoreSerise:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showMoreButton;
}

#pragma mark - Event
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    if (self.vipLanesImgTapped) {
        self.vipLanesImgTapped();
    }
}
@end
