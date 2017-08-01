//
//  SJVideoSeriesTableView.m
//  ShiJia
//
//  Created by 蒋海量 on 16/7/19.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJVideoSeriesTableView.h"
#import "TVProgram.h"
#import "VideoSource.h"
#import "WatchFocusVideoProgramEntity.h"
#import "CustomView.h"
#import "SJVideoSeriesTableViewCell.h"

static CGFloat kLineImgWidth = 10.0;
static CGFloat kLineImgHeight = 16.0;
static CGFloat kLineImgOriginx = 10.0;
static CGFloat kLabelHeight = 20.0;
static CGFloat kLeftSpacing = 10.0;

@interface SJVideoSeriesTableView ()
{
    // NSIndexPath *currentIndexPath;
}
@property (nonatomic, strong) UIImageView *lineImgView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic) BOOL full;
@property (nonatomic, assign) NSInteger showCurrentIndex;
@end

@implementation SJVideoSeriesTableView

- (instancetype)init{

    self = [super init];

    if (self) {
        _lineImgView = [[UIImageView alloc] init];
        //_lineImgView.backgroundColor = kColorBlueTheme;
        _lineImgView.image = [UIImage imageNamed:@"Triangle"];
        [self addSubview:_lineImgView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = @"剧集";
        [self addSubview:_titleLabel];

        _tabView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tabView.backgroundColor = [UIColor whiteColor];
        _tabView.dataSource = self;
        _tabView.delegate = self;
        _tabView.separatorColor = kColorLightGrayBackground;
        _tabView.scrollEnabled = NO;
        [self setExtraCellLineHidden:_tabView];
        [self addSubview:_tabView];

        self.currentIndexPath =  [NSIndexPath indexPathForRow:0 inSection:0];;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (self.full) {
//        _line.frame = CGRectMake(10, 12, 2, 16);
//        _titleLabel.frame = CGRectMake(20, 10, W-10, 20);
        
        _lineImgView.frame = CGRectMake(kLineImgOriginx,
                                        kLeftSpacing + (kLabelHeight - kLineImgHeight) / 2.0,
                                        kLineImgWidth, kLineImgHeight);
        
        _titleLabel.frame = CGRectMake(_lineImgView.frame.origin.x + kLineImgWidth +
                                       kLeftSpacing,
                                       kLeftSpacing, self.frame.size.width - kLeftSpacing * 2, kLabelHeight);
        _tabView.frame = CGRectMake(10, _titleLabel.frame.origin.y * 2 + _titleLabel.frame.size.height+15, W-20, self.contentView.height-60);
    }
    else{
//        _lineImgView.frame = CGRectMake(0, 12, 2, 16);
//        _titleLabel.frame = CGRectMake(10, 10, W-10, 20);
        _lineImgView.frame = CGRectMake(0,
                                        kLeftSpacing + (kLabelHeight - kLineImgHeight) / 2.0,
                                        kLineImgWidth, kLineImgHeight);
        
        _titleLabel.frame = CGRectMake(_lineImgView.frame.origin.x + kLineImgWidth +
                                       kLeftSpacing,
                                       kLeftSpacing, self.frame.size.width - kLeftSpacing * 2, kLabelHeight);
        float h = _list.count*44;
        if (h>186) {
            h = 186;
        }
        _tabView.frame = CGRectMake(0, _titleLabel.frame.origin.y * 2 + _titleLabel.frame.size.height, self.frame.size.width, h);
    }
}

-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = klightGrayColor;
        _contentView.frame = CGRectMake(0, H, W, 420);
        _contentView.userInteractionEnabled = YES;

        [self.window insertSubview:_contentView atIndex:1];

        UIView *headView = [[UIView alloc]init];
        headView.frame = CGRectMake(0, 0, W, 40);
        headView.backgroundColor = [UIColor whiteColor];

        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.backgroundColor = [UIColor clearColor];
        closeBtn.frame = CGRectMake(W-40, 11, 18, 18);
        [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(hiddenFullView) forControlEvents:UIControlEventTouchUpInside];


        UILabel *_titleLabel1 = [[UILabel alloc] init];
        _titleLabel1.backgroundColor = [UIColor clearColor];
        _titleLabel1.font = [UIFont systemFontOfSize:15.0];
        _titleLabel1.textColor = [UIColor blackColor];
        _titleLabel1.text = @"选集";

        [_contentView addSubview:headView];
        [_contentView addSubview:_lineImgView];
        [_contentView addSubview:_titleLabel1];
        [_contentView addSubview:closeBtn];
        [_contentView addSubview:_tabView];

    }
    return _contentView;
}
#pragma mark - Table view data source
-(void)setExtraCellLineHidden: (UITableView *)tableView{

    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.full) {
        return 1;
    }else{
        if (self.list.count>3) {
            return 2;
        }
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.full) {
        return self.list.count;
    }else{
        if (section == 0) {
            if (self.list.count>3) {
                return 3;
            }
            return self.list.count;
        }
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 10.0;
}

