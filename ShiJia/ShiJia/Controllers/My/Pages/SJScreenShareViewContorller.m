//
//  SJScreenShareViewContorller.m
//  ShiJia
//
//  Created by 峰 on 16/7/1.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJScreenShareViewContorller.h"
#import "SJScreenShareCell.h"
#import "SJScreenShareCellModel.h"
#import "LocalMediaManager.h"
#import "OMGToast.h"
#import "SJLocalPhotoViewController.h"
#import "SJLocalVideoViewController.h"

typedef NS_ENUM(NSInteger, ScreenType) {
    
    ScreenPicture,

    ScreenVideo,
    
    ScreenTotal
    
};

@interface SJScreenShareViewContorller ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableViewList;
@property (nonatomic, strong) UIView      *footView;
@property (nonatomic, strong) NSArray     *tableTitleArray;

@property (strong, nonatomic) NSMutableArray *assetsSource;
@property (nonatomic) int pictureNumber, videoNumber;

@end

@implementation SJScreenShareViewContorller

#pragma mark -Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文件投屏";
    self.view.backgroundColor = kColorLightGrayBackground;
    
    [self.view addSubview:self.tableViewList];
    
    [self addSubViewsConstraints];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self performSelectorInBackground:@selector(initMediaManager) withObject:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark -load tablelist data

- (void)initMediaManager {
    //初始化本地媒体库，计算图片、音乐、视频数量
    LocalMediaManager *manager = [LocalMediaManager shared];
    __weak LocalMediaManager *managerweak = manager;
    [manager setScanCompleted:^{
        self.pictureNumber = [managerweak getPhotoNumber];
        self.videoNumber   = [managerweak getVideoNumber];
       [self.tableViewList reloadData];
    }];
    
    [manager loadMediaLibrary];

}

- (NSArray *)tableTitleArray{
    if (!_tableTitleArray) {
        
        SJScreenShareCellModel *model1 = [SJScreenShareCellModel new];
        model1.imageName = @"SJScreenCell0";
        model1.title = @"图片投屏";
        
        __weak __typeof(self)weakSelf = self;
        [RACObserve(self, pictureNumber) subscribeNext:^(id x) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
            model1.detailNumber = strongSelf.pictureNumber;
            model1.detailString = [NSString stringWithFormat:@"%d张图片",strongSelf.pictureNumber];
            
        }];

        SJScreenShareCellModel *model2  =[SJScreenShareCellModel new];
        model2.imageName = @"SJScreenCell1";
        model2.title = @"视频投屏";
        [RACObserve(self, videoNumber) subscribeNext:^(id x) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            model2.detailNumber = strongSelf.videoNumber;
            model2.detailString = [NSString stringWithFormat:@"%d个视频",strongSelf.videoNumber];
        }];
        
        NSMutableArray *array = [NSMutableArray arrayWithObjects:model1,model2,nil];
        _tableTitleArray = [array copy];

    }
    return _tableTitleArray;
}

#pragma  mark -tableView  Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tableTitleArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 115.;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SJScreenShareCell *cell = [SJScreenShareCell cellWithTableView:tableView];
    SJScreenShareCellModel *model = self.tableTitleArray[indexPath.row];
    [cell setCellValueWithModel:model];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
       SJScreenShareCellModel *model = self.tableTitleArray[indexPath.row];
    if (model.detailNumber<1) {
        [OMGToast showWithText:@"未找到可用文件"];
        return;
    }
    
    UIViewController    *controller;
    switch (indexPath.row) {
        case ScreenPicture:
             controller = [[SJLocalPhotoViewController alloc]init];
            break;
        case ScreenVideo:
             controller = [[SJLocalVideoViewController alloc]init];
            break;
        default:
            break;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}


#pragma mark -UI & make Constraints

- (UITableView *)tableViewList{
    if (!_tableViewList) {
        
        _tableViewList =[UITableView new];
        _tableViewList.delegate = self;
        _tableViewList.dataSource = self;
        _tableViewList.backgroundColor =[UIColor clearColor];
        _tableViewList.tableFooterView = self.footView;
        _tableViewList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    }
    return _tableViewList;
}


- (UIView *)footView{
    if (!_footView) {
        _footView = [UIView new];
        _footView.size = [UIImage imageNamed:@"SJScreenFoot"].size;
        UIImageView *imageV =[UIImageView new];
      
        imageV.image = [UIImage imageNamed:@"SJScreenFoot"];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
//        [imageV sizeToFit];
        [_footView addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
    }
    return _footView;
}

#pragma mark -Constraints
- (void)addSubViewsConstraints{
    
    [_tableViewList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
        
    }];
}
@end
