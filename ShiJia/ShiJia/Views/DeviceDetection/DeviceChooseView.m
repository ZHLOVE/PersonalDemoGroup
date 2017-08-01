//
//  DeviceChooseView.m
//  HiTV
//
//  Created by 蒋海量 on 15/8/4.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "DeviceChooseView.h"

static CGFloat CloseButtonHeight = 20.0;

@interface DeviceChooseView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *deviceTabView;
@property (nonatomic, strong) IBOutlet UIButton *closeButton;

@end

@implementation DeviceChooseView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    [self addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.deviceTabView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.deviceTabView.delegate = self;
    self.deviceTabView.dataSource = self;
    self.deviceTabView.backgroundColor = [UIColor blackColor];
    self.deviceTabView.alpha = 0.7;
    [self addSubview:self.deviceTabView];
    [self.deviceTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.height.mas_equalTo(0);
    }];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setImage:[UIImage imageNamed:@"大叉-720.png"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deviceTabView.mas_right).with.offset(-10);
        make.top.equalTo(self.deviceTabView.mas_top).with.offset(-10);
        make.width.mas_equalTo(CloseButtonHeight);
        make.height.mas_equalTo(CloseButtonHeight);
    }];
    
    [self setExtraCellLineHidden:self.deviceTabView];
    self.deviceTabView.layer.masksToBounds = YES;
    self.deviceTabView.layer.borderWidth = 0.5;
    self.deviceTabView.layer.borderColor = [RGB(90, 121, 156, 1) CGColor];
    
}
-(void)refreshData{
    [self.deviceTabView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.height.mas_equalTo(184);
    }];
    [self.deviceTabView reloadData];
}
-(IBAction)closeView:(id)sender{
    [self removeFromSuperview];
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deviceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.accessoryView = nil;
    
    NSInteger row = indexPath.row;
    NSObject *object = self.deviceList[row];
    if ([object isKindOfClass:[HiTVDeviceInfo class]]) {
        HiTVDeviceInfo *entity = self.deviceList[row];
        cell.textLabel.text = entity.tvName;
    }
    else if([object isKindOfClass:[ScreenDeviceInfo class]]){
        ScreenDeviceInfo *entity = self.deviceList[row];
        cell.textLabel.text = entity.tvName;
    }
   
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSInteger row = indexPath.row;
    NSObject *object = self.deviceList[row];
    if (self.m_delegate) {
        if ([object isKindOfClass:[HiTVDeviceInfo class]]) {
            [self.m_delegate connectDevice:self.deviceList[row]];
        }
        else if([object isKindOfClass:[ScreenDeviceInfo class]]){
            [self.m_delegate connectScreenDevice:self.deviceList[row]];
        }
        
    }
}
@end
