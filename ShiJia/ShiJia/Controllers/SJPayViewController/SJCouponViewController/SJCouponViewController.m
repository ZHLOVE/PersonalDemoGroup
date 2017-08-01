//
//  SJCouponViewController.m
//  ShiJia
//
//  Created by 峰 on 16/9/2.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//
//TODO: 加入缺省页

#import "SJCouponViewController.h"
#import "YFViewPager.h"
#import "SJSaleCouponCell.h"
#import "HiTVGlobals.h"
#import "SJCoupViewModel.h"
#import "SJPurchaseModel.h"
#import "OrderListViewController.h"
#import "VideoCategory.h"
#import "VideoCategoryDetailViewController.h"

@interface SJCouponViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) YFViewPager *pageVC;
@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UITableView *tableview1;
@property (nonatomic, strong) UITableView *tableview2;
@property (nonatomic, strong) UITableView *tableview3;

@property (nonatomic, strong) SJCoupViewModel *viewModel;

@property (nonatomic, strong) NSMutableArray <SJTicketsModel *>*table1Data;
@property (nonatomic, strong) NSMutableArray <SJTicketsModel *>*table2Data;
@property (nonatomic, strong) NSMutableArray <SJTicketsModel *>*table3Data;

@property (nonatomic, strong) SJGetTicketsModel *request1;
@property (nonatomic, strong) SJGetTicketsModel *request2;
@property (nonatomic, strong) SJGetTicketsModel *request3;

@property (nonatomic, strong) NSString *pageNo1;
@property (nonatomic, strong) NSString *pageNo2;
@property (nonatomic, strong) NSString *pageNo3;
@property (nonatomic, strong) NSString *pageSize;


@property (nonatomic, strong) UIView *noDataView;


@end

@implementation SJCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;

    self.title = @"优惠券";
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(self.view);
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self bindViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(SJGetTicketsModel *)request1{
    _request1 = [SJGetTicketsModel new];
    _request1.uid = [HiTVGlobals sharedInstance].uid;
    _request1.businessType = @"VIDEO";
    _request1.state = @"UNUSE";
    _request1.pageNo = self.pageNo1;
    _request1.pageSize = self.pageSize;
    _request1.source = @"IOS";
    return _request1;
}
-(SJGetTicketsModel *)request2{
    _request2 = [SJGetTicketsModel new];
    _request2.uid = [HiTVGlobals sharedInstance].uid;
    _request2.businessType = @"VIDEO";
    _request2.state = @"USED";
    _request2.pageNo = self.pageNo2;
    _request2.pageSize = self.pageSize;
    _request1.source = @"IOS";
    return _request2;
}
-(SJGetTicketsModel *)request3{
    _request3 = [SJGetTicketsModel new];
    _request3.uid = [HiTVGlobals sharedInstance].uid;
    _request3.businessType = @"VIDEO";
    _request3.state = @"INVALID";
    _request3.pageNo = self.pageNo3;
    _request3.pageSize = self.pageSize;
    _request1.source = @"IOS";
    return _request3;
}


