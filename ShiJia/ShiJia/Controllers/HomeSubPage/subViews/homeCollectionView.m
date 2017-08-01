//
//  homeCollectionView.m
//  ShiJia
//
//  Created by 峰 on 2017/2/16.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "homeCollectionView.h"
#import "homeComplicateItemCell.h"


#define kWidth 60.
#define kHeigh 95.
#define LeftRightSpace 6.
#define BottomHigh 51.
#define bottomLineColor   [UIColor colorWithHexString:@"e5e5e5"]
#define changeButtonColor [UIColor colorWithHexString:@"9a9a9a"]

@interface homeCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView     *bottomView;
@property (nonatomic, strong) NSMutableArray <contents *>*array;
@property (nonatomic, assign) CGFloat     CollectHeight;
@property (nonatomic, assign) NSInteger   showNumber;
@property (nonatomic, strong) UIButton   *changeButton;

@property (nonatomic, assign) NSInteger currentChooseCount;//当前取的次数
@property (nonatomic, assign) NSInteger allChooseCount;//一共可以取的次数
@property (nonatomic, strong) NSMutableArray <contents *>*currentShowData;


@end

@implementation homeCollectionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.collectionView];
        [self addSubview:self.bottomView];
        [self addSubviewsConstraint];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)addSubviewsConstraint{

    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(BottomHigh);
    }];
}
-(NSMutableArray<contents *> *)array{
    if (!_array) {
        _array = [NSMutableArray new];
    }
    return _array;
}

-(NSMutableArray<contents *> *)currentShowData{
    if (!_currentShowData) {
        _currentShowData = [NSMutableArray new];
    }
    return _currentShowData;
}

-(NSMutableArray *)configureCurrentData{
    if (_currentChooseCount>_allChooseCount) {
        NSInteger a = _currentChooseCount%_allChooseCount;
        if (a>0) {
            NSRange rang = NSMakeRange(_showNumber*(a-1),_showNumber);
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:rang];
            NSArray *resultArray = [self.array objectsAtIndexes:indexes];
            return [resultArray mutableCopy];
        }else{

            NSRange rang = NSMakeRange(_showNumber*(_allChooseCount-1),_showNumber);
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:rang];
            NSArray *resultArray = [self.array objectsAtIndexes:indexes];
            return [resultArray mutableCopy];
        }
    }else{
        NSRange rang = NSMakeRange((_currentChooseCount-1)*_showNumber,_showNumber);
        NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:rang];
        NSArray *resultArray = [self.array objectsAtIndexes:indexes];
        return [resultArray mutableCopy];
    }
}

-(void)setListModel:(homeModel *)listModel{

    _listModel = listModel;
    if (_array) {
        [_array removeAllObjects];
    }
    self.array = [listModel.contents mutableCopy];

    self.showNumber = [listModel.layout integerValue];

    self.currentChooseCount = 1;
    self.allChooseCount =(self.array.count+1)/[listModel.layout integerValue];
    self.currentShowData =  [self configureCurrentData];

    if ([listModel.showFresh isEqualToString:@"0"]) {
        _bottomView.hidden = YES;
    }

    self.CollectHeight = [listModel.layout integerValue]*(AutoSize_H_IP6(kHeigh)+57);
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(LeftRightSpace);
        make.right.mas_equalTo(self).offset(-LeftRightSpace);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(self.CollectHeight);

    }];
    [_collectionView reloadData];
}

#pragma mark UICollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.showNumber;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    homeComplicateItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeComplicateItemCell" forIndexPath:indexPath];
    if (indexPath.row<_currentShowData.count) {
        [cell setCellModel:_currentShowData[indexPath.row]];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if ([self.delegate respondsToSelector:@selector(clickHomeBricksCallBackWith: andIndexPath: andType:)]) {
//        [self.delegate clickHomeBricksCallBackWith:_listModel andIndexPath:indexPath.row andType:0];
//    }
    if ([self.delegate respondsToSelector:@selector(clickHomeBricksCallBackWith:andContents:andType:)]) {
        [self.delegate clickHomeBricksCallBackWith:_listModel
                                       andContents:_currentShowData[indexPath.row]
                                           andType:0];
    }
}

#pragma mark UI
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-2*LeftRightSpace-SJRealValue_W(LeftRightSpace))/2,(AutoSize_H_IP6(kHeigh)+kWidth+2));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = YES;
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerNib:[UINib nibWithNibName:@"homeComplicateItemCell" bundle:nil] forCellWithReuseIdentifier:@"homeComplicateItemCell"];
    }
    return _collectionView;
}


-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView new];

        UIView *line = [UIView new];
        line.backgroundColor = bottomLineColor;
        [_bottomView addSubview:line];

        _changeButton = [UIButton new];
        [_changeButton setTitle:@"  换一批看看" forState:UIControlStateNormal];
        [_changeButton setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
        [_changeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
#ifdef JiangSu
        [_changeButton setTitleColor:kColorBlueTheme forState:UIControlStateNormal];
#else
        [_changeButton setTitleColor:changeButtonColor forState:UIControlStateNormal];
#endif

        [_bottomView addSubview:_changeButton];

        [_changeButton addTarget:self
                          action:@selector(exChangeAction)
                forControlEvents:UIControlEventTouchUpInside];

        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.left.mas_equalTo(_bottomView);
            make.height.mas_equalTo(SJRealValue_W(1));
        }];

        [_changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.mas_equalTo(_bottomView);
            make.top.mas_equalTo(line.mas_bottom);
            make.height.mas_equalTo(AutoSize_H_IP6(BottomHigh-1));
        }];

    }
    return _bottomView;
}

-(void)exChangeAction{

    self.currentChooseCount = _currentChooseCount+1;
    
    self.currentShowData = [self configureCurrentData];
    
    [_collectionView reloadData];
}

@end
