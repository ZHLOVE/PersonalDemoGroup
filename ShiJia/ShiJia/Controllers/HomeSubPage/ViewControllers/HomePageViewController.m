//
//  HomePageViewController.m
//  ShiJia
//
//  Created by 峰 on 2017/2/16.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "HomePageViewController.h"
#import "homeTableViewCell.h"
#import "DmsDataPovider.h"

@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource,HomeDelegate>

@property (nonatomic, strong) UITableView *homeTableView;
@property (nonatomic, strong) NSMutableArray <homeModel *>*dataArray;//全部数据
@property (nonatomic, strong) ChannelUnitModel *currentModel;
@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_refreshAfterUserLogin:)
                                                 name:kNotification_REFRASHMAIN
                                               object:nil];
    [self.view addSubview:self.homeTableView];
    [_homeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _homeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setChanelModel:_currentModel];
    }];
    MJRefreshGifHeader *header =(MJRefreshGifHeader *)_homeTableView.mj_header ;
    header.lastUpdatedTimeLabel.hidden = YES;
}

-(void)p_refreshAfterUserLogin:(NSNotification*)notification
{
    [_homeTableView.mj_header beginRefreshing];
}
-(void)setChanelModel:(ChannelUnitModel *)chanelModel{

    if (chanelModel.navigateId.length>0) {
//        [MBProgressHUD showMessag:@"正在加载" toView:self.view];
        [DmsDataPovider getNavigationDetailRequest:chanelModel.navigateId
                                        completion:^(NSArray *detailDatasArray) {
//                                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                            [self.dataArray removeAllObjects];
                                            NSArray *array = [homeModel mj_objectArrayWithKeyValuesArray:[detailDatasArray mutableCopy]];
                                            [self.dataArray addObjectsFromArray:array];

                                            [_homeTableView reloadData];
                                            [_homeTableView.mj_header endRefreshing];
                                        } failure:^(NSString *message) {
                                             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                            [MBProgressHUD showError:message toView:self.view];

                                            [_homeTableView.mj_header endRefreshing];
                                        }];
        self.currentModel = chanelModel;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    //    NSString *string  = _heightDataArray[indexPath.row];
    return   [homeTableViewCell figureUpCellHighWithData:self.dataArray[indexPath.row]];
    //    return [string floatValue];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray =[NSMutableArray new];
    }
    return _dataArray;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    homeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"homeTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    cell.delegate = self;
    [cell setCellModel:self.dataArray[indexPath.row]];
    return cell;

}


-(UITableView *)homeTableView{

    if (!_homeTableView) {
        _homeTableView = [UITableView new];
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;

        _homeTableView.showsVerticalScrollIndicator = NO;
        [_homeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _homeTableView.tableFooterView = [UIView new];
        _homeTableView.estimatedRowHeight = 100;
    }
    return _homeTableView;
}

-(void)HomeBricksCallBackWith:(homeModel *)model andContents:(contents *)contents andType:(NSInteger)type{
    if ([self.delegate respondsToSelector:@selector(MainBricksCallBackWith:andContents:andType:)]) {
        [self.delegate MainBricksCallBackWith:model andContents:contents andType:type];
    }

}


@end
