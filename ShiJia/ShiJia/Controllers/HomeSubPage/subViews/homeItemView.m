//
//  homeItemView.m
//  ShiJia
//
//  Created by 峰 on 2017/2/16.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "homeItemView.h"
#import "homeSimpleItemCell.h"

#define kItemHigh  95
#define kHeight 5
#define LeftRightSpace 15

@interface homeItemView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <contents *>*contentArray;


@end


@implementation homeItemView
- (instancetype)init
{
    self = [super init];
    if (self) {

        [self addSubview:self.collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(LeftRightSpace);
            make.right.mas_equalTo(self).offset(-LeftRightSpace);
            make.top.mas_equalTo(self).offset(0);
            make.bottom.mas_equalTo(self).offset(0);
        }];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(NSMutableArray<contents *> *)contentArray{
    if (!_contentArray) {
        _contentArray = [NSMutableArray new];
    }
    return _contentArray;
}

-(void)setItemModel:(homeModel *)itemModel{
    if (_contentArray) {
        [_contentArray removeAllObjects];
    }
    _itemModel = itemModel;
    self.contentArray = [itemModel.contents mutableCopy];
    [_collectionView reloadData];
}

#pragma mark UICollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.contentArray.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,0,0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    homeSimpleItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeSimpleItemCell" forIndexPath:indexPath];
    [cell setCellModel:self.contentArray[indexPath.row]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

//    if ([self.delegate respondsToSelector:@selector(clickHomeBricksCallBackWith: andIndexPath:andType:)]) {
//        [self.delegate clickHomeBricksCallBackWith:_itemModel andIndexPath:indexPath.row andType:0];
//    }
    if ([self.delegate respondsToSelector:@selector(clickHomeBricksCallBackWith:andContents:andType:)]) {
        [self.delegate clickHomeBricksCallBackWith:_itemModel
                                       andContents:_itemModel.contents[indexPath.row]
                                           andType:0];
        
        contents *currentContent = _itemModel.contents[indexPath.row];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:currentContent.title forKey:@"co_name"];
        
        [UMengManager event:@"U_ClickCo" attributes:dic];

    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH-2*LeftRightSpace)/5, SJRealValue_W(kItemHigh));
}


-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-30)/4,SJRealValue_W(kItemHigh));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"homeSimpleItemCell" bundle:nil] forCellWithReuseIdentifier:@"homeSimpleItemCell"];
    }
    return _collectionView;
}



@end
