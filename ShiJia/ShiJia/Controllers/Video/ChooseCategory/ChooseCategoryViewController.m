//
//  ChooseCategoryViewController.m
//  ShiJia
//
//  Created by 峰 on 2016/12/30.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//
#import "ChooseCategoryViewController.h"
#import "ChooseCategoryModel.h"
#import "HistoryViewCell.h"
#import "ChooseCategpryViewModel.h"
#import "SJShowDeteilSearchViewController.h"
#import "CustomFlowLayout.h"


@interface ChooseCategoryViewController ()<ChooseCategoryDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIButton                 *submitButton;
@property (nonatomic, strong) ChooseCategpryViewModel  *viewmodel;
@property (nonatomic, strong) UICollectionView         *categoryCollectionView;
@property (nonatomic, strong) HistoryViewCell          *cell;
@property (nonatomic, strong) UIView                   *headView;

@property (nonatomic, strong) NSArray <ChooseCategoryModel *>*tableData;
@property (nonatomic, assign) NSInteger                 superIndex;
@property (nonatomic, strong) NSMutableArray <NSIndexPath *>*currentIndexArray;
@property (nonatomic, strong) ChooseCategoryModel      *selectedModel;
@property (nonatomic, strong) NSMutableDictionary      *paramsDict;
@property (nonatomic, strong) NSString                 *StringTitle;
@end

@implementation ChooseCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"筛选";
    [MBProgressHUD showMessag:@"加载中" toView:nil];
    [self initUIAction];
    _viewmodel  = [ChooseCategpryViewModel new];
    _viewmodel.delegate = self;
    [_viewmodel ChooseRequestCategory];
}

-(NSMutableDictionary *)paramsDict{
//    if (!_paramsDict) {
        _paramsDict  = [NSMutableDictionary new];

//    }
    return _paramsDict;
}


-(NSArray<ChooseCategoryModel *> *)tableData{
    if (!_tableData) {
        _tableData = [NSArray new];
    }
    return _tableData;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [AppDelegate appDelegate].appdelegateService.coinView.hidden = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark UI

-(void)initUIAction{
    //初始化UI
    [self.view addSubview:self.categoryCollectionView];
    [self.view addSubview:self.submitButton];
    [self addSubViewsConstraints];
}

-(UICollectionView *)categoryCollectionView{
    if (!_categoryCollectionView) {
        CustomFlowLayout *flowLayout = [[CustomFlowLayout alloc] init];
        flowLayout.maximumInteritemSpacing = 8;
        _categoryCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_categoryCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        [_categoryCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        _categoryCollectionView.delegate = self;
        _categoryCollectionView.dataSource = self;
                flowLayout.minimumLineSpacing = 8;
                flowLayout.minimumInteritemSpacing = 8;
        flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 20);
        flowLayout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH, 10);
        _categoryCollectionView.backgroundColor = [UIColor clearColor];
        _categoryCollectionView.showsHorizontalScrollIndicator = NO;
        _categoryCollectionView.showsVerticalScrollIndicator = NO;
        _categoryCollectionView.scrollEnabled = YES;
        [_categoryCollectionView registerNib:[UINib nibWithNibName:@"HistoryViewCell" bundle:nil] forCellWithReuseIdentifier:@"HistoryViewCell"];
    }
    return _categoryCollectionView;
}

-(UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_submitButton setBackgroundColor:[UIColor whiteColor]];
        [_submitButton setTintColor:[UIColor blackColor]];
        [_submitButton setTitle:@"确       定" forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submition:) forControlEvents:UIControlEventTouchUpInside];
        _submitButton.titleLabel.textAlignment=1;

    }
    return _submitButton;
}
-(void)addSubViewsConstraints{
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(50.);
    }];
    [_categoryCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(5);
        make.bottom.mas_equalTo(self.view).offset(-50);
    }];

}

#pragma  mark -tableView  Delegate & DataSource
#pragma  mark 根据第一secton选择的row 刷新 collectView 数据 获取当前标签的section
-(NSInteger)getCurrentSectionWithNumber:(NSInteger)index{
    NSInteger cout = 1;
    ChooseCategoryModel *model = [_tableData objectAtIndex:index];
    cout += model.condition.count;
    if (model.sort.count>0) {
        cout +=1;
    }
    return cout;
}
#pragma mark 获取当前section的 row 数量

