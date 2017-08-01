//
//  PopoverView.m
//  HiTV
//
//  Created by yy on 15/9/9.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "PopoverView.h"
#import "PopoverViewTableViewCell.h"
#import "HiTVDeviceInfo.h"

#define Screen_Width  CGRectGetWidth([[UIScreen mainScreen] applicationFrame])
#define TableViewWidth Screen_Width*2/3.0
#define Navigation_Bar_Height ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0 ? 64 : 44)



@interface PopoverView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) UITableView *table;
@property (nonatomic, retain) UIView *baseView;
@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, retain) UIButton *bottomButton;
@property (nonatomic, assign) NSInteger selectedRow;

@end

@implementation PopoverView

#pragma mark - view
- (id)initWithItems:(NSArray *)items
{
    self = [super init];
    
    if (self)
    {
        //init data
        self.list = [NSArray arrayWithArray:items];
        self.selectedRow = 0;
        
        //init subviews
        [self setupSubviews];
    }
    
    return self;
}

#pragma mark - subviews
- (void)setupSubviews
{
    
    
    //背景透明关闭按钮
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.backgroundColor = [UIColor clearColor];
    [self.backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //半透明黑色按钮
    self.bottomButton = [[UIButton alloc] init];
//    [self.bottomButton setAlpha:0.5];
    [self.bottomButton setBackgroundColor:[UIColor clearColor]];
    [self.bottomButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.bottomButton];
    [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.top.equalTo(self).with.offset(Navigation_Bar_Height);
        make.bottom.equalTo(self).with.offset(0);
    }];
    
    //选项列表试图
    self.baseView = [[UIView alloc] init];
    self.baseView.clipsToBounds = YES;
    self.baseView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.baseView];
    [self.baseView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
    }];
    
    //选项列表
    self.table = [[UITableView alloc] init];
    self.table.backgroundColor = [UIColor clearColor];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.table.layer setBorderWidth:0.5];
    [self.baseView addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.baseView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
//    [self.baseView setBackgroundColor:[UIColor whiteColor]];
//    [self.table setBackgroundColor:[UIColor whiteColor]];
//    [self setBackgroundColor:[UIColor clearColor]];
    
    //register cell
    UINib *nib = [UINib nibWithNibName:@"PopoverViewTableViewCell" bundle:nil];
    [self.table registerNib:nib forCellReuseIdentifier:@"PopoverViewTableViewCell"];
}

#pragma mark - button click
- (void)backButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(hidePopoverView)]) {
        [self.delegate hidePopoverView];
    }
    [self hidePopoverView];
}

#pragma mark - show & hide
- (void)showPopoverView
{
    [self removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.superview).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    PopoverViewTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PopoverViewTableViewCell" owner:self options:nil] lastObject];
    [self.baseView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.list.count * cell.frame.size.height);
        make.top.equalTo(self).with.offset(self.originY);
    }];
    [self.bottomButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(self.originY);
    }];
    [self.table reloadData];
    [self.bottomButton setAlpha:0.5];

}

- (void)hidePopoverView
{
    [UIView animateWithDuration:0.2 animations:^{
        [self.baseView setFrame:CGRectMake(0, self.baseView.frame.origin.y, Screen_Width, 0)];
        [self.bottomButton setAlpha:0.0];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - property
- (void)setList:(NSArray *)list
{
    _list = list;
    [self.table reloadData];
}

- (void)setSelectedDevice:(HiTVDeviceInfo *)selectedDevice
{
    _selectedDevice = selectedDevice;
    
    for (HiTVDeviceInfo *data in self.list) {
        NSString *uid = data.ownerUid;
        NSString *connectUid = self.selectedDevice.ownerUid;
        
        if (!data.ownerUid) {
            uid = data.userId;
            connectUid = self.selectedDevice.userId;
        }
        if ([uid isEqualToString:connectUid]) {
            self.selectedRow = [self.list indexOfObject:data];
            break;
        }
    }
    if (selectedDevice) {
        _selectState = PopoverViewSelectState_Custom;
        [self.table reloadData];
    }
}

- (void)setOriginY:(CGFloat)originY
{
    _originY = originY;
    
}

- (void)setSelectState:(PopoverViewSelectState)selectState
{
    _selectState = selectState;
    [self.table reloadData];
}

#pragma mark - table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].contentView.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"PopoverViewTableViewCell";
    
    PopoverViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    HiTVDeviceInfo *data = self.list[indexPath.row];

    NSMutableDictionary *deviceDic = [NSUserDefaultsManager getObjectForKey:DEVICESDIC];
    NSString *tvName = [deviceDic objectForKey:data.userId];
    if (tvName) {
        cell.titleLabel.text = tvName;
    }
    else{
        cell.titleLabel.text = data.tvName;
    }
    //cell.titleLabel.text = data.tvName;
    
    if (self.selectState == PopoverViewSelectState_SelectNone) {
    
        cell.checked = NO;
    }
    else if (self.selectState == PopoverViewSelectState_SelectAll){
        cell.checked = YES;
    }
    else{
        if (self.selectedRow == indexPath.row)
        {
            cell.checked = YES;
        }
        else
        {
            cell.checked = NO;
        }
    }
    //判断关联家庭下没有电视或者电视没有登录
    if (!([data.state isEqualToString:@"UNTOGETHER_ONLINE"]||[data.state isEqualToString:@"UNTOGETHER_OFFLINE"]||data.state==nil)) {
        cell.titleLabel.textColor = [UIColor blackColor];
    }
    else{
        cell.titleLabel.textColor = [UIColor lightGrayColor];
    }
    //设置分割线隐藏/显示
    if (indexPath.row == self.list.count-1) {
        cell.lineImgView.hidden = YES;
    }
    else{
        cell.lineImgView.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HiTVDeviceInfo *data = self.list[indexPath.row];
    //判断关联家庭下没有电视或者电视没有登录
    if (!([data.state isEqualToString:@"UNTOGETHER_ONLINE"]||[data.state isEqualToString:@"UNTOGETHER_OFFLINE"]||data.state==nil)) {
        self.selectedRow = indexPath.row;
        PopoverViewTableViewCell *cell = (PopoverViewTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.checked = YES;
        [tableView reloadData];
        if ([self.delegate respondsToSelector:@selector(popoverView:didSelectCellAtIndex:)]) {
            [self.delegate popoverView:self didSelectCellAtIndex:indexPath.row];
        }    }
}

@end

