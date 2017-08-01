//
//  SJVideoPlayerSeriesView.m
//  ShiJia
//
//  Created by yy on 16/4/15.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJVideoPlayerSeriesView.h"

#import "SJVideoPlayerSeriesViewCell.h"
#import "SJVideoPlayerSeriesViewTableCell.h"

#import "VideoSource.h"
#import "TVProgram.h"
#import "WatchFocusVideoProgramEntity.h"

CGFloat const kSeriesItemViewWidth = 55;
NSInteger const kSeriesColumnCount = 6;
static CGFloat kLineImgWidth = 10.0;
static CGFloat kLineImgHeight = 16.0;
static CGFloat kLineImgOriginx = 10.0;
static CGFloat kLabelHeight = 20.0;
static CGFloat kLeftSpacing = 10.0;

@interface SJVideoPlayerSeriesView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>
{
    UILabel *titleLabel;
    UIImageView *lineImgView;
    UICollectionView *collectionview;
    UITableView *tableview;

    NSArray *videoArray;
    NSInteger totalCount;
    SJSeriesViewStyle style;
}

@end

@implementation SJVideoPlayerSeriesView

#pragma mark - Lifecycle
- (instancetype)initWithSeriesList:(NSArray *)list style:(SJSeriesViewStyle)seriesStyle
{
    self = [super init];
    
    if (self) {
        
        style = seriesStyle;
        
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.7;
        
        [self setupTitleLabel];
        
        videoArray = [NSArray arrayWithArray:list];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    titleLabel.frame = CGRectMake(10,
//                                  10,
//                                  self.frame.size.width,
//                                  20);
//    
//    lineImgView.frame = CGRectMake(0,
//                                   titleLabel.frame.origin.y * 2 + titleLabel.frame.size.height,
//                                   self.frame.size.width,
//                                   1);
    lineImgView.frame = CGRectMake(kLineImgOriginx, kLeftSpacing + (kLabelHeight - kLineImgHeight) / 2.0, kLineImgWidth, kLineImgHeight);
    
    titleLabel.frame = CGRectMake(lineImgView.frame.origin.x + kLineImgWidth + kLeftSpacing, kLeftSpacing, self.frame.size.width - kLeftSpacing * 2, kLabelHeight);
    
    collectionview.frame = CGRectMake(0,
                                      titleLabel.frame.origin.y * 2 + titleLabel.frame.size.height,
                                      self.frame.size.width,
                                      self.frame.size.height - titleLabel.frame.origin.y * 2 - titleLabel.frame.size.height);
    
    tableview.frame = CGRectMake(0,
                                 titleLabel.frame.origin.y * 2 + titleLabel.frame.size.height,
                                 self.frame.size.width,
                                 self.frame.size.height - titleLabel.frame.origin.y * 2 - titleLabel.frame.size.height);
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
- (NSString *)setCellText:(NSIndexPath *)indexPath
{
    WatchFocusVideoProgramEntity *entity = videoArray[indexPath.row];
    if ([entity.class isSubclassOfClass:[WatchFocusVideoProgramEntity class]]&&entity.seriesNum) {
        return entity.seriesNum;
    }
    else if ([entity.class isSubclassOfClass:[VideoSource class]]){
        VideoSource *videoSource = (VideoSource *)entity;
        if (videoSource.setNumber.length >0 && [videoSource.setNumber intValue] != 0) {
            return videoSource.setNumber;
        }
        else{
            return [NSString stringWithFormat:@"%zd",indexPath.row + 1];
        }
    }
    else{
        return [NSString stringWithFormat:@"%zd",indexPath.row + 1];
    }
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return videoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SJVideoPlayerSeriesViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSJVideoPlayerSeriesViewCellIdentifier forIndexPath:indexPath];
    
    cell.text = [self setCellText:indexPath];
    cell.model = videoArray[indexPath.row];
    VideoSource *entity = videoArray[indexPath.row];
    if ([entity.class isSubclassOfClass:[VideoSource class]]&&(!entity.isEnable)) {
            cell.style = SJVideoPlayerSeriesViewCellStyleError;
    }
    else if (indexPath.row == _currentVideoIndex) {
        cell.style = SJVideoPlayerSeriesViewCellStylePlaying;
    }
    else{
        cell.style = SJVideoPlayerSeriesViewCellStyleNormal;
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentVideoIndex == indexPath.row) {
        return;
    }
    VideoSource *program = videoArray[indexPath.row];
    if (!program.isEnable) {
        [OMGToast showWithText:@"该集已下线"];
        return;
    }
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:_currentVideoIndex inSection:0];
    SJVideoPlayerSeriesViewCell *lastCell = (SJVideoPlayerSeriesViewCell *)[collectionView cellForItemAtIndexPath:lastIndexPath];
    lastCell.style = SJVideoPlayerSeriesViewCellStyleNormal;
    
    SJVideoPlayerSeriesViewCell *cell = (SJVideoPlayerSeriesViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.style = SJVideoPlayerSeriesViewCellStylePlaying;
    
    _currentVideoIndex = indexPath.row;
    
    if (self.didSelectVideoAtIndex) {
        self.didSelectVideoAtIndex(indexPath.row);
    }
    
    [self hide];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(kSeriesItemViewWidth, kSeriesItemViewWidth);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView * )collectionView
                   layout:(UICollectionViewLayout * )collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return videoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SJVideoPlayerSeriesViewTableCell *cell = [tableview dequeueReusableCellWithIdentifier:kSJVideoPlayerSeriesViewTableCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:kSJVideoPlayerSeriesViewTableCellIdentifier owner:self options:nil] lastObject];
    }
    
    if (indexPath.row == _currentVideoIndex) {
        cell.checked = YES;
    }
    else{
        cell.checked = NO;
    }
    
    id video = videoArray[indexPath.row];
    if ([video isKindOfClass:[TVProgram class]]) {
        
        TVProgram *program = video;
        [cell showText:[NSString stringWithFormat:@"%@     %@",program.displayedFullStartTime,program.programName]];
    }
    else if([video isKindOfClass:[VideoSource class]]){
        
        VideoSource *program = video;
        [cell showText:[NSString stringWithFormat:@"%@",program.name]];
    }
    else{
        
        WatchFocusVideoProgramEntity *program = video;
        [cell showText:[NSString stringWithFormat:@"%@",program.programName]];
    }
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.textAlignment = 1;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentVideoIndex == indexPath.row) {
        return;
    }
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:_currentVideoIndex inSection:0];
    SJVideoPlayerSeriesViewTableCell *lastCell = [tableview cellForRowAtIndexPath:lastIndexPath];
    SJVideoPlayerSeriesViewTableCell *cell = [tableview cellForRowAtIndexPath:indexPath];
    lastCell.checked = NO;
    cell.checked = YES;
    
    _currentVideoIndex = indexPath.row;
    
    if (self.didSelectVideoAtIndex) {
        self.didSelectVideoAtIndex(indexPath.row);
    }
    
    [self hide];
}

