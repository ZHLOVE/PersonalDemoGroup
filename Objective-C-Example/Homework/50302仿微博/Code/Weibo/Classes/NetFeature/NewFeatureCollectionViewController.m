//
//  NewFeatureCollectionViewController.m
//  Weibo
//
//  Created by qiang on 5/3/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "NewFeatureCollectionViewController.h"

#import "NewFeatureCell.h"

@interface NewFeatureCollectionViewController ()

@end

@implementation NewFeatureCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 单元格模板
    [self.collectionView registerClass:[NewFeatureCell class] forCellWithReuseIdentifier:reuseIdentifier];

    // 为CollectionView设置新的布局对象
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
    // 大小
    fl.itemSize = [UIScreen mainScreen].bounds.size;
    // 方向
    fl.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 段间距
    fl.minimumLineSpacing = 0;
    // 项间距
    fl.minimumInteritemSpacing = 0;
    self.collectionView.collectionViewLayout = fl;

    // collectionView设置
    // 关闭边界空隙
    self.collectionView.bounces = NO;
    // 不显示滑动条
    self.collectionView.showsHorizontalScrollIndicator = NO;
    // 分页
    self.collectionView.pagingEnabled = YES;
}

#pragma mark <UICollectionViewDataSource>

// 有几项内容
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

// 单元格内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.imageIndex = indexPath.row;
    
    return cell;
}

@end
