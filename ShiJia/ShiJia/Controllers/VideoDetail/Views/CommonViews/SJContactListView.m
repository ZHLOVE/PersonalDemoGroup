//
//  SJContactListView.m
//  ShiJia
//
//  Created by yy on 16/3/7.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJContactListView.h"
#import "SJSelectAllButton.h"
#import "SJContactListCell.h"
#import "UIView+DefaultEmptyView.h"

static CGFloat kLeftMargin         = 10.0;//左边距
static CGFloat kTitleViewHeight    = 50.0;//标题view高度
static CGFloat kBottomButtonHeight = 50.0;//底部按钮高度


@interface SJContactListTitleView ()

//@property (nonatomic, strong) UIView            *searchView;
//@property (nonatomic, strong) UIImageView       *searchIcon;
//@property (nonatomic, strong) UITextField       *searchTextField;
@property (nonatomic, strong) UILabel           *titleLabel;//标题label
@property (nonatomic, strong) SJSelectAllButton *selectAllButton;//全选按钮

@end

@implementation SJContactListTitleView

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];

    if (self) {

        //title
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _titleLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_titleLabel];

        //select all button
        _selectAllButton = [[SJSelectAllButton alloc] init];
        [self addSubview:_selectAllButton];

        _userCount = 203;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _titleLabel.frame = CGRectMake( kLeftMargin,
                                   0,
                                   self.frame.size.width - kSJSelectAllButtonWidth-kLeftMargin,
                                   self.frame.size.height);

    _selectAllButton.frame = CGRectMake( self.frame.size.width - kSJSelectAllButtonWidth,
                                        0,
                                        kSJSelectAllButtonWidth,
                                        self.frame.size.height);

}

#pragma mark - Setter & Getter
- (void)setUserCount:(NSInteger)userCount
{
    _userCount = userCount;
    if (userCount > 0) {
        _titleLabel.text = [NSString stringWithFormat:@"好友列表（共%zd人）",userCount];

    }
    else
    {
        _titleLabel.text = @"好友列表";
    }
}

- (void)setSelectedAll:(BOOL)selectedAll
{
    _selectedAll = selectedAll;
    _selectAllButton.checked = selectedAll;
}


- (RACSignal *)selectAllSignal
{
    return [_selectAllButton rac_signalForControlEvents:UIControlEventTouchUpInside];
}

@end




@interface SJContactListView ()<ASCollectionDataSource,ASCollectionDelegate,UITextFieldDelegate>

@property (nonatomic, strong) SJContactListTitleView *titleView;//标题view
@property (nonatomic, strong) ASCollectionView       *collectionView;//好友列表
@property (nonatomic, strong) NSMutableArray         *items;
@property (nonatomic, assign) BOOL                   selectedAll;
@property (nonatomic, strong, readwrite) UIButton               *bottomButton;//底部按钮
@property (nonatomic, strong, readwrite) NSMutableArray         *selectedItems;

//搜索页面 类似微信群聊加好友
@property (nonatomic, strong) UIView            *searchView;
@property (nonatomic, strong) ASCollectionView  *searchCollectionView;
@property (nonatomic, strong) UIImageView       *searchIcon;
@property (nonatomic, strong) UITextField       *searchTextField;

@property (nonatomic, assign) BOOL              search;               //搜索标志
@property (nonatomic, strong) NSMutableArray    *searchArray;
@end

@implementation SJContactListView

#pragma mark - Lifecycle
-(NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [NSMutableArray new];
    }
    return _searchArray;
}
-(UIView *)searchView{
    if (!_searchView) {
        _searchView = [UIView new];
        _searchView.backgroundColor = [UIColor whiteColor];
        [_searchView addSubview:self.searchCollectionView];
        [_searchView addSubview:self.searchIcon];
        [_searchView addSubview:self.searchTextField];

        [_searchCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_searchView);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(36);
            make.top.mas_equalTo(_searchView).offset(6);
        }];
        [_searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_searchCollectionView.mas_right).offset(5);
            make.centerY.mas_equalTo(_searchView);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_searchIcon.mas_right).offset(5);
            make.right.top.bottom.mas_equalTo(_searchView);
        }];

    }
    return _searchView;
}