#pragma mark - Operation
- (void)showInView:(UIView *)view
{
    if (view) {
        
        _isShowing = YES;
        [view addSubview:self];
        
        if (style == SJSeriesViewStyleCollectionView) {
            [collectionview removeFromSuperview];
            
            if (collectionview == nil) {
                
                // 剧集
                UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
                collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
                collectionview.delegate = self;
                collectionview.dataSource = self;
                collectionview.backgroundColor = [UIColor clearColor];
                [collectionview registerNib:[UINib nibWithNibName:kSJVideoPlayerSeriesViewCellIdentifier bundle:nil] forCellWithReuseIdentifier:kSJVideoPlayerSeriesViewCellIdentifier];
//                collectionview.scrollEnabled = NO;
            }
            
            [self addSubview:collectionview];
        }
        else{
            
            [tableview removeFromSuperview];
            
            if (tableview == nil) {
                
                tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
                tableview.delegate = self;
                tableview.dataSource = self;
                tableview.backgroundColor = [UIColor clearColor];
                tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
                [tableview registerNib:[UINib nibWithNibName:kSJVideoPlayerSeriesViewTableCellIdentifier bundle:nil] forCellReuseIdentifier:kSJVideoPlayerSeriesViewTableCellIdentifier];
            }
            [self addSubview:tableview];
        }
        
    }
}

- (void)hide
{
    _isShowing = NO;
    [self removeFromSuperview];
}

#pragma mark - Subview
- (void)setupTitleLabel
{
    titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:13.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"选集";
    [self addSubview:titleLabel];
    
    lineImgView = [[UIImageView alloc] init];
//    lineImgView.backgroundColor = [UIColor colorWithHexString:@"444444"];
//    lineImgView.alpha = 0.8;
    lineImgView.image = [UIImage imageNamed:@"Triangle"];
    [self addSubview:lineImgView];
    [self bringSubviewToFront:lineImgView];
}

#pragma mark - Setter
- (void)setCurrentVideoIndex:(NSInteger)currentVideoIndex
{
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_currentVideoIndex inSection:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentVideoIndex inSection:0];
    
    if (videoArray == nil) {
        SJVideoPlayerSeriesViewCell *lastCell = (SJVideoPlayerSeriesViewCell *)[collectionview cellForItemAtIndexPath:lastPath];
        SJVideoPlayerSeriesViewCell *cell = (SJVideoPlayerSeriesViewCell *)[collectionview cellForItemAtIndexPath:indexPath];
        
        lastCell.style = SJVideoPlayerSeriesViewCellStyleNormal;
        cell.style = SJVideoPlayerSeriesViewCellStylePlaying;
    }
    else{
        
        SJVideoPlayerSeriesViewTableCell *lastCell = [tableview cellForRowAtIndexPath:lastPath];
        SJVideoPlayerSeriesViewTableCell *cell = [tableview cellForRowAtIndexPath:indexPath];
        lastCell.checked = NO;
        cell.checked = YES;
    }
    
    _currentVideoIndex = currentVideoIndex;
    
    [collectionview reloadData];
}

-(void)handle_dealloc
{
    if (style == SJSeriesViewStyleCollectionView) {
        collectionview.delegate = nil;
        collectionview.dataSource = nil;
        [collectionview removeFromSuperview];
    } else {
        tableview.delegate = nil;
        tableview.dataSource = nil;
        [tableview removeFromSuperview];
    }
}

- (void)dealloc {
    DDLogInfo(@"TODO####### VideoPlayerSeriesView dealloc");
}
@end
