//
//  SJDLNAListViews.m
//  ShiJia
//
//  Created by 峰 on 2017/3/14.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "SJDLNAListViews.h"
#import "PopoverViewTableViewCell.h"
#import "mgServer.h"
#import "DLNADevice.h"
#import "TogetherManager.h"
#define title1 @"暂无关联设备"
#define title2 @"请前往我的家庭电视，用扫一扫功能关联和家庭家庭电视"
#define title3 @"附近无其他可用设备"
#define headtitle1 @"默认家庭电视"
#define headtitle2 @"附近其他设备"

@interface SJDLNAListViews ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIControl    *controlView;
@property (nonatomic, strong) UITableView  *devicesTableView;
@property (nonatomic, strong) NSMutableArray <DLNADevice *>*DataSource1;
@property (nonatomic, strong) NSMutableArray <DLNADevice *>*DataSource2;
@property (nonatomic, strong) NSMutableArray <DLNADevice *>*tempData;
@property (nonatomic, strong) UIView       *EmptyView1;
@property (nonatomic, strong) UIView       *EmptyView2;
@property (nonatomic, strong) UIView       *headV1;
@property (nonatomic, strong) UIView       *headV2;
@property (nonatomic, strong) UIButton     *cancelButton;
@property (nonatomic, assign) BOOL loaDLNADevices;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end


@implementation SJDLNAListViews
/**
 *  @brie 自己TV
 */
-(NSMutableArray<DLNADevice *> *)DataSource1{
    if (!_DataSource1) {
        _DataSource1 = [NSMutableArray new];
        HiTVDeviceInfo *deviced=[TogetherManager sharedInstance].connectedDevice;
        if (deviced) {
            DLNADevice *model = [DLNADevice new];
            model.name = deviced.tvName;
            [_DataSource1 addObject:model];
        }

    }
    return _DataSource1;
}
/**
 *  @brie 别人家TV
 */
-(NSMutableArray<DLNADevice *> *)DataSource2{
    if (!_DataSource2) {
        _DataSource2 = [NSMutableArray new];
    }
    return _DataSource2;
}
-(NSMutableArray<DLNADevice *> *)tempData{
    if (!_tempData) {
        _tempData = [NSMutableArray new];
    }
    return _tempData;
}

-(UIView *)EmptyView1{
    if (!_EmptyView1) {
        _EmptyView1 = [UIView new];
        UILabel *label1 = [UILabel new];
        label1.text = title1;
        label1.textColor = kColorLightGray;
        label1.textAlignment = 1;
        label1.font = [UIFont systemFontOfSize:17];

        UILabel *label2 = [UILabel new];
        label2.text = title2;
        label2.textAlignment = 1;
        label2.textColor = kColorLightGray;
        label2.font = [UIFont systemFontOfSize:15];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"点击前往" forState:UIControlStateNormal];
        button.tag = 1;
        button.layer.cornerRadius =18.5;
        button.backgroundColor = kColorBlueTheme;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

        [_EmptyView1 addSubview:label1];
        [_EmptyView1 addSubview:label2];
        [_EmptyView1 addSubview:button];

        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_EmptyView1);
            make.height.mas_equalTo(15);
            make.top.mas_equalTo(_EmptyView1).offset(20);
        }];

        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_EmptyView1);
            make.height.mas_equalTo(12);
            make.top.mas_equalTo(label1.mas_bottom).offset(20);
        }];

        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_EmptyView1);
            make.size.mas_equalTo(CGSizeMake(135, 37));
            make.top.mas_equalTo(label2.mas_bottom).offset(20);
        }];
    }
    return _EmptyView1;
}

