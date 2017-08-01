//
//  SJYueViewController.m
//  ShiJia
//
//  Created by yy on 16/6/22.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJYueViewController.h"
#import "SJYueCell.h"
#import "SJInviteUserViewController.h"

#import "TPIMUser.h"
#import "TPXmppRoomManager.h"
#import "TPIMAlertView.h"

@interface SJYueViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) TRTopNavgationView *naviView;
@property (nonatomic, strong) UICollectionView *collectionview;
@property (nonatomic, strong) UIButton *bottomButton;

@end

@implementation SJYueViewController

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        _collectionview.backgroundColor = [UIColor whiteColor];
        [_collectionview registerNib:[UINib nibWithNibName:kSJYueCellIdentifier bundle:nil] forCellWithReuseIdentifier:kSJYueCellIdentifier];
        //[_collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerview"];
        
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.backgroundColor = [UIColor whiteColor];
        [_bottomButton setTitle:@"退出" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_bottomButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [_bottomButton addTarget:self action:@selector(logoutRoom) forControlEvents:UIControlEventTouchUpInside];
        _bottomButton.layer.cornerRadius = 20.0;
        _bottomButton.layer.masksToBounds = YES;
        
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorLightGrayBackground;
    self.navigationController.navigationBarHidden = YES;
    
    [self initNavigationView];
    [self.view addSubview:_collectionview];
    [self.view addSubview:_bottomButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // 动态计算collectionview 高度
    //计算行数
    NSInteger row;
    if (_list.count % 6 == 0) {
        row = _list.count / 6;
    }
    else{
        row = _list.count / 6 + 1;
    }
    // 每个cell宽度
    CGFloat width = (self.view.frame.size.width - 10 * 5) / 6.0;
    
    // 每个cell高度
    CGFloat rowHeight = width + 20;
    
    // collection view高度
    CGFloat height = rowHeight * row;
    
    if (height > (self.view.frame.size.height - 64 - 70)) {
        height = self.view.frame.size.height - 64 - 70;
    }
    
    _collectionview.frame = CGRectMake(0, 64, self.view.frame.size.width, height);
    _bottomButton.frame = CGRectMake(10, _collectionview.frame.origin.y + height + 15, self.view.frame.size.width - 10 * 2, 40);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return _list.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SJYueCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSJYueCellIdentifier forIndexPath:indexPath];
        
    if (indexPath.row == _list.count) {
        
        cell.style = SJYueCellStyleInvited;
        
    }
    else{
        cell.style = SJYueCellStyleNormal;
        TPIMUser *user = _list[indexPath.row];
        [cell showImgUrl:user.headImageUrl name:user.nickname];
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _list.count) {
        
        self.hidesBottomBarWhenPushed = YES;
        SJInviteUserViewController *inviteVC = [[SJInviteUserViewController alloc] init];
        inviteVC.disabledUserList = [NSArray arrayWithArray:[TPXmppRoomManager defaultManager].roomMemberList];
        [inviteVC setDidSelectedUserList:^(NSArray *list) {
            
            [TPXmppRoomManager defaultManager].invitedUserList = [NSArray arrayWithArray:list];

            if ([TPXmppRoomManager defaultManager].roomMemberList.count == 0) {
                // 创建房间并邀请好友
                [[TPXmppRoomManager defaultManager] sendInvitationMessageAndCreateRoom];
            }
            else{
                //房间已创建，仅邀请好友
                [[TPXmppRoomManager defaultManager] sendInvitationMessageWithRoomId:[TPXmppRoomManager defaultManager].roomId];
            }
            
        }];
        [self.navigationController pushViewController:inviteVC animated:YES];
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (collectionView.frame.size.width - 10 * 5) / 6.0;
    return CGSizeMake(width, width + 20);
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(collectionView.frame.size.width, 60);
//}
//
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *reusableview = nil;
//    
//    if (kind == UICollectionElementKindSectionFooter){
//        
//        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerview" forIndexPath:indexPath];
//        
//        UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        logoutBtn.frame = CGRectMake(20, 10, collectionView.frame.size.width - 20 * 2, 40);
//        logoutBtn.backgroundColor = kColorBlueTheme;
//        [logoutBtn setTitle:@"退出群聊" forState:UIControlStateNormal];
//        [logoutBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//        [logoutBtn addTarget:self action:@selector(logoutRoom) forControlEvents:UIControlEventTouchUpInside];
//        [footerview addSubview:logoutBtn];
//        
//        reusableview = footerview;
//        
//    }
//    
//    return reusableview;
//}
//
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10 , 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView * )collectionView
                   layout:(UICollectionViewLayout * )collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
    
}

#pragma mark - Room Operation
- (void)logoutRoom{
    
    
    NSString *mes = [NSString stringWithFormat:@"亲爱的%@:",[HiTVGlobals sharedInstance].nickName];
    
    TPIMAlertView *alert = [[TPIMAlertView alloc]initWithTitle:mes
                                                       message:@"是否退出聊天室"
                                               leftButtonTitle:@"取消"
                                              rightButtonTitle:@"退出"];
    alert.rightButtonClickBlock = ^(){
        
        
         [[TPXmppRoomManager defaultManager] leaveRoom];
        [self.navigationController popViewControllerAnimated:YES];
    };
    [alert show];
    
}

#pragma mark - Subview
- (void)initNavigationView
{
    _naviView = [TRTopNavgationView navgationView];
    [self.view addSubview:_naviView];
    _naviView.backgroundColor = kNavgationBarColor;
    
    // back button
    UIButton* backBt = [UIHelper createBtnfromSize:kBackButtonSize
                                             image:[UIImage imageNamed:@"white_back_btn"]
                                      highlightImg:[UIImage imageNamed:@"white_back_btn"]
                                       selectedImg:nil
                                            target:self
                                          selector:nil];
    __weak __typeof(self)weakSelf = self;
    [[backBt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
    [_naviView setLeftView:backBt];
    
    // title
    UILabel* lbl = [UIHelper createTitleLabel:@"一起看"];
    lbl.textColor = [UIColor whiteColor];
    [_naviView setTitleView:lbl];
    
    
}
@end