-(ASCollectionView *)searchCollectionView{
    if (!_searchCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _searchCollectionView = [[ASCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _searchCollectionView.asyncDataSource = self;
        _searchCollectionView.asyncDelegate = self;
        _searchCollectionView.backgroundColor = [UIColor whiteColor];

    }
    return _searchCollectionView;
}

-(UIImageView *)searchIcon{
    if (!_searchIcon) {
        _searchIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_search"]];
    }
    return _searchIcon;
}

-(UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [UITextField new];
        _searchTextField.placeholder = @"搜索";
       [_searchTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        self.fakeText = _searchTextField;
    }
    return _searchTextField;
}


-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self hiddenKeyBoard];
}
-(void)hiddenKeyBoard
{
    [_searchTextField resignFirstResponder];

}


#pragma mark add subviews of scrollviews
-(void)refreshSearchCollcetionView{
    CGFloat searchCollectionWidth;
    if ((SCREEN_WIDTH-100)>_selectedItems.count*36) {

        searchCollectionWidth = _selectedItems.count*38;

    }else{

        searchCollectionWidth =SCREEN_WIDTH-100;
    }
    [_searchCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(searchCollectionWidth);
    }];

    [_searchCollectionView reloadData];

    [self scrollsToBottomAnimated:YES];

}

- (void)scrollsToBottomAnimated:(BOOL)animated
{

    if ((SCREEN_WIDTH-100)<_selectedItems.count*36){
        [_searchCollectionView setContentOffset:CGPointMake((_selectedItems.count*38+100-SCREEN_WIDTH), 0) animated:animated];
    }
}


- (void)textFieldValueChanged:(UITextField *)textField{

    if (_searchTextField) {
        if (_searchTextField.text.length>0) {
            self.search = YES;
            [_searchArray removeAllObjects];
            // 谓词搜索
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",textField.text];
            for (UserEntity *entity in _items) {
                NSString *name = entity.nickName;
                if (entity.nickName == nil||[entity.nickName isEqualToString:@"" ]) {
                    name = entity.name;
                }
                //NSString *enName = [HiTVConstants CHTOEN:name];

                if ([predicate evaluateWithObject:entity.enName]||[predicate evaluateWithObject:entity.phoneNo]||[predicate evaluateWithObject:entity.nickName]||[predicate evaluateWithObject:entity.name]) {
                    [_searchArray addObject:entity];
                }
            }
        }else{
            self.search = NO;
        }
        [self.collectionView reloadData];
    }

}

- (instancetype)initWithUsers:(NSArray<UserEntity *> *)users
{
    self = [super init];

    if (self) {

        _items = [[NSMutableArray alloc] initWithArray:users];
        _selectedItems = [[NSMutableArray alloc] init];


        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        tapGr.cancelsTouchesInView = NO;

        [self addGestureRecognizer:tapGr];
        [self addSubview:self.searchView];

        //title
        _titleView = [[SJContactListTitleView alloc] init];

        _titleView.backgroundColor = kColorLightGrayBackground;

        [self addSubview:_titleView];


        [[_titleView selectAllSignal] subscribeNext:^(SJSelectAllButton *x) {
            x.checked = !x.checked;

            if (x.checked) {

                // 全选
                _selectedItems = [NSMutableArray arrayWithArray:_items];
                _bottomButton.enabled = YES;
            }
            else{

                // 取消全选
                [_selectedItems removeAllObjects];
                _bottomButton.enabled = NO;
            }
            [_selectNumberSubject sendNext:_selectedItems];
            [_collectionView reloadData];
            [self refreshSearchCollcetionView];
        }];
        _searchArray =  self.searchArray;
        //collection view
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[ASCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.asyncDataSource = self;
        _collectionView.asyncDelegate = self;
        _collectionView.backgroundColor = kColorLightGrayBackground;
        [self addSubview:_collectionView];

        //bottom button
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomButton setBackgroundColor:[UIColor whiteColor]];
        [_bottomButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        [_bottomButton setTitle:@"发送分享" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_bottomButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_bottomButton addTarget:self action:@selector(bottomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bottomButton];
        _bottomButton.enabled = NO;

        self.selectNumberSubject = [RACSubject subject];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 42);

    _titleView.frame  = CGRectMake( 0,
                                   42,
                                   self.frame.size.width,
                                   kTitleViewHeight);


    _collectionView.frame = CGRectMake( 0,
                                       kTitleViewHeight+50,
                                       self.frame.size.width,
                                       self.frame.size.height - kTitleViewHeight-42- kBottomButtonHeight);

    _bottomButton.frame = CGRectMake( 0,
                                     self.frame.size.height - kBottomButtonHeight,
                                     self.frame.size.width,
                                     kBottomButtonHeight);



}




#pragma mark - Event
- (void)bottomButtonClicked:(id)sender
{

    if (self.bottomButtonClickBlock) {
        self.bottomButtonClickBlock(self.selectedItems);
    }
}

#pragma mark - ASCollectionDataSource & ASCollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView==_searchCollectionView) {
        return _selectedItems.count;
    }else{

        NSInteger rownumber = _search?_searchArray.count:_items.count;
        if (rownumber==0) {
            [self.collectionView setBackgroundView:[UIView Friend_EmptyDefaultView]];
        }else{
            [self.collectionView setBackgroundView:nil];
        }
        return rownumber;
    }
}