-(NSInteger)getCurrentRowsWithIndexSection:(NSInteger)section{

    if (section==0) {
        return _tableData.count;
    }else{
        ChooseCategoryModel *model = [_tableData objectAtIndex:_superIndex];
        if (section<model.condition.count+1) {
            Condition *model1 = model.condition[section-1];
            NSArray *array = [model1.value componentsSeparatedByString:@","];
            return array.count+1;
        }else{
            return  model.sort.count;
        }
    }
}
#pragma mark 获取当前index 的cell的标题

-(NSString *)getRowTitleString:(NSIndexPath*)index{
    if (index.section==0) {
        ChooseCategoryModel *model = [_tableData objectAtIndex:index.row];
        return model.value;
    }else{
        ChooseCategoryModel *model = [_tableData objectAtIndex:_superIndex];
        if (index.section<model.condition.count+1) {
            Condition *model1 = model.condition[index.section-1];

            NSArray *array = [model1.value componentsSeparatedByString:@","];
            NSMutableArray *arrayTemp = [array mutableCopy];
            [arrayTemp insertObject:@"全部" atIndex:0];
            return arrayTemp[index.row];
        }else{
            Sort *model2 = model.sort[index.row];
            return model2.title;
        }
    }
}

-(void)getSelecedRowTitle:(NSIndexPath *)index{
    if (index.section==0) {
        ChooseCategoryModel *model = [_tableData objectAtIndex:index.row];
        [_paramsDict setValue:model.key forKey:@"key1"];
        [_paramsDict setValue:model.value forKey:@"value1"];
    }else{
        ChooseCategoryModel *model = [_tableData objectAtIndex:_superIndex];
        if (index.section<model.condition.count+1) {
            Condition *model1 = model.condition[index.section-1];
            NSArray *array = [model1.value componentsSeparatedByString:@","];
            NSMutableArray *arrayTemp = [array mutableCopy];
            [arrayTemp insertObject:@"全部" atIndex:0];

            NSString *keyString = [NSString stringWithFormat:@"key%ld",index.section+1];
            NSString *valueString = [NSString stringWithFormat:@"value%ld",index.section+1];
            if (![arrayTemp[index.row] isEqualToString:@"全部"]) {
                [_paramsDict setValue:model1.key forKey:keyString];
                [_paramsDict setValue:arrayTemp[index.row] forKey:valueString];
            }else{
                [_paramsDict removeObjectForKey:keyString];
                [_paramsDict removeObjectForKey:valueString];
            }


        }else{
            NSString *keyString = [NSString stringWithFormat:@"key%ld",model.condition.count+2];
            NSString *valueString = [NSString stringWithFormat:@"value%ld",model.condition.count+2];
            Sort *model2 = model.sort[index.row];
            [_paramsDict setValue:model2.key forKey:keyString];
            [_paramsDict setValue:model2.value forKey:valueString];
            self.StringTitle = model2.title;

        }
    }
}



#pragma mark 获取当前section标题

