//
//  FriendsWatchView.m
//  ShiJia
//
//  Created by 蒋海量 on 2017/3/13.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "FriendsWatchView.h"
#import "FriendsWatchCollectionViewCell.h"
#import "UserEntity.h"

static NSString* const KFriendsWatchCollectionViewCellID = @"FriendsWatchCollectionViewCell";

@interface FriendsWatchView ()<UICollectionViewDataSource,UICollectionViewDelegate>
    
@property (strong, nonatomic)  UICollectionView *collectionView;
@property (strong, nonatomic) NSArray* friendsArray;
@property (strong, nonatomic) NSArray* fList;
@property (nonatomic, strong) UIView *noDataView;
@property (strong, nonatomic)  UIView *defaultView;

@end
@implementation FriendsWatchView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        
        [self addSubview:self.collectionView];
        
        [self.collectionView.mj_header beginRefreshing];
        
    }
    return self;
}
    
- (void)layoutSubviews
    {
        [super layoutSubviews];
        
        _collectionView.frame = self.bounds;
        
    }
#pragma mark UI
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        // 创建瀑布流layout
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = YES;
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerNib:[UINib nibWithNibName:KFriendsWatchCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:KFriendsWatchCollectionViewCellID];
        
        
        WEAKSELF
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            [weakSelf loadFriendsRequest];
        }];
    }
    return _collectionView;
}
#pragma mark - 刷新数据
- (void)p_reloadData {
    
    [self.collectionView reloadData];
}
#pragma mark - UICollectionView Datasource
    
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {

    return self.friendsArray.count;
}
    
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
    
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WatchListEntity* entity = self.friendsArray[indexPath.row];
    FriendsWatchCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:KFriendsWatchCollectionViewCellID forIndexPath:indexPath];
    cell.layer.cornerRadius = 2;
    cell.entity = entity;
    if (entity.verticalPosterAddr.length != 0) {
        [cell.imageView setImageWithURL:[NSURL URLWithString:entity.posterAddr] placeholderImage:[UIImage imageNamed:@"watchlist-thumbnail"]];
    }
    else{
        [cell.imageView setImageWithURL:[NSURL URLWithString:entity.verticalPosterAddr]];
    }
    [cell.channelLogo setImageWithURL:[NSURL URLWithString:entity.channelLogo]];
    cell.channelName.text = entity.channelName;
    cell.programeName.text = entity.programSeriesName;
    cell.hourLab.text = entity.duration;
    cell.reasonLab.text = entity.reason;
    if (entity.friendIds.length == 0) {
        cell.headImg.image = [UIImage imageNamed:@"near"];
    }
    else{
        NSArray *array = [entity.friendIds componentsSeparatedByString:@","];
        if (array.count == 1) {
            self.getFriendsDataBlock = ^(NSArray *list){
                for (UserEntity *userEntity in list) {
                    if ([userEntity.uid intValue] == [entity.friendIds intValue]) {
                        [cell.headImg setImageWithURL:[NSURL URLWithString:userEntity.faceImg] placeholderImage:[UIImage imageNamed:@"friends"]];
                        break;
                    }
                }
            };
            [self getFriends];
        }
        else{
            cell.headImg.image = [UIImage imageNamed:@"friends"];
        }
        
    }
    return cell;
}
    
    
    
#pragma mark - UICollectionViewDelegate (GODETAIL 看单)
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
    {
        WatchListEntity*  content = self.friendsArray[indexPath.row];

        if (self.m_delegate) {
            [self.m_delegate goDetailVC:content];
        }
}
    
#pragma mark – UICollectionViewDelegateFlowLayout
    
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(W-20,124);
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
    
    return 10;
    
    
}
#pragma mark - 大家在看
-(void)loadFriendsRequest{
    __weak typeof(self) this = self;
    NSString* url = [NSString stringWithFormat:@"%@personal/getFriendList",
                     MYEPG];
    NSDictionary *param = @{
                            @"userId" : [HiTVGlobals sharedInstance].uid,
                            @"deviceType" : @"mobile",
                            // @"tvTemplateId" : WATCHTVGROUPID,
                            //@"vodTemplateId" : [[HiTVGlobals sharedInstance]getEpg_groupId],
                            @"abilityString" :  T_STBext,
                            @"limitNum" : @"0",
                            };
    
    
    DDLogInfo(@"url: %@", url);
    [BaseAFHTTPManager postRequestOperationForHost:url forParam:@"" forParameters:param completion:^(id responseObject) {
        self.defaultView.hidden = YES;
        if (!this) {
            return;
        }
        NSMutableArray *resultArray = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"resultList"]) {
            WatchListEntity* entity = [[WatchListEntity alloc]initWithDictionary:dic];
            [resultArray addObject:entity];
        }
        this.friendsArray = resultArray;
        if (this.friendsArray.count == 0) {
            self.noDataView.hidden = NO;
        }
        else{
            self.noDataView.hidden = YES;
        }
        [this p_reloadData];
        [self.collectionView.mj_header endRefreshing];
        
        [NSUserDefaultsManager saveObject:@"大家在看" forKey:@"ProgramListClick_listname"];
        
    } failure:^( NSString *error) {
        self.defaultView.hidden = NO;
        if (!this) {
            return;
        }
        this.friendsArray = nil;
        [this p_reloadData];
        [self.collectionView.mj_header endRefreshing];
    }];
}
#pragma mark – 获取好友
-(void)getFriends{
    if (self.fList) {
        if (self.getFriendsDataBlock) {
            self.getFriendsDataBlock(self.fList);
        }
    }else{
        NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
        [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
        
        [BaseAFHTTPManager postRequestOperationForHost:SOCIALHOST
                                              forParam:@"/taipan/getUserFriendList"
                                         forParameters:parameters
                                            completion:^(id responseObject) {
                                                NSDictionary *resultDic = (NSDictionary *)responseObject;
                                                if ([[resultDic objectForKey:@"code"] intValue] == 0) {
                                                    NSMutableArray *resultArray = [NSMutableArray array];
                                                    
                                                    NSArray *usersArray = [resultDic objectForKey:@"users"];
                                                    
                                                    for (NSMutableDictionary *userDic in usersArray) {
                                                        UserEntity *entity = [[UserEntity alloc]initWithDictionary:userDic];
                                                        
                                                        [resultArray addObject:entity];
                                                    }
                                                    
                                                    self.fList = resultArray;
                                                    if (self.getFriendsDataBlock) {
                                                        self.getFriendsDataBlock(self.fList);
                                                    }
                                                    [HiTVGlobals sharedInstance].friendsArray = resultArray;
                                                }
                                                DDLogInfo(@"suc");
                                            }failure:^(NSString *error) {
                                                if (self.getFriendsDataBlock) {
                                                    self.getFriendsDataBlock(nil);
                                                }
                                                
                                                DDLogError(@"fail");
                                                
                                            }];
    }
    
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
        [self.collectionView addSubview:_noDataView];
    }
    return _noDataView;
}
-(void)reload{
    [self.collectionView.mj_header beginRefreshing];
    
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
@end
