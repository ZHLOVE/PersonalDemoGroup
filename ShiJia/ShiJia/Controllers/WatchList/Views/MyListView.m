//
//  MyListView.m
//  ShiJia
//
//  Created by 蒋海量 on 2017/3/13.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "MyListView.h"
#import "JRWaterFallLayout.h"
#import "MyListCollectionViewCell.h"
#import "MyListTableViewCell.h"

#define CellHeight   240
#define HeaderHeight 55.
#define RowHeight    157.
#define tipsHeight   31
#define tipsWidth    201

static NSString* const KWatchListMyCollectionViewCellID = @"MyListCollectionViewCell";


@interface MyListView ()<WatchListCollectionViewCellDelegate,MyListCollectionViewCellDelegate,JRWaterFallLayoutDelegate,MyListDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource>

{
        JRWaterFallLayout *layout;
        float height;
        
}
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray          *myWatchListArray;
@property (strong, nonatomic) UIView           *userInfoView;
@property (strong, nonatomic) UIImageView      *headImg;
@property (strong, nonatomic) UILabel          *titleLab;
@property (nonatomic, strong) UIView           *noDataView;
@property (nonatomic, strong) UILabel          *tipLab;
@property (strong, nonatomic) UIView           *defaultView;
//新设计北京风格UI
@property (nonatomic, strong) UITableView      *myListTableView;

@end


@implementation MyListView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(p_refreshAfterUserLogin)
                                                     name:TPIMNotification_ReloadUser
                                                   object:nil];
    
        
        self.backgroundColor = [UIColor clearColor];
        height = CellHeight;
        
        //self.tipLab.hidden = NO;

        //[self addSubview:self.collectionView];

        //[self.collectionView.mj_header beginRefreshing];
        
        [self addSubViewsAndViewConstraints];
        
        //[self.myListTableView.mj_header beginRefreshing];
        [self loadWatchListRequest];

    }
    return self;
}
-(void)p_refreshAfterUserLogin{
    //_titleLab.text = [NSString stringWithFormat:@"亲爱的%@",[HiTVGlobals sharedInstance].nickName];
   // [self.collectionView.mj_header beginRefreshing];
     [self.myListTableView.mj_header beginRefreshing];
}
- (void)layoutSubviews
{
        [super layoutSubviews];
        
        _collectionView.frame = CGRectMake(0, 30, self.bounds.size.width, self.bounds.size.height-30);
        
}
#pragma mark UI
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        // 创建瀑布流layout
        layout = [[JRWaterFallLayout alloc] init];
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = YES;
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerNib:[UINib nibWithNibName:KWatchListMyCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:KWatchListMyCollectionViewCellID];
        
        
        WEAKSELF
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            layout.JRDefaultColumnCount = 2;
            [weakSelf loadWatchListRequest];
        }];
    }
    return _collectionView;
}
#pragma mark - 刷新数据
- (void)p_reloadData {

    [self.myListTableView.mj_header beginRefreshing];
}
- (BOOL)p_isLoggedIn {
    
    return YES;
}
-(void)loadSuccesStatus{
    self.userInfoView.hidden = NO;
    
}
-(void)loadFailStatus{
    self.userInfoView.hidden = YES;
    
}
- (NSString*)p_currentUID {
    if ([HiTVGlobals sharedInstance].isLogin) {
        if (![HiTVGlobals sharedInstance].uid) {
            return @"";
        }
        return [HiTVGlobals sharedInstance].uid;
        
    }else{
        if (![HiTVGlobals sharedInstance].anonymousUid) {
            return @"";
        }
        return [HiTVGlobals sharedInstance].anonymousUid;
    }
}
-(void)loadTimeCenter{
    
    for (int row = 0;row<self.myWatchListArray.count;row++) {
        WatchListEntity *entity = self.myWatchListArray[row];
        UIImageView *pointImg = [[UIImageView alloc]init];
        if (/*[entity.contentType isEqualToString:@"live"]&&*/[self live:entity]) {
            pointImg.image = [UIImage imageNamed:@"直播中圆点"];
        }
        else{
            pointImg.image = [UIImage imageNamed:@"普通圆点"];
        }
        pointImg.tag = 1;
        [self.collectionView addSubview:pointImg];
        
        UIImageView *line = [[UIImageView alloc]init];
        line.backgroundColor = RGB(204, 204, 204, 1);
        line.tag = 1;
        [self.collectionView addSubview:line];
        
        UILabel *timeLab = [[UILabel alloc]init];
        timeLab.backgroundColor = [UIColor clearColor];
        timeLab.textColor = [UIColor darkGrayColor];
        timeLab.font = [UIFont systemFontOfSize:12];
        if ([entity.contentType isEqualToString:@"vod"]) {
            timeLab.text = entity.hour;
        }
        else{
            timeLab.text = entity.duration;
        }
        timeLab.tag = 1;
        [self.collectionView addSubview:timeLab];
        
        
        if (row %2==1) {
            line.frame = CGRectMake(W/2-1,row/2*(height+30)+height/2+40,1,height/2-5);
            timeLab.textAlignment = NSTextAlignmentLeft;
            timeLab.frame = CGRectMake(W/2+10,row/2*(height+30)+height/2+40-20,W/2-20,20);
            pointImg.frame = CGRectMake(W/2-5.5,row/2*(height+30)+height/2+40-15,11,11);
            
        }
        else{
            line.frame = CGRectMake(W/2-1,row/2*(height+30)+20,1,height/2-5);
            timeLab.textAlignment = NSTextAlignmentRight;
            timeLab.frame = CGRectMake(10,row/2*(height+30)+20-20,W/2-20,20);
            pointImg.frame = CGRectMake(W/2-5.5,row/2*(height+30)+20-15,11,11);
        }
        
    }
}
-(BOOL)live:(WatchListEntity *)entity{
    NSString *stamp = [Utils nowTimeString];
    long long date = [stamp longLongValue];
    if (date >=entity.startTime && date <= entity.endTime) {
        return YES;
    }
    return NO;
}
#pragma mark - <JRWaterFallLayoutDelegate>
    /**
     *  返回每个item的高度
     */
