//
//  SJShowDeteilSearchViewController.m
//  ShiJia
//
//  Created by 峰 on 2017/1/4.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "SJShowDeteilSearchViewController.h"
#import "ChooseCategpryViewModel.h"
#import "SearchCollectionCell.h"
#import "SJMultiVideoDetailViewController.h"
#import "WatchListEntity.h"

@interface SJShowDeteilSearchViewController ()<ChooseCategoryDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) ChooseCategpryViewModel  *viewmodel;
@property (nonatomic, strong) NSMutableArray <programSeries *>*dataArray;
@property (nonatomic, strong) NSMutableDictionary *dictParams;


@property (nonatomic, strong) UILabel *categpryLabel;
@property (nonatomic, strong) UICollectionView *searchCollection;
@property (nonatomic, strong) UIView *noDataView;
@property (nonatomic, assign) NSInteger pagenumber;
@end

@implementation SJShowDeteilSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选";
    [MBProgressHUD showMessag:@"加载中" toView:nil];
    [self initUIAction];

    [self bindViewModel];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

-(NSMutableArray<programSeries *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

#pragma  mark UI Action
-(void)initUIAction{

    [self.view addSubview:self.categpryLabel];

    [_categpryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    [self.view addSubview:self.searchCollection];
    [_searchCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(_categpryLabel.mas_bottom);
    }];

}

-(UILabel *)categpryLabel{
    if (!_categpryLabel) {
        _categpryLabel = [UILabel new];
        _categpryLabel.textAlignment = 1;
        _categpryLabel.font = [UIFont systemFontOfSize:14];
        _categpryLabel.textColor = kColorLightGray;
        _categpryLabel.backgroundColor = [UIColor whiteColor];
    }
    return _categpryLabel;
}

-(UICollectionView *)searchCollection{
    if (!_searchCollection) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-30)/3,180);
        _searchCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _searchCollection.delegate = self;
        _searchCollection.dataSource = self;
        _searchCollection.backgroundColor = [UIColor clearColor];
        _searchCollection.showsHorizontalScrollIndicator = YES;
        _searchCollection.showsVerticalScrollIndicator = YES;
        _searchCollection.scrollEnabled = YES;
        [_searchCollection registerNib:[UINib nibWithNibName:@"SearchCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"SearchCollectionCell"];


    }
    return _searchCollection;
}

-(NSMutableDictionary *)requestParams{
    if (!_requestParams) {
        _requestParams = [NSMutableDictionary new];
    }
    return _requestParams;
}

-(void)bindViewModel{

    _viewmodel = [ChooseCategpryViewModel new];
    _viewmodel.delegate = self;
    self.dictParams = [[NSMutableDictionary alloc]initWithDictionary:_requestParams.copy];
    [_viewmodel RequestChooseItemData:_requestParams];
    NSMutableDictionary *dict =  _requestParams;
    _pagenumber = [[_requestParams objectForKey:@"start"] integerValue];
    _pagenumber++;
    [dict removeObjectForKey:@"unionType"];
    [dict removeObjectForKey:@"psType"];
    [dict removeObjectForKey:@"start"];
    [dict removeObjectForKey:@"templateId"];
    [dict removeObjectForKey:@"searchType"];
    [dict removeObjectForKey:@"STBext"];
    [dict removeObjectForKey:@"limit"];

    NSMutableArray *tempArray = [NSMutableArray new];
    for (NSString *key in [dict allKeys]) {
        if ([key containsString:@"value"]) {
            if ([self IsChinese:dict[key]]) {
                [tempArray addObject:dict[key]];
            }
            if ([self isPureInt:dict[key]]) {
                [tempArray addObject:dict[key]];
            }
        }
    }
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:tempArray.count];

    for (NSString *item in tempArray) {
        if (![result containsObject:item]) {
            [result addObject:item];
        }
    }
    NSString *title = [[result reverseObjectEnumerator ].allObjects componentsJoinedByString:@","];
    title = [title stringByReplacingOccurrencesOfString:@"," withString:@"、"];
    title = [NSString stringWithFormat:@"%@、%@",title, self.storString];
    _categpryLabel.text = [NSString stringWithFormat:@"筛选结果：%@",title];
    _searchCollection.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [_dictParams setValue:@(_pagenumber*15) forKey:@"start"];
        [_viewmodel RequestChooseItemData:_dictParams];

    }];
}

-(BOOL)IsChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark UICollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _dataArray.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0f;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(7, 7, 7, 7);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchCollectionCell" forIndexPath:indexPath];
    [cell setCellmodel:_dataArray[indexPath.row]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    programSeries *model = _dataArray[indexPath.row];
    SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
    detailVC.videoID = model.id;
    //    detailVC.categoryID = model.id;
    //    WatchListEntity *entity = [[WatchListEntity alloc]init];
    //    entity.contentType = model.searchType;
    //    detailVC.watchEntity = entity;

    [self.navigationController pushViewController:detailVC animated:YES];
    [self umengEvent:model.name];
    [self umengEventPlay:model.name];
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
        label.text = @"没有筛选到您要的内容";
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
        [_searchCollection addSubview:_noDataView];

    }
    return _noDataView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


-(void)receiveSearchData:(NSArray *)array{
 [MBProgressHUD hideHUD];
    if (array.count==0) {
        if (_dataArray.count==0) {
           _noDataView = self.noDataView;
        }
        [_searchCollection.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.dataArray addObjectsFromArray:array];
        [_searchCollection reloadData];
        _pagenumber++;
        [_searchCollection.mj_footer endRefreshing];
    }
}

-(void)receiveCategoryError:(NSError *)error{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:[error localizedDescription] toView:self.view];
    [_searchCollection.mj_footer endRefreshingWithNoMoreData];
    
}
#pragma mark - 友盟统计
-(void)umengEvent:(NSString *)result{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.dictParams[@"value1"] forKey:@"classify"];
    [dic setValue:self.dictParams[@"value2"] forKey:@"period"];
    [dic setValue:self.dictParams[@"value3"] forKey:@"region"];
    [dic setValue:self.dictParams[@"value4"] forKey:@"type"];
    [dic setValue:self.dictParams[@"value5"] forKey:@"sort"];

    [dic setValue:result forKey:@"result"];
    
    [UMengManager event:@"U_Filter" attributes:dic];
}
#pragma mark - 友盟统计播放
-(void)umengEventPlay:(NSString *)content{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"常规视频" forKey:@"type_name"];
    [dic setValue:@"首页" forKey:@"first_nav"];
    [dic setValue:@"筛选" forKey:@"sec_nav"];
    [dic setValue:content forKey:@"program_name"];
    
    [UMengManager event:@"U_Play" attributes:dic];
}
@end