-(NSString *)getSectionTitle:(NSIndexPath *)index{

    if (index.section==0) {
        ChooseCategoryModel *model = [_tableData objectAtIndex:0];
        return model.title;
    }else{
        ChooseCategoryModel *model = [_tableData objectAtIndex:_superIndex];
        if (index.section<model.condition.count+1) {
            Condition *model1 = model.condition[index.section-1];
            return model1.title;
        }else{
            Sort *model2 = model.sort[index.section-1-model.condition.count];
            return model2.title;

        }
    }
}
#pragma mark 选择当前的标签
-(void)setSuperIndex:(NSInteger)superIndex{
    _superIndex = superIndex;
    _paramsDict = self.paramsDict;
    NSInteger cout = 1;
    ChooseCategoryModel *model = [_tableData objectAtIndex:superIndex];
    for (int i=0; i<model.condition.count; i++) {
        NSString *keyString = [NSString stringWithFormat:@"key%d",i+1];
        [_paramsDict setValue:@"全部" forKey:keyString];
    }

    cout += model.condition.count;
    if (model.sort.count>0) {
        cout +=1;
    }
    self.currentIndexArray = [NSMutableArray arrayWithCapacity:cout];


    for (int i=0; i<cout; i++) {
        NSIndexPath *object = [NSIndexPath indexPathForRow:0 inSection:i];
        [self.currentIndexArray addObject:object];
    }
    [_paramsDict setValue:model.key forKey:@"key1"];
    [_paramsDict setValue:model.value forKey:@"value1"];

    NSString *keyString = [NSString stringWithFormat:@"key%ld",(long)cout];
    NSString *valueString = [NSString stringWithFormat:@"value%ld",(long)cout];
    [_paramsDict setValue:[model.sort objectAtIndex:0].key forKey:keyString];
    [_paramsDict setValue:[model.sort objectAtIndex:0].value forKey:valueString];
     self.StringTitle = [model.sort objectAtIndex:0].title;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return [self getCurrentSectionWithNumber:_superIndex];
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;

    if (kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        reusableview = headerView;

        for (UILabel *label in reusableview.subviews) {
            [label removeFromSuperview];
        }
        UILabel *linelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 2, 20)];
        UILabel *title  = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH-50, 20)];
        title.text = [self getSectionTitle:indexPath];
        title.textColor = [UIColor blackColor];
        linelabel.backgroundColor = kColorBlueTheme;

        [reusableview addSubview:linelabel];
        [reusableview addSubview:title];

        return reusableview;
    }else if(kind == UICollectionElementKindSectionFooter&reusableview==nil){
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];

        reusableview = footerview;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-20, 1)];
        label.backgroundColor = kColorLightGray;

        [reusableview addSubview:label];



        return reusableview;
    }else return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self getCurrentRowsWithIndexSection:section];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 10, 10, 10);//分别为上、左、下、右
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HistoryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HistoryViewCell" forIndexPath:indexPath];
    if (indexPath.section==0) {
        if (_superIndex==indexPath.row) {
            [cell setHighlighted:YES];
            [self getSelecedRowTitle:indexPath];
        }else{
            [cell setHighlighted:NO];
        }
    }else{
        NSIndexPath *path = _currentIndexArray[indexPath.section];
        if (path.row==indexPath.row) {
            [cell setHighlighted:YES];
            [self getSelecedRowTitle:indexPath];
        }else{
            [cell setHighlighted:NO];
        }
    }
    cell.keyword = [self getRowTitleString:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_cell == nil) {
        _cell = [[NSBundle mainBundle]loadNibNamed:@"HistoryViewCell" owner:nil options:nil][0];

    }
    _cell.keyword = [self getRowTitleString:indexPath];
    return [_cell sizeForCell];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {

        [self setSuperIndex:indexPath.row];
    }
    NSMutableArray *array = self.currentIndexArray;
    [array replaceObjectAtIndex:indexPath.section withObject:indexPath];
    self.currentIndexArray = array;
    [_categoryCollectionView reloadData];
}

#pragma mark button Action
-(void)submition:(id)sender{

    SJShowDeteilSearchViewController *searchViewController = [[SJShowDeteilSearchViewController alloc]init];
    searchViewController.requestParams = _paramsDict;
    searchViewController.storString = self.StringTitle;
    
    [_paramsDict setValue:@"1" forKey:@"unionType"];
    [_paramsDict setValue:@"all" forKey:@"psType"];
    [_paramsDict setValue:@15 forKey:@"limit"];
    [_paramsDict setValue:@0 forKey:@"start"];
    NSString  *stringID = [NSString stringWithFormat:@"%@,%@",[HiTVGlobals sharedInstance].epg_groupId,[HiTVGlobals sharedInstance].live_templateId];
    [_paramsDict setValue:stringID forKey:@"templateId"];
    [_paramsDict setValue:@"all" forKey:@"searchType"];
    [_paramsDict setValue:T_STBext forKey:@"STBext"];

    [self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark Delegate

-(void)receiveCategoryData:(NSArray *)array{
    [MBProgressHUD hideHUD];
    _tableData = array;
    [self setSuperIndex:0];
    [_categoryCollectionView reloadData];
}

-(void)receiveCategoryError:(NSError *)error{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:[error localizedDescription] toView:self.view];
    
}
@end
