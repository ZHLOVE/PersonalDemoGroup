//
//  SJVideoRecommendView.m
//  ShiJia
//
//  Created by yy on 16/6/20.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJVideoRecommendView.h"
#import "SJVideoRecommendCell.h"
//#import "SJVideoRecommendModel.h"

#import "WatchListEntity.h"

static CGFloat kLineImgWidth = 10.0;
static CGFloat kLineImgHeight = 16.0;
static CGFloat kLineImgOriginx = 10.0;
static CGFloat kTitleLabelHeight = 20.0;
static CGFloat kLeftSpacing = 10.0;
static CGFloat kCellHeight = 200.0;
static NSInteger kColumnCount = 3;

@interface SJVideoRecommendView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UICollectionView *collectionview;
@property (nonatomic, strong) UIImageView *lineImgView;

@end

@implementation SJVideoRecommendView

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _lineImgView = [[UIImageView alloc] init];
        //_lineImgView.backgroundColor = kColorBlueTheme;
        _lineImgView.image = [UIImage imageNamed:@"Triangle"];
        [self addSubview:_lineImgView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = @"相关推荐";
        [self addSubview:_titleLabel];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        _collectionview.backgroundColor = [UIColor clearColor];
        _collectionview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_collectionview];
        [_collectionview registerNib:[UINib nibWithNibName:kSJVideoRecommendCellIdentifier bundle:nil] forCellWithReuseIdentifier:kSJVideoRecommendCellIdentifier];

        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];

    }
    return self;
}
- (void)orientationChanged:(NSNotification *)notification{
    // 收到 设备旋转 通知

    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    //    CGSize layoutSize ;

    if (screenSize.width > screenSize.height) {

    }else if(screenSize.width < screenSize.height){

      [self.collectionview reloadData];
    }
    
}
-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    _lineImgView = [[UIImageView alloc] init];
    //_lineImgView.backgroundColor = kColorBlueTheme;
    _lineImgView.image = [UIImage imageNamed:@"Triangle"];
    [self addSubview:_lineImgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:14.0];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.text = @"相关推荐";
    [self addSubview:_titleLabel];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionview.delegate = self;
    _collectionview.dataSource = self;
    _collectionview.backgroundColor = [UIColor clearColor];
    _collectionview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_collectionview];
    [_collectionview registerNib:[UINib nibWithNibName:kSJVideoRecommendCellIdentifier bundle:nil] forCellWithReuseIdentifier:kSJVideoRecommendCellIdentifier];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _lineImgView.frame = CGRectMake(kLineImgOriginx, kLeftSpacing + (kTitleLabelHeight - kLineImgHeight) / 2.0, kLineImgWidth, kLineImgHeight);
    
    _titleLabel.frame = CGRectMake(_lineImgView.frame.origin.x + kLineImgWidth + kLeftSpacing,
                                   kLeftSpacing,
                                   self.frame.size.width - kLeftSpacing * 2,
                                   kTitleLabelHeight);
    
    CGFloat originy = _titleLabel.frame.origin.y + _titleLabel.frame.size.height;
    
    _collectionview.frame = CGRectMake(5,
                                       originy,
                                       self.frame.size.width-10,
                                       self.frame.size.height - originy);
    
    self.height = _collectionview.frame.origin.y + _collectionview.contentSize.height;
    if (_list.count == 0) {
        _lineImgView.hidden = YES;
        _titleLabel.hidden = YES;
    }
    else{
        _lineImgView.hidden = NO;
        _titleLabel.hidden = NO;
    }
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    DDLogInfo(@"%zd",_list.count);
    return _list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SJVideoRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSJVideoRecommendCellIdentifier forIndexPath:indexPath];
    WatchListEntity *model = _list[indexPath.row];
    [cell showData:model];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_canSelected) {
        if (self.didSelectRecommendItemAtIndex) {
            self.didSelectRecommendItemAtIndex(indexPath.row);
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat width = (W-10 - kLeftSpacing * (kColumnCount - 1)) / kColumnCount;
    return CGSizeMake(width, kCellHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake( kLeftSpacing / 2.0, kLeftSpacing / 2.0, kLeftSpacing / 2.0, kLeftSpacing / 2.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView * )collectionView
                   layout:(UICollectionViewLayout * )collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kLeftSpacing;
}

#pragma mark - Setter && Getter
- (void)setList:(NSArray *)list
{
    _list = list;
    
    [_collectionview reloadData];
    
    [self setNeedsLayout];
}

- (CGFloat)height
{
    CGFloat cheight = kTitleLabelHeight + kLeftSpacing * 2;
    
    if (_list.count > 0) {
        
        NSInteger row = _list.count % kColumnCount == 0 ? _list.count / kColumnCount :(_list.count / kColumnCount + 1);
        
        cheight = row * kCellHeight + (row - 1) * kLeftSpacing + kTitleLabelHeight + kLeftSpacing * 2;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, cheight);
        
    }
    return cheight;
}

@end