- (CGFloat)waterFallLayout:(JRWaterFallLayout *)waterFallLayout heightForItemAtIndex:(NSUInteger)index width:(CGFloat)width
{
        return height;

}
#pragma mark - UICollectionView Datasource
    
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (self.myWatchListArray.count==0) {
        self.userInfoView.hidden = YES;
        
    }else{
        self.userInfoView.hidden = NO;
    }
    return self.myWatchListArray.count;
}
    
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
    
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WatchListEntity* entity = self.myWatchListArray[indexPath.row];
    MyListCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:KWatchListMyCollectionViewCellID forIndexPath:indexPath];
    cell.layer.cornerRadius = 3;
    cell.m_delegate = self;
    cell.delegate = self;
    
    cell.entity = entity;
    // cell.currentUserID = [self p_currentUID];
    // [cell updateServerTime:[self serverTime]];
    cell.deleteBtn.hidden = YES;
    cell.deleteBgBtn.hidden = YES;
    /*NSInteger row = indexPath.row;
    if (row %2==1) {
        //cell.frame = CGRectMake(W/2+10,row/2*(CellHeight+30)+CellHeight/2+35,W/2-20,CellHeight) ;
        cell.liveLab.frame = CGRectMake(0,10,44,18);
        
    }
    else{
        //cell.frame = CGRectMake(10,row/2*(CellHeight+30)+20,W/2-20,CellHeight) ;
        cell.liveLab.frame = CGRectMake(cell.frame.size.width-44,10,44,18);
        
    }*/
    return cell;
}
    
    
    
#pragma mark - UICollectionViewDelegate (GODETAIL 看单)
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
    {
        WatchListEntity* content = nil;
        MyListCollectionViewCell* newCell = (MyListCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (!newCell.deleteBtn.hidden) {
            newCell.deleteBtn.hidden = YES;
            newCell.deleteBgBtn.hidden = YES;
            return;
        }
        content = self.myWatchListArray[indexPath.row];
#if 0
        NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];

        [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
        //end
        [parameters setValue:content.contentType forKey:@"businessType"];
        [parameters setValue:content.contentId forKey:@"objectId"];
        [parameters setValue:@"0" forKey:@"startTime"];
        [parameters setValue:@"0" forKey:@"endTime"];
        [parameters setValue:@"MOBILE" forKey:@"deviceType"];
        
        
        [BaseAFHTTPManager postRequestOperationForHost:WXSEEN forParam:@"/integration/2.0/querySingleHistory" forParameters:parameters  completion:^(id responseObject) {
            if (self.m_delegate) {
                [self.m_delegate goDetailVC:content];
            }
        } failure:^(NSString *error) {
            if (self.m_delegate) {
                [self.m_delegate goDetailVC:content];
            }
        }];
#endif
        if (self.m_delegate) {
            [self.m_delegate goDetailVC:content];
        }
        
        
}
    
#pragma mark – UICollectionViewDelegateFlowLayout
    
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.myWatchListArray.count%2==0) {
        if (indexPath.row==self.myWatchListArray.count-1) {
            return CGSizeMake(W/2-20,height*1.5+20);
        }
    }
    
    return CGSizeMake(W/2-20,height);
}
    
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
    {
        return CGSizeZero;
    }
    
    
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
    
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}
    
- (CGFloat)collectionView:(UICollectionView * )collectionView
                   layout:(UICollectionViewLayout * )collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 30;
}
#pragma mark - MyListCollectionViewCellDelegate
-(void)refrashMyList{
    //[self.collectionView.mj_header beginRefreshing];
    [self.myListTableView.mj_header beginRefreshing];
    
}