-(UITableView *)tableview1{
    if (!_tableview1) {
        _tableview1 = [[UITableView alloc]init];
        _tableview1.delegate = self;
        _tableview1.dataSource= self;
        _tableview1.backgroundColor = [UIColor clearColor];
        _tableview1.tag = 1;
        [_tableview1 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableview1.tableFooterView = [UIView new];
        [_tableview1 registerNib:[UINib nibWithNibName:@"SJSaleCouponCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    }
    return _tableview1;
}
-(UITableView *)tableview2{
    if (!_tableview2) {
        _tableview2 = [[UITableView alloc]init];
        _tableview2.backgroundColor = [UIColor clearColor];
        _tableview2.delegate = self;
        _tableview2.dataSource= self;
        [_tableview2 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableview2.tag = 2;
        _tableview2.tableFooterView = [UIView new];
        [_tableview2 registerNib:[UINib nibWithNibName:@"SJSaleCouponCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
        
    }
    return _tableview2;
}
-(UITableView *)tableview3{
    if (!_tableview3) {
        _tableview3 = [[UITableView alloc]init];
        _tableview3.delegate = self;
        _tableview3.dataSource= self;
        _tableview3.backgroundColor = [UIColor clearColor];
        [_tableview3 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableview3.tag = 3;
        _tableview3.tableFooterView = [UIView new];
        [_tableview3 registerNib:[UINib nibWithNibName:@"SJSaleCouponCell" bundle:nil] forCellReuseIdentifier:@"cell3"];
    }
    return _tableview3;
}

-(NSMutableArray<SJTicketsModel *> *)table1Data{
    if (!_table1Data) {
        _table1Data = [NSMutableArray new];
        
    }
    return _table1Data;
}

-(NSMutableArray<SJTicketsModel *> *)table2Data{
    if (!_table2Data) {
        _table2Data = [NSMutableArray new];
        
    }
    return _table2Data;
}
-(NSMutableArray<SJTicketsModel *> *)table3Data{
    if (!_table3Data) {
        _table3Data = [NSMutableArray new];
        
    }
    return _table3Data;
}

-(void)bindViewModel{
    _viewModel = [SJCoupViewModel new];
    [self loadTableView1DataSource];
    
}

-(void)loadTableView1DataSource{
    
    @weakify(self)
    [[_viewModel getUnUseTickets:self.request1] subscribeNext:^(id x) {
        @strongify(self);
        self.table1Data = [x mutableCopy];
        
        [self.tableview1 reloadData];
        if (self.table1Data.count==0) {
            [self.topView addSubview:self.noDataView];
            [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(133, 112));
                make.centerX.mas_equalTo(self.topView);
                make.top.mas_equalTo(self.topView).offset(150);
            }];
        }else{
            [self.noDataView removeFromSuperview];
        }
    } error:^(NSError *error) {
        
    } completed:^{
        
    }];
}

-(void)loadTableView2DataSource{
    
    @weakify(self)
    [[_viewModel getUsedTickets:self.request2]subscribeNext:^(id x) {
        @strongify(self);
        self.table2Data = [x mutableCopy];
        
        [self.tableview2 reloadData];
        if (self.table2Data.count==0) {
            [self.topView addSubview:self.noDataView];
            [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(133, 112));
                make.centerX.mas_equalTo(self.topView);
                make.top.mas_equalTo(self.topView).offset(150);
            }];
        }else{
            [self.noDataView removeFromSuperview];
        }
        
    } error:^(NSError *error) {
        
    } completed:^{
        
    }];
}

-(void)loadTableView3DataSource{
    
    @weakify(self)
    [[_viewModel getInvailTickets:self.request3]subscribeNext:^(id x) {
        @strongify(self);
        self.table3Data = [x mutableCopy];
        
        [self.tableview3 reloadData];
        if (self.table3Data.count==0) {
            [self.topView addSubview:self.noDataView];
            [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(133, 112));
                make.centerX.mas_equalTo(self.topView);
                make.top.mas_equalTo(self.topView).offset(150);
            }];
        }else{
            [self.noDataView removeFromSuperview];
        }
        
    } error:^(NSError *error) {
        
    } completed:^{
        
    }];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    if (tableView==self.tableview1) {
        return self.table1Data.count;
    }else if (tableView==self.tableview2){
        return self.table2Data.count;
    }else if(tableView==self.tableview3){
        return self.table3Data.count;
    }else{
        return 0;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95.;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView==self.tableview1) {
        SJSaleCouponCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        tableView.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        [cell setUnUseCellWithModel:self.table1Data[indexPath.section]];
        
        return cell;
    }else if (tableView==self.tableview2){
        SJSaleCouponCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        tableView.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        [cell setUsedCellWithModel:self.table2Data[indexPath.section]];
        return cell;
    }else{
        SJSaleCouponCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
        [cell setInvailCellWithModel:self.table3Data[indexPath.section]];
        cell.backgroundColor = [UIColor clearColor];
        tableView.backgroundColor = [UIColor clearColor];
        return cell;
    }
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tableview1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        SJTicketsModel *model = self.table1Data[indexPath.section];
        if ([model.action isEqualToString:@"openActivity"]) {
            //NSString  *actionUrl = @"VideoCategoryDetailViewController?216209";
            NSString  *actionUrl = model.actionUrl;
            if (actionUrl.length>0) {
                NSArray *array = [actionUrl componentsSeparatedByString:@"?"];
                
                VideoCategory* category = [VideoCategory new];
                if (array.count>1) {
                    NSArray *arrayIN = [array[1] componentsSeparatedByString:@"&"];
                    if (arrayIN.count>2) {
                        category.parentCatgId = arrayIN[0];
                        category.catgName = arrayIN[1];
                        category.index = arrayIN[2];
                    }
                }
                category.action = @"openActivity";
                NSString *vcStr = array[0];
                Class class = NSClassFromString(vcStr);
                UIViewController *VC = [[class alloc]init];
                if ([VC.class isSubclassOfClass:[VideoCategoryDetailViewController class]]) {
                    [self.navigationController pushViewController:[[VideoCategoryDetailViewController alloc] initWithVideoCategory:category] animated:YES];
                }
                else{
                    [self.navigationController pushViewController:VC animated:YES];
                }
            }
        }
    }
}

-(UIView *)topView{
    if (!_topView) {
        _topView = [UIView new];
        _pageVC = [[YFViewPager alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height-64)
                                              titles:@[@"未使用",@"已使用",@"已过期"]
                                               icons:nil
                                       selectedIcons:nil
                                               views:@[self.tableview1,self.tableview2,self.tableview3]];
        _pageVC.backgroundColor = [UIColor blackColor];
        _pageVC.tabSelectedArrowBgColor = kColorBlueTheme;
        _pageVC.tabSelectedTitleColor = RGB(68, 68, 68, 1);
        _pageVC.tabArrowBgColor = RGB(229, 229, 229, 1);
        _pageVC.tabTitleColor = [UIColor blackColor];
        _pageVC.showVLine = NO;
        _pageVC.backgroundColor = [UIColor clearColor];

        //        _topView.backgroundColor= [UIColor clearColor];
        [_topView addSubview:self.pageVC];
        
        WEAKSELF
        [_pageVC didSelectedBlock:^(id viewPager, NSInteger index) {
            
            switch (index) {
                case 0:
                    [weakSelf loadTableView1DataSource];
                    break;
                 case 1:
                    [weakSelf loadTableView2DataSource];
                    break;
                    
                  case 2:
                    [weakSelf loadTableView3DataSource];
                    break;
                default:
                    break;
            }
            
        }];
    }
    return _topView;
}

-(UIView *)noDataView{
    if (!_noDataView) {
        _noDataView = [UIView new];
        
        UIImageView *image = [UIImageView new];
        image.image = [UIImage imageNamed:@"nocoupon"];
        [_noDataView addSubview:image];
        
        UILabel *label = [UILabel new];
        label.text = @"暂无优惠券";
        label.textAlignment = 1;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = RGB(154, 154, 154, 1);
        [_noDataView addSubview:label];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_noDataView);
            make.height.mas_equalTo(74);
            make.width.mas_equalTo(74);
            make.centerX.mas_equalTo(_noDataView);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_noDataView);
            make.height.mas_equalTo(26);
        }];
        
        
    }
    return _noDataView;
}

@end
