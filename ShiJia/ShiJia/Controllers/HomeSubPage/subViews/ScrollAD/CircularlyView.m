//
//  CircularlyView.m
//  ShiJia
//
//  Created by 峰 on 2017/3/6.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "CircularlyView.h"
#import "CircularlyCell.h"
#define identifier @"cirularlyCell"

@interface CircularlyView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView            *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout  *flowLayout;
@property (nonatomic, strong) NSTimer                     *timer;
@property (nonatomic, assign) NSInteger                    imageCount;
@property (nonatomic, strong) NSMutableArray<contents*>    *DataArray;

@end

@implementation CircularlyView
- (void)dealloc {
    [self stopTimer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}
-(NSMutableArray<contents *> *)DataArray{
    if (!_DataArray) {
        _DataArray = [NSMutableArray new];
    }
    return _DataArray;
}


-(void)setDataSource:(NSArray<contents *> *)dataSource{
    _dataSource = dataSource;
    if (dataSource.count > 0) {
        [self setupTimer];
        _collectionView.scrollEnabled =_dataSource.count==1?NO:YES;
    }
    self.DataArray = [dataSource mutableCopy];
    [_DataArray addObject:dataSource.firstObject];
    [_DataArray insertObject:dataSource.lastObject atIndex:0];
    [_collectionView setContentOffset:CGPointMake(_collectionView.bounds.size.width, 0)];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self config];
    self.autoresizingMask = UIViewAutoresizingNone;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.flowLayout.itemSize = self.frame.size;
    self.collectionView.frame = self.bounds;
}
#pragma mark - NSTimer

- (void)setupTimer {
    if (self.dataSource.count <= 1) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.rollTime
                                                  target:self
                                                selector:@selector(autoScroll)
                                                userInfo:nil
                                                 repeats:YES];
}
- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}
#pragma mark - 配置控件
- (void)config {

    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    [self.collectionView registerNib:[UINib nibWithNibName:@"CircularlyCell" bundle:nil] forCellWithReuseIdentifier:identifier];

    [self addSubview:self.collectionView];
}
#pragma mark - 循环

/**
 *  获得当前图片在数组中的索引
 *
 *  @return 返回索引
 */
- (NSInteger)getCurrentIndex {


    NSInteger page = self.collectionView.contentOffset.x/self.collectionView.bounds.size.width;
    NSInteger index ;
    if (page == 0) {//滚动到左边
//        self.collectionView.contentOffset = CGPointMake(self.collectionView.bounds.size.width * (_DataArray.count - 2), 0);
        index = _DataArray.count-3;
    }else if (page == _DataArray.count - 1){//滚动到右边
//        self.collectionView.contentOffset = CGPointMake(self.collectionView.bounds.size.width, 0);
        index = 0;
    }else{
        index = page-1;
    }
    return index;
}



- (void)autoScroll {
    NSInteger targetIndex = [self getCurrentIndex] + 1 ;

    if (targetIndex==_DataArray.count-2) {
        [_collectionView setContentOffset:CGPointMake(_collectionView.bounds.size.width, 0)];
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}


#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _DataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CircularlyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell setCurrentContents:_DataArray[indexPath.row]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(CircularlyDidSelectItemAtIndex:)]) {
        [self.delegate CircularlyDidSelectItemAtIndex:indexPath.row-1];
        
        
        contents *currentContent = _DataArray[indexPath.row];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:currentContent.title forKey:@"banner_name"];
        
        [UMengManager event:@"U_ClickBanner" attributes:dic];
    }
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    NSInteger page = scrollView.contentOffset.x/scrollView.bounds.size.width;
    NSInteger index = 0;
    if (page == 0) {//滚动到左边
//        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width * (_DataArray.count - 2), 0);
        index = _DataArray.count -3;
    }else if (page == _DataArray.count - 1){//滚动到右边
//        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        index = 0;
    }else{
        index = page-1;
    }
    if ([self.delegate respondsToSelector:@selector(CircularlyCurrentPageIndex:)]) {
        [self.delegate CircularlyCurrentPageIndex:(index)];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    NSInteger page = scrollView.contentOffset.x/scrollView.bounds.size.width;
    NSInteger index = 0;
    if (page == 0) {//滚动到左边
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width * (_DataArray.count - 2), 0);
        index = _DataArray.count -3;
    }else if (page == _DataArray.count - 1){//滚动到右边
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        index = 0;
    }else{
        index = page-1;
    }
    if ([self.delegate respondsToSelector:@selector(CircularlyCurrentPageIndex:)]) {
        [self.delegate CircularlyCurrentPageIndex:(index)];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setupTimer];
}

#pragma mark － 默认为2.0S

- (NSTimeInterval)rollTime {
    if (!_rollTime) {
        _rollTime = 2.0;
    }
    return _rollTime;
}


@end
