//
//  RecommendView.m
//  ShiJia
//
//  Created by 蒋海量 on 2017/3/13.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "RecommendView.h"
#import "RecommendCollectionViewCell.h"
#import "RecommendCollectionViewCell2.h"



#define middleSpace 8.
#define topSpace 10.
#define LeftRightSpace 8
#define itemHeight 185.
#define itemWidth (SCREEN_WIDTH-2*LeftRightSpace-middleSpace)/2


static NSString* const KRecommendCollectionViewCellID = @"RecommendCollectionViewCell2";

@interface RecommendView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic)  UICollectionView *collectionView;
@property (strong, nonatomic) NSArray* recommendArray;
@property (nonatomic, strong) UIView *noDataView;
@property (strong, nonatomic)  UIView *defaultView;

@end

@implementation RecommendView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
    
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        
        [self addSubview:self.collectionView];
        
        [self.collectionView.mj_header beginRefreshing];
        
    }
    return self;
}
    
- (void)layoutSubviews
{
    [super layoutSubviews];
        
    _collectionView.frame = self.bounds;
        
}
#pragma mark UI
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        // 创建瀑布流layout
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = YES;
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerNib:[UINib nibWithNibName:KRecommendCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:KRecommendCollectionViewCellID];
        
        
        WEAKSELF
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            [weakSelf loadRecommendRequest];
        }];
    }
    return _collectionView;
}
#pragma mark - 刷新数据
- (void)p_reloadData {
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {

    return self.recommendArray.count;
}
    
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
    
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        WatchListEntity *entity = self.recommendArray[indexPath.row];
        RecommendCollectionViewCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KRecommendCollectionViewCellID forIndexPath:indexPath];
        cell.cellModel = entity;
        return cell;
}
    
    
    
#pragma mark - UICollectionViewDelegate (GODETAIL 看单)
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WatchListEntity *content = self.recommendArray[indexPath.row];
    if (self.m_delegate) {
        [self.m_delegate goDetailVC:content];
    }
}
    
#pragma mark – UICollectionViewDelegateFlowLayout
    
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(itemWidth,AutoSize_H_IP6(itemHeight));
    
}
    
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
        return CGSizeZero;
}
    
    
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, LeftRightSpace, 10, LeftRightSpace);
}
    
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}
    
- (CGFloat)collectionView:(UICollectionView * )collectionView
                   layout:(UICollectionViewLayout * )collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    return 0;
    
    
}
#pragma mark - 个性推荐
-(void)loadRecommendRequest{
    __weak typeof(self) this = self;
    NSString* url = [NSString stringWithFormat:@"%@personal/getRecommendList",
                     MYEPG];
    
    NSDictionary *param = @{
                            @"userId" : [HiTVGlobals sharedInstance].uid,
                            // @"tvTemplateId" : WATCHTVGROUPID,
                            //@"vodTemplateId" : [[HiTVGlobals sharedInstance]getEpg_groupId],
                            @"abilityString" :  T_STBext,
                            @"deviceType" : @"mobile",
                            @"limitNum" : @"0",
                            };
    
    DDLogInfo(@"url: %@", url);
    [BaseAFHTTPManager postRequestOperationForHost:url forParam:@"" forParameters:param completion:^(id responseObject) {
        self.defaultView.hidden = YES;
        if (!this) {
            return;
        }
        NSMutableArray *resultArray = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"resultList"]) {
            WatchListEntity* entity = [[WatchListEntity alloc]initWithDictionary:dic];
            [resultArray addObject:entity];
        }
        this.recommendArray = resultArray;
        if (this.recommendArray.count == 0) {
            self.noDataView.hidden = NO;
        }
        else{
            self.noDataView.hidden = YES;
        }
        [this p_reloadData];
        [self.collectionView.mj_header endRefreshing];
        
        [NSUserDefaultsManager  saveObject:@"猜你想看"forKey:@"ProgramListClick_listname"];
        
        
    } failure:^( NSString *error) {
        self.defaultView.hidden = NO;
        if (!this) {
            return;
        }
        this.recommendArray = nil;
        [this p_reloadData];
        [self.collectionView.mj_header endRefreshing];
    }];
}
#pragma mark NOData View
-(UIView *)noDataView{
    
    if (!_noDataView) {
        _noDataView = [UIView new];
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_kandan_empty"]];
        [_noDataView addSubview:imageV];
        
        UILabel *label =[UILabel new];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = 1;
        label.text = @"可以先去别的地方看看";
        label.font = [UIFont systemFontOfSize:14.0f];
        [_noDataView addSubview:label];
        
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_noDataView);
            make.size.mas_equalTo(CGSizeMake(85, 85));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_noDataView);
            make.height.mas_equalTo(10);
            make.top.mas_equalTo(imageV.mas_bottom).offset(10);
        }];
        
        _noDataView.frame = CGRectMake(0, 0, 200, 120);
        _noDataView.center = CGPointMake(W/2, H/2-100);
        [self.collectionView addSubview:_noDataView];
    }
    return _noDataView;
}
-(void)reload{
    [self.collectionView.mj_header beginRefreshing];
    
}
-(UIView *)defaultView{
    if (!_defaultView) {
        
        _defaultView = [UIView new];
        _defaultView.userInteractionEnabled = YES;
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nonetwork"]];
        [_defaultView addSubview:imageV];
        
        
        UILabel *label =[UILabel new];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = 1;
        label.font = [UIFont systemFontOfSize:14];
        NSString *str = @"网络连接失败,点击重试";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,8)];
        [attr addAttribute:NSForegroundColorAttributeName value:kColorBlueTheme range:NSMakeRange(9,2)];
        label.attributedText = attr;
        label.userInteractionEnabled = YES;
        [_defaultView addSubview:label];
        
        UIButton *retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        retryBtn.backgroundColor = [UIColor clearColor];
        [retryBtn addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
        [_defaultView addSubview:retryBtn];
        
        
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_defaultView);
            make.size.mas_equalTo(CGSizeMake(85, 85));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_defaultView);
            make.size.mas_equalTo(CGSizeMake(150, 50));
            make.top.mas_equalTo(imageV.mas_bottom).offset(10);
        }];
        
        [retryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(label.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(40, 30));
            make.top.mas_equalTo(imageV.mas_bottom).offset(10);
        }];
        
        [self addSubview:_defaultView];
        [_defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(180, 180));
            make.top.mas_equalTo(self).offset(160);
        }];
    }
    
    return _defaultView;
}
@end