-(UIView *)EmptyView2{
    if (!_EmptyView2) {
        _EmptyView2 = [UIView new];
        UILabel *label1 = [UILabel new];
        label1.text = title3;
        label1.textColor = kColorLightGray;
        label1.textAlignment = 1;
        label1.font = [UIFont systemFontOfSize:17];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"搜索" forState:UIControlStateNormal];
        button.tag = 2;
        button.layer.cornerRadius =18.5;
        button.backgroundColor = kColorBlueTheme;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

        [_EmptyView2 addSubview:label1];
        [_EmptyView2 addSubview:button];

        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_EmptyView2);
            make.height.mas_equalTo(15);
            make.top.mas_equalTo(_EmptyView2).offset(20);
        }];

        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_EmptyView2);
            make.size.mas_equalTo(CGSizeMake(135, 37));
            make.top.mas_equalTo(label1.mas_bottom).offset(20);
        }];

    }
    return _EmptyView2;
}

-(UIView *)loadView{

    UIView *loadView = [UIView new];
    if (!_activityView) {
     _activityView=[UIActivityIndicatorView new];
    }
    _activityView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [loadView addSubview:_activityView];
    _activityView.hidesWhenStopped=YES;
    [_activityView startAnimating];
    [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(loadView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    return loadView;
}


-(UIView *)headV1{
    if (!_headV1) {
        _headV1 = [UIView new];
        _headV1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        _headV1.backgroundColor =[UIColor whiteColor];

        UIView *line = [UIView new];
        line.backgroundColor = kColorBlueTheme;

        UILabel *label = [UILabel new];
        label.text = headtitle1;
        //        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        label.font =[UIFont systemFontOfSize:17];
        label.textColor = [UIColor blackColor];

        UIView *line2 = [UIView new];
        line2.backgroundColor = kColorLightGray;

        [_headV1 addSubview:line];
        [_headV1 addSubview:label];
        [_headV1 addSubview:line2];

        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headV1).offset(20);
            make.top.mas_equalTo(_headV1).offset(20);
            make.size.mas_equalTo(CGSizeMake(2, 18));
        }];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(line.mas_right).offset(7);
            make.centerY.mas_equalTo(line);
        }];

        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(_headV1);
            make.height.mas_equalTo(.5);
        }];

    }
    return _headV1;
}
-(UIView *)headV2{
    if (!_headV2) {
        _headV2 = [UIView new];
        _headV2.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        _headV2.backgroundColor =[UIColor whiteColor];
        UILabel *label = [UILabel new];
        label.text = headtitle2;
        label.font =[UIFont systemFontOfSize:17];
        //        label.textColor = RGB(68, 68, 68, 1);
        label.textColor = [UIColor blackColor];

        UIView *line2 = [UIView new];
        line2.backgroundColor = kColorLightGray;

        [_headV2 addSubview:label];
        [_headV2 addSubview:line2];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headV2).offset(20);
            make.top.mas_equalTo(_headV2).offset(20);
        }];

        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(_headV2);
            make.height.mas_equalTo(.5);
        }];
    }
    return _headV2;
}


-(UITableView *)devicesTableView{
    if (!_devicesTableView) {
        _devicesTableView = [UITableView new];
        _devicesTableView.dataSource = self;
        _devicesTableView.delegate = self;
        _devicesTableView.tableFooterView = [UIView new];
        _devicesTableView.backgroundColor =[UIColor whiteColor];
    }
    return _devicesTableView;
}