- (ASCellNode *)collectionView:(ASCollectionView *)collectionView nodeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_searchCollectionView) {
        SJContactListCell *cell = [[SJContactListCell alloc] init];
//        cell.backgroundColor = [UIColor clearColor];
        UserEntity *data = _selectedItems[indexPath.row];
        [cell showData:data];
        return cell;
    }else{
        SJContactListCell *cell = [[SJContactListCell alloc] init];

        UserEntity *data = _search?_searchArray[indexPath.row]:_items[indexPath.row];


        if ([_selectedItems containsObject:data]) {
            cell.checked = YES;
        }
        else{
            cell.checked = NO;
        }

        [cell showData:data];

        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==_collectionView) {
        SJContactListCell *cell =  (SJContactListCell *)[_collectionView nodeForItemAtIndexPath:indexPath];
        cell.checked = !cell.checked;

        UserEntity *data = _search?_searchArray[indexPath.row]:_items[indexPath.row];
        if (cell.checked) {

            if (![_selectedItems containsObject:data]) {
                [_selectedItems addObject:data];
            }

        }
        else{

            if ([_selectedItems containsObject:data]) {
                [_selectedItems removeObject:data];
            }
        }

        if (_selectedItems.count == _items.count) {
            _titleView.selectedAll = YES;
            _bottomButton.enabled = YES;
        }
        else{
            _titleView.selectedAll = NO;

            if (_selectedItems.count == 0) {

                _bottomButton.enabled = NO;
            }
            else{
                _bottomButton.enabled = YES;
            }
        }
        [self refreshSearchCollcetionView];

    }else{
        UserEntity *data = _selectedItems[indexPath.row];
        [_selectedItems removeObject:data];
        [self refreshSearchCollcetionView];
        [self.collectionView reloadData];
    }
     [_selectNumberSubject sendNext:_selectedItems];
}

- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForNodeAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_searchCollectionView) {
        CGSize size = CGSizeMake(36,36);
        return ASSizeRangeMakeExactSize(size);
    }else{
        CGFloat width = (collectionView.frame.size.width - 10 * 7) / 6.0;
        CGSize size = CGSizeMake(width, width + 30);
        return ASSizeRangeMakeExactSize(size);
    }
}

//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout*)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGFloat width = (collectionView.frame.size.width - 10 * 7) / 6.0;
//    return CGSizeMake(width, width + 20);
//}

- (void)collectionViewLockDataSource:(ASCollectionView *)collectionView
{
    // lock the data source
    // The data source should not be change until it is unlocked.
}

- (void)collectionViewUnlockDataSource:(ASCollectionView *)collectionView
{
    // unlock the data source to enable data source updating.
}

- (void)collectionView:(UICollectionView *)collectionView willBeginBatchFetchWithContext:(ASBatchContext *)context
{
    [context completeBatchFetching:YES];
}

- (CGFloat)collectionView:(UICollectionView * )collectionView
                   layout:(UICollectionViewLayout * )collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return collectionView==_searchCollectionView?1:10;

}

- (UIEdgeInsets)collectionView:(ASCollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return collectionView==_searchCollectionView?UIEdgeInsetsMake(0, 0, 0, 0):UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0);
}
#pragma mark - Setter & Getter
- (void)setBottomButtonTitle:(NSString *)bottomButtonTitle
{
    _bottomButtonTitle = bottomButtonTitle;
    [_bottomButton setTitle:bottomButtonTitle forState:UIControlStateNormal];
}

- (void)setUserList:(NSArray *)userList
{
    _userList = userList;
    _items = [NSMutableArray arrayWithArray:userList];
    _titleView.userCount = _items.count;
    [_collectionView reloadData];
}


@end