-(UIView *)seperateViewWithHeight:(float)height{
    UIView *view =  [[UIView alloc] initWithFrame:CGRectMake(0, height-0.5,W, 0.5)];
    view.backgroundColor = [UIColor colorWithRed:209/255.0 green:210/255.0 blue:211/255.0 alpha:1];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";

    SJVideoSeriesTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SJVideoSeriesTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == 0) {
        id video = self.list [row];
        cell.model = video;
        if ([video isKindOfClass:[TVProgram class]]) {
            TVProgram *program = video;
            cell.textLabel.text = [NSString stringWithFormat:@"%@     %@",program.displayedFullStartTime,program.programName];
        }
        else if([video isKindOfClass:[VideoSource class]]){
            VideoSource *program = video;
            cell.textLabel.text = [NSString stringWithFormat:@"%@",program.name];
        }
        else{
            WatchFocusVideoProgramEntity *program = video;
            cell.textLabel.text = [NSString stringWithFormat:@"%@",program.programName];
        }
        if (self.currentIndexPath.row == indexPath.row) {
            cell.textLabel.textColor = kColorBlueTheme;
        }
        else{
            cell.textLabel.textColor = [UIColor darkGrayColor];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }else{
        cell.textLabel.text = @"查看更多";
        cell.textLabel.textColor = kColorBlueTheme;
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }

    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.didSelectItemAtIndex) {
            self.didSelectItemAtIndex(indexPath.row);
            if (_full) {
                _showCurrentIndex = indexPath.row;
            }
            self.currentIndexPath = indexPath;
            [_tabView reloadData];
            [self hiddenFullView];
        }
    }
    else{
        [self showFullView];
    }
}

-(void)showFullView{
    self.full = YES;
    [self addControl:self.contentView];

    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.3f];

    //[self setFrame:CGRectMake(10, H-400, W-20, 400)];
    _contentView.frame = CGRectMake(0, self.playH+20, W, H-self.playH-20);

    [UIView commitAnimations];
    _tabView.scrollEnabled = YES;
    [_tabView reloadData];

}
-(void)hiddenFullView{
    self.full = NO;
    [self addControl:self];
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.3f];
    _contentView.frame = CGRectMake(0, H, W, 420);
    [UIView commitAnimations];
    _tabView.scrollEnabled = NO;
    [_tabView reloadData];
}
-(void)addControl:(UIView *)view{
    [_lineImgView removeFromSuperview];
    [_titleLabel removeFromSuperview];
    [_tabView removeFromSuperview];
    [_contentView removeFromSuperview];

    [view addSubview:_lineImgView];
    [view addSubview:_titleLabel];
    [view addSubview:_tabView];
    [self.window insertSubview:_contentView atIndex:1];
}

- (void)setList:(NSArray *)list
{
    _list = list;
    [_tabView reloadData];
}

- (void)setCurrentVideoIndex:(NSInteger)currentVideoIndex
{
    if (_currentVideoIndex != currentVideoIndex) {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:_currentVideoIndex inSection:0];
        UITableViewCell *lastCell = [_tabView cellForRowAtIndexPath:lastIndexPath];

        lastCell.textLabel.textColor = [UIColor darkGrayColor];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentVideoIndex inSection:0];

        UITableViewCell *cell = [_tabView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = kColorBlueTheme;
        self.currentIndexPath = indexPath;
    }
    _currentVideoIndex = currentVideoIndex;
    
}
@end