#pragma mark - 我的看单
-(void)loadWatchListRequest{
    __weak typeof(self) this = self;
    NSString* url = [NSString stringWithFormat:@"%@personal/getPersonalList",
                     MYEPG];
    /*1,
     (int)this.limitNum];*/
    NSDictionary *param = @{
                            @"userId" : [this p_currentUID],
                            //@"tvTemplateId" : WATCHTVGROUPID,
                            //@"vodTemplateId" : [[HiTVGlobals sharedInstance]getEpg_groupId],
                            @"abilityString" :  T_STBext,
                            //@"limitNum" : @"0",
                            };
    DDLogInfo(@"url: %@", url);
    [BaseAFHTTPManager postRequestOperationForHost:url
                                         forParam:@""
                                    forParameters:param
                                       completion:^(id responseObject) {
                                           
        self.defaultView.hidden = YES;
        if (!this) {
            return;
        }
        this.myWatchListArray =nil;
        NSMutableArray *resultArray = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"resultList"]) {
            WatchListEntity* entity = [[WatchListEntity alloc]initWithDictionary:dic];
            [resultArray addObject:entity];
            
        }
        if ([responseObject[@"promptType"] intValue] == 1) {
            _headImg.image = [UIImage imageNamed:@"prompt1.png"];//prompt1
        }
        else{
            _headImg.image = [UIImage imageNamed:@"Group7.png"];//prompt1
        }
        
        this.myWatchListArray = resultArray;
        if (this.myWatchListArray.count == 0) {
            self.noDataView.hidden = NO;
        }
        else{
            self.noDataView.hidden = YES;
        }
        [this.myListTableView reloadData];

        //[self.collectionView.mj_header endRefreshing];
        [self.myListTableView.mj_header endRefreshing];
        
        [NSUserDefaultsManager  saveObject:@"今日看单" forKey:@"ProgramListClick_listname"];
        
        
    } failure:^(NSString *error) {
        self.defaultView.hidden = NO;
        if (!this) {
            return;
        }
        this.myWatchListArray = nil;
        [this.myListTableView reloadData];
        //[self.collectionView.mj_header endRefreshing];
          [self.myListTableView.mj_header endRefreshing];
        
    }];
}

-(UIView *)userInfoView{
    if (!_userInfoView) {
        _userInfoView = [[UIView alloc]initWithFrame:CGRectMake(W/2+10, 0, W/2-20, 100)];
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, _userInfoView.frame.size.width, 30)];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.text = [NSString stringWithFormat:@"亲爱的\"%@\"",[HiTVGlobals sharedInstance].nickName];
        [_userInfoView addSubview:_titleLab];
        
        _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(3, 55, 140, 70)];
        _headImg.image = [UIImage imageNamed:@"Group7.png"];//prompt1
        [_userInfoView addSubview:_headImg];
        
        [self.collectionView addSubview:_userInfoView];
    }
    return _userInfoView;
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
        label.font = [UIFont systemFontOfSize:13.0f];
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
        //[self.collectionView addSubview:_noDataView];
        [self.myListTableView addSubview:_noDataView];
    }
    return _noDataView;
}
-(UILabel *)tipLab{
    
    if (!_tipLab) {
        _tipLab = [UILabel new];
        _tipLab.backgroundColor = [UIColor whiteColor];
        _tipLab.textColor = [UIColor lightGrayColor];
        _tipLab.frame = CGRectMake(0, 0, W, 30);
        _tipLab.text = @"长按可以在我的节目单中删除您不喜欢的影片";
        _tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_tipLab];
    }
    return _tipLab;
}
-(void)reload{
    //[self.collectionView.mj_header beginRefreshing];
    [self.myListTableView.mj_header beginRefreshing];
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
//************************************************************************************//
#pragma mark BeiJingNewUIStyle
#pragma mark UI Part
-(void)addSubViewsAndViewConstraints{
    
    [self addSubview:self.myListTableView];
   
    [_myListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 0, 0, 0));
    }];
}

-(UITableView *)myListTableView{

    if (!_myListTableView) {
        _myListTableView = [UITableView new];
        _myListTableView.delegate = self;
        _myListTableView.dataSource = self;
        
        _myListTableView.showsVerticalScrollIndicator = NO;
        [_myListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
        _myListTableView.tableFooterView = [UIView new];
        WEAKSELF
        _myListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadWatchListRequest];
        }];
    }
    return _myListTableView;

}
#pragma mark Delegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [UIView new];
    headView.backgroundColor = [UIColor whiteColor];
    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, HeaderHeight);
    UIImageView *tipsImageV = [UIImageView new];
    tipsImageV.image = [UIImage imageNamed:@"tips"];
    tipsImageV.size = CGSizeMake(tipsWidth, tipsHeight);
    tipsImageV.center = headView.center;
    [headView addSubview:tipsImageV];
    return headView;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return self.myWatchListArray.count>0?HeaderHeight:0;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return RowHeight;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.myWatchListArray.count;
    //return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyListTableViewCell"];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MyListTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    cell.delegate = self;
    cell.cellEntity = self.myWatchListArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    WatchListEntity* content = nil;
    content = self.myWatchListArray[indexPath.row];
    if (self.m_delegate) {
        [self.m_delegate goDetailVC:content];
    }
}

#pragma mark Delegate
-(void)refreshAfterDeleteCurrentRow{
[self.myListTableView.mj_header beginRefreshing];
}
@end
