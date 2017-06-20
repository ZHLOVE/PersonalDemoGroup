//
//  NewFeatureCollectionViewController.m
//  Weibo
//
//  Created by qiang on 5/3/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "NewFeature.h"

#import "NewFeatureCell.h"

@interface NewFeature ()

@end

@implementation NewFeature

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 单元格模板
    [self.collectionView registerClass:[NewFeatureCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    // 调整CollectionView的布局
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
    // 大小
    fl.itemSize = [UIScreen mainScreen].bounds.size;
    // 方向
    fl.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // Cell之间的间距
    fl.minimumLineSpacing = 0;// 段之间
    fl.minimumInteritemSpacing = 0;// 项之间
    
    self.collectionView.collectionViewLayout = fl;
    
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
}

#pragma mark <UICollectionViewDataSource>

// 有几项内容
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.imageIndex = indexPath.row;
    
    return cell;
}

@end