-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton =[UIButton new];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        [_cancelButton setTitleColor:RGB(68, 68, 68, 1) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(HiddenDLNAListView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
-(void)addSubViewsConstraints{

    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(50);
    }];
    [_devicesTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.bottom.mas_equalTo(_cancelButton.mas_top).offset(-10);
    }];
}
#pragma mark DataSource $ Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return section==0?self.headV1:self.headV2;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    if (section==0) {
        return self.EmptyView1;
    }else{
        return _loaDLNADevices?[self loadView]:self.EmptyView2;
    }

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.DataSource1.count==0&&section==0) {
        return 135.;
    }
    if (self.DataSource2.count==0&&section==1) {
        return 100;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section==0?_DataSource1.count:_DataSource2.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    DLNADevice *cellmodel;
    if (indexPath.section==0) {
        cellmodel = _DataSource1[indexPath.row];
    }else{
        cellmodel = _DataSource2[indexPath.row];
    }
    cell.textLabel.text = cellmodel.name;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
        if ([self.delegate respondsToSelector:@selector(DLNAViewScreenActionWithType:)]) {
            [self.delegate DLNAViewScreenActionWithType:0];
        }
    }else{
        DLNADevice *model = _DataSource2[indexPath.row];
        //[mgServer broadcast2Tv:model.uuid :_currentVideoURL];
        if ([self.delegate respondsToSelector:@selector(DLNAViewScreenActionWithType:)]) {
            [self.delegate DLNAViewScreenActionWithType:1];
        }
    }
    [self HiddenDLNAListView];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidden = YES;

        _controlView=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _controlView.backgroundColor=RGB(0, 0, 0, 0.3);
        [_controlView addTarget:self action:@selector(HiddenDLNAListView) forControlEvents:UIControlEventTouchUpInside];
        _controlView.alpha=1;
        self.backgroundColor = RGB(168, 168, 168, 1);

        [self addSubview:self.cancelButton];
        [self addSubview:self.devicesTableView];
        [self addSubViewsConstraints];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(refreshTableData:)
                                                    name:kNotification_dlnaDevicesCallbackImp
                                                  object:nil];
    }
    return self;
}

-(void)refreshTableData:(NSNotification *)notify{

    DLNADevice *decive = [DLNADevice new];
    decive.name = notify.object[@"deviceName"];
    decive.uuid = notify.object[@"uuid"];
    decive.isOffline = notify.object[@"isOffline"];
    [self.tempData addObject:decive];

}


-(void)ShowDLNAListViewsIn:(UIView *)superView{
    if (self.isHidden) {
        self.hidden = NO;
        if (_controlView.superview==nil) {
            [superView addSubview:_controlView];
        }
        [UIView animateWithDuration:0.2 animations:^{
            _controlView.alpha=1;
        }];
        CATransition *animation = [CATransition  animation];
        animation.duration = 0.2f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype =kCATransitionFromTop;
        [self.layer addAnimation:animation forKey:@"animation1"];
        self.frame = CGRectMake(0,60+9*SCREEN_WIDTH/16, SCREEN_WIDTH,SCREEN_HEIGHT-9*SCREEN_WIDTH/16-60);
        [superView addSubview:self];
        //[mgServer startDlna];
        self.loaDLNADevices = YES;
        if (_devicesTableView) {
            [_devicesTableView reloadData];
        }
        [self performSelector:@selector(reloadDeviceData) afterDelay:3];

    }
}

-(void)reloadDeviceData{

    [_activityView stopAnimating];
    NSSet *set = [NSSet setWithArray:_tempData];
    self.DataSource2 = [[set allObjects] mutableCopy];
    if (_DataSource2.count>0) {
        self.loaDLNADevices = YES;
    }else{
        self.loaDLNADevices = NO;
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [_devicesTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)HiddenDLNAListView{
    if (!self.isHidden) {
        self.hidden = YES;
        [self.DataSource2 removeAllObjects];

        CATransition *animation = [CATransition  animation];
        animation.duration = 0.2f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromBottom;
        [self.layer addAnimation:animation forKey:@"animtion2"];
        [UIView animateWithDuration:0.2 animations:^{
            _controlView.alpha=0;
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

-(void)buttonAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    if (button.tag==1) {
        [self HiddenDLNAListView];
        if ([self.delegate respondsToSelector:@selector(DLNAViewButtonClickWithIndex:)]) {
            [self.delegate DLNAViewButtonClickWithIndex:button.tag];
        }
    }else{
        self.loaDLNADevices = YES;
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [_devicesTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
       // [mgServer startDlna];
        [self performSelector:@selector(reloadDeviceData) afterDelay:3];
    }
}

@end
