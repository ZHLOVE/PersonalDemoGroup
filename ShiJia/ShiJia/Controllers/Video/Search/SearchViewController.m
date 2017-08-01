//
//  SearchViewController.m
//  HiTV
//
//  created by iSwift on 3/8/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "SearchViewController.h"
#import "SearchDataProvider.h"
#import "SearchListCell.h"
#import "MBProgressHUD.h"
#import "SearchVoiceController.h"
#import "SearchVideo.h"
#import "SJVideoDetailViewController.h"
#import "SearchEntity.h"
#import "SJMultiVideoDetailViewController.h"
#import "BgView.h"
#import "SearchHistoryCell.h"
#import "WatchListEntity.h"

#define SECTION0H   260
NSString* const cSearchHistoryCellID = @"SearchHistoryCell";

typedef enum : NSUInteger {
    TipsTabType,
    ContentTabType
} TabViewType;

@interface SearchViewController ()<SearchHistoryCellDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (strong, nonatomic) NSMutableArray* videosArray;
@property (nonatomic, assign) TabViewType tabViewType;
@property (strong, nonatomic) NSArray* tipsArray;
@property (strong, nonatomic) NSMutableArray* historyArray;

@property (strong, nonatomic) NSString* keywordType;
@property (strong, nonatomic) NSString* keyword;

@property (nonatomic, strong) BgView *bgView;
@property (strong, nonatomic) UIButton* editButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteAllButton;

@property (nonatomic, assign) BOOL editing;
@property (strong, nonatomic)  UIView *defaultView;//缺省页
@property (nonatomic) int nextPageNumber;

@end

@implementation SearchViewController

- (void)dealloc{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"搜索"];
    
    [self.textField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.tableView registerNib:[UINib nibWithNibName:cSearchListCellID bundle:nil] forCellReuseIdentifier:cSearchListCellID];
    [self.tableView registerNib:[UINib nibWithNibName:cSearchHistoryCellID bundle:nil] forCellReuseIdentifier:cSearchHistoryCellID];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.separatorColor = kTabLineColor;

    [self.textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGr];
    
    self.editing = NO;

    _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _editButton.backgroundColor = [UIColor clearColor];
    _editButton.frame = CGRectMake(W-50, 0, 40, 55);
    [_editButton setTitle:@"删除" forState:UIControlStateNormal];
    _editButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_editButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_editButton addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
   // self.tableView.tableHeaderView = headView;
    self.editButton.hidden = YES;

    NSArray *historyArray = [NSUserDefaultsManager getObjectForKey:SEARCHSARRAY];
    
    self.historyArray = [NSMutableArray arrayWithArray:historyArray];


    [self getTipsRequest];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setEditing:NO animated:NO];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if ([self.videosArray count] == 0) {
       // [self.textField becomeFirstResponder];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.textField];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:self.textField];
}
-(void)setHistoryArray:(NSMutableArray *)historyArray{
    _historyArray = historyArray;
    if (self.historyArray.count == 0) {
        self.editButton.hidden = YES;
        [self p_updateEditing];
    }
    else{
        self.editButton.hidden = NO;
    }
}
- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
   // [self.tableView setEditing:editing animated:animated];
    if (editing) {
        [self.editButton setImage:nil forState:UIControlStateNormal];
        [self.editButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.deleteAllButton setHidden:NO];
    }else{
        [self.editButton setTitle:@"删除" forState:UIControlStateNormal];
        [self.deleteAllButton setHidden:YES];
    }
}

#pragma mark - private
- (void)p_updateEditing{
    //    [self setEditing:!self.editing animated:YES];
    self.editing = !self.editing;
    if (self.editing) {
        [self.editButton setImage:nil forState:UIControlStateNormal];
        [self.editButton setTitle:@"取消" forState:UIControlStateNormal];
        self.deleteAllButton.hidden = NO;
    }else{
        [self.editButton setTitle:@"删除" forState:UIControlStateNormal];
        self.deleteAllButton.hidden = YES;
    }
    [self.tableView reloadData];
    
}
-(void)getTipsRequest{
    
    self.tabViewType = TipsTabType;
    // 下拉刷新
    self.tableView.mj_header = nil;
    // 上拉加载更多
    self.tableView.mj_footer = nil;
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[SearchDataProvider sharedInstance] getTipsWithCompletion:^(id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:NO];
        strongSelf.tipsArray = (NSArray*)responseObject;
        [strongSelf.tableView reloadData];
    } failure:^(NSString *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:NO];
        
        
    }];
}

//add by jzb at 20150730
- (void)searchResult
{
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self searchResult];
    }];
    // 上拉加载更多
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self p_loadMore];
    }];
    self.nextPageNumber = 0;

    self.tabViewType = ContentTabType;
    NSString *keyword = self.keyword;
    if (keyword.length>0) {
        NSArray *historyArray = [NSUserDefaultsManager getObjectForKey:SEARCHSARRAY];
        
        NSMutableArray *newArray = [NSMutableArray array];
        [newArray addObjectsFromArray:historyArray];
        if ([newArray containsObject:keyword]) {
            [newArray removeObject:keyword];
        }
        [newArray insertObject:keyword atIndex:0];
        [NSUserDefaultsManager saveObject:newArray forKey:SEARCHSARRAY];
    }
    
    self.historyArray = [NSUserDefaultsManager getObjectForKey:SEARCHSARRAY];
    
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SearchDataProvider sharedInstance] search:keyword
                                     keywordType:_keywordType
                                          start:self.nextPageNumber
                                 withCompletion:^(id responseObject) {
                                     __strong __typeof(weakSelf)strongSelf = weakSelf;
                                     [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:NO];
                                     NSArray* results = responseObject[@"programSeries"];
                                     
                                     NSMutableArray* returnResults = [[NSMutableArray alloc] initWithCapacity:results.count];
                                     
                                     if ([results isKindOfClass:[NSDictionary class]]) {
                                         [returnResults addObject:[[SearchEntity alloc] initWithDict:(NSDictionary*)results]];
                                     }else{
                                         for (NSDictionary* dict in results) {
                                             [returnResults addObject:[[SearchEntity alloc] initWithDict:dict]];
                                         }
                                     }
                                     
                                     
                                     strongSelf.videosArray = returnResults;
                                     if (strongSelf.videosArray.count == 0) {
                                         //[MBProgressHUD showError:@"没有搜到该内容" toView:self.view];
                                         strongSelf.tabViewType = TipsTabType;
                                         // 下拉刷新
                                         self.tableView.mj_header = nil;
                                         // 上拉加载更多
                                         self.tableView.mj_footer = nil;
                                         strongSelf.tableView.tableHeaderView = strongSelf.defaultView;
                                     }
                                     else{
                                         strongSelf.keyword = keyword;
                                         strongSelf.tableView.tableHeaderView = nil;

                                     }
                                     [strongSelf.tableView reloadData];
                                     [strongSelf.tableView setContentOffset:CGPointMake(0,0) animated:NO];
                                     
                                     int currentPageNumber = [[(NSDictionary *)responseObject objectForKey:@"start"] intValue];
                                     strongSelf.nextPageNumber = currentPageNumber + 1;
                                     [strongSelf.tableView.mj_header endRefreshing];
                                 } failure:^(NSString *error) {
                                     __strong __typeof(weakSelf)strongSelf = weakSelf;
                                     [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:NO];
                                     [MBProgressHUD showError:@"没有搜到该内容" toView:strongSelf.view];
                                     strongSelf.tabViewType = TipsTabType;
                                     // 下拉刷新
                                     self.tableView.mj_header = nil;
                                     // 上拉加载更多
                                     self.tableView.mj_footer = nil;
                                     [strongSelf.tableView.mj_header endRefreshing];
                                 }];
    
}

- (IBAction)voiceSearched:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    SearchVoiceController *vc = [[SearchVoiceController alloc]initWithSpeechResult:^(NSString *result) {

        if (result.length == 0) {
            [MBProgressHUD showError:@"没有搜到该内容" toView:self.view];
        }else{
            if (result.length>9) {
                result = [result substringWithRange:NSMakeRange(0, 10)];
            }
            self.textField.text = result;
            if ([self IsChinese:self.textField.text]) {
                _keywordType = @"exact";
            }
            else{
                _keywordType = @"fuzzy";
            }
            [self.textField resignFirstResponder];
            self.keyword = result;
            [self searchResult];
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 删除
-(void)deleteBtnClick{
    [self p_updateEditing];
}
//end

#pragma mark - SearchHistoryCellDelegate
- (void)deleteHistoryWord:(NSString *)word{
    NSArray *historyArray = [NSUserDefaultsManager getObjectForKey:SEARCHSARRAY];
    
    NSMutableArray *newArray = [NSMutableArray array];
    [newArray addObjectsFromArray:historyArray];
    [newArray removeObject:word];
    
    [NSUserDefaultsManager saveObject:newArray forKey:SEARCHSARRAY];
    
    self.historyArray = [NSUserDefaultsManager getObjectForKey:SEARCHSARRAY];
    
    [self.tableView reloadData];
    //[self p_updateEditing];

}
- (IBAction)deleteHitsoryWords:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"清空确认" message:@"确定清空所有搜索历史？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [NSUserDefaultsManager deleteObjectForKey:SEARCHSARRAY];
        self.historyArray = [NSUserDefaultsManager getObjectForKey:SEARCHSARRAY];
        
        [self.tableView reloadData];
        [self p_updateEditing];
    }
    [self p_updateEditing];
}
#pragma mark - UI methods
- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private
- (void)p_handleEmptyOrError{
    MBProgressHUD* HUD= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"服务器未返回视频";
    HUD.mode = MBProgressHUDModeText;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:1];
}

#pragma mark - UITextFieldDelegate
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;

    NSString *toBeString = textField.text;
    NSString *lang = [[self textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 9) {
                textField.text = [toBeString substringToIndex:9];
                [OMGToast showWithText:@"超过最大字数不能输入了"];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 11) {
            textField.text = [toBeString substringToIndex:11];
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

//    if (textField.text.length > 10) return NO;

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    _keywordType = @"fuzzy";
    if ([self IsChinese:textField.text]) {
        _keywordType = @"exact";
    }
    self.keyword = textField.text;

    [self searchResult];
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)IsChinese:(NSString *)str {
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    } return NO;
}
#pragma mark - UITextFieldDelegate
- (void)textFieldValueChanged:(UITextField *)textField
{

    if (textField.text == nil ||self.textField.text == nil ||[self.textField.text isEqualToString:@""]) {
        self.tabViewType = TipsTabType;
        // 下拉刷新
        self.tableView.mj_header = nil;
        // 上拉加载更多
        self.tableView.mj_footer = nil;
        self.tableView.tableHeaderView = nil;
        [self.tableView reloadData];
    }
    
}
#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.tabViewType == TipsTabType) {
        
        UILabel *headLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, W, 55)];
        headLab.backgroundColor = [UIColor clearColor];
        headLab.textColor = [UIColor blackColor];
        headLab.font = [UIFont systemFontOfSize:16.0f];
        headLab.textAlignment = NSTextAlignmentLeft;
        headLab.userInteractionEnabled = YES;
        if (section == 0) {
            headLab.text = @"      大家在看";
        }
        else{
            headLab.text = @"      搜索历史";
        }
//        UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 18, 2, 20)];
//        lineLab.backgroundColor = kColorBlueTheme;
//        lineLab.textColor = [UIColor blackColor];
//        [headLab addSubview:lineLab];

        UIImageView *triangeleImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 23, 7, 9)];
        triangeleImage.image = [UIImage imageNamed:@"Triangle"];
        [headLab addSubview:triangeleImage];
        
        [headLab addSubview:[self seperateViewWithHeight:55]];
        
        if (section == 1) {
            [headLab addSubview:_editButton];
            
        }
        return headLab;
        
    }
    else{
        return nil;
    }
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.tabViewType == ContentTabType) {
        return 1;
         
    }
    else{
        if (self.historyArray.count>0) {
            return 2;
        }
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.tabViewType == ContentTabType) {
        return self.videosArray.count;

    }
    else{
        if (section == 0) {
            return 1;
        }
        else{
            if (self.historyArray.count>5) {
                return 5;
            }
            return self.historyArray.count;
        }

    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"全部清空";
}
-(UIView *)seperateViewWithHeight:(float)height{
    UIView *view =  [[UIView alloc] initWithFrame:CGRectMake(0, height-0.5,W, 0.5)];
    view.backgroundColor = [UIColor colorWithRed:209/255.0 green:210/255.0 blue:211/255.0 alpha:1];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tabViewType == ContentTabType) {
        SearchListCell *cell = [tableView dequeueReusableCellWithIdentifier:cSearchListCellID];
        [cell.selectedImg setHidden:YES];
        cell.keyword = self.keyword;
        cell.video = self.videosArray[indexPath.row];
        return cell;
    }
//    static NSString *CellIdentifier = @"Cell";
    
    SearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cSearchHistoryCellID];
    cell.m_delegate = self;
    //if (cell == nil) {
       // cell = [[SearchHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = klightGrayColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   // }
    
    NSInteger row = indexPath.row;
    if (indexPath.section == 0) {
        cell.img.hidden = YES;
        cell.deleteBtn.hidden = YES;
        cell.deleteBgBtn.hidden = YES;

        if ((!_bgView) &&self.tipsArray.count>0) {
            _bgView=[[BgView alloc]init];
            _bgView.array = self.tipsArray;
            _bgView.frame = CGRectMake(0, 0, W, _bgView.height);
            _bgView.backgroundColor=[UIColor clearColor];
            [cell addSubview:_bgView];

            __weak __typeof(self)weakSelf = self;
            [_bgView setBlock:^(UIButton *button, NSString *string) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                DDLogInfo(@"---%@",string);
                strongSelf.textField.text = string;
                _keywordType = @"exact";
                
                strongSelf.keyword = string;

                [strongSelf searchResult];
            }];
        }

    }
    else{
        if (self.editing) {
            [cell.deleteBtn setHidden:NO];
        }
        else
        {
            [cell.deleteBtn setHidden:YES];
        }
        NSString *word = self.historyArray[row];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",word];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    }

    
    return cell;
    
}

 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (self.tabViewType == ContentTabType) {
         SearchEntity* video = self.videosArray[indexPath.row];
         if ([video.searchType isEqualToString:@"live"]){
             SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeWatchTV];
             WatchListEntity *entity = [[WatchListEntity alloc]init];
             entity.programSeriesId = video.Id;
             detailVC.watchEntity = entity;
             [self.navigationController pushViewController:detailVC animated:YES];
         }
         else{
             SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
             detailVC.videoID = video.Id;
             [self.navigationController pushViewController:detailVC animated:YES];
         }
         
         [self umengEvent:video.name];
         [self umengEventPlay:video.name];

         // add log.
         NSString* content = [NSString stringWithFormat:@"text=%@&programSeriesId=%@&programseriesname=%@",isNullString(self.keyword), isNullString(video.Id), isNullString(video.name)];
         
         [Utils BDLog:1 module:@"605" action:@"AppSearch" content:content];
         // add log.

     }
     else{
         if (indexPath.section != 0) {
             NSString *word = self.historyArray[indexPath.row];
             self.textField.text = word;
             if ([self IsChinese:self.textField.text]) {
                 _keywordType = @"exact";
             }
             else{
                 _keywordType = @"fuzzy";
             }
             
             self.keyword = word;

             [self searchResult];
         }
         
     }
     
     
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
 }
 


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tabViewType == ContentTabType) {
        return cSearchListCellHeight;
    }else{
        if (indexPath.section == 0) {
            return _bgView.height;
        }
        return cSearchTipsCellHeight;
    }
        
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.tabViewType == TipsTabType) {
        
        return 55;
    }
    return 0;
}
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
#pragma mark - viewForHeaderInSection 不停留在顶部
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        if (self.tabViewType == TipsTabType) {
            //YOUR_HEIGHT 为最高的那个headerView的高度
            CGFloat sectionHeaderHeight = cSearchTipsCellHeight+50;
            if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
                scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
                scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            }

        }
        else{
            //YOUR_HEIGHT 为最高的那个headerView的高度
            CGFloat sectionHeaderHeight = cSearchListCellHeight;
            if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
                scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
                scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            }
            
        }
    }
}

#pragma mark - Keyboard
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    if (![self.textField isExclusiveTouch]) {
//        [self.textField resignFirstResponder];
//    }
//}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self.textField resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self viewTapped:nil];
}
-(UIView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, W, 240)];
        _defaultView.backgroundColor = [UIColor clearColor];
        
        UIImageView *zwddImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
        zwddImg.image = [UIImage imageNamed:@"icon_search"];
        zwddImg.center = CGPointMake(W/2,100);
        [_defaultView addSubview:zwddImg];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, zwddImg.frame.size.height+zwddImg.frame.origin.y+10, W, 30)];
        lab.backgroundColor = [UIColor clearColor];
        lab.text = @"没有搜到该内容";
        lab.textColor = [UIColor lightGrayColor];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentCenter;
        [_defaultView addSubview:lab];
    }
    
    return _defaultView;
}
- (void)p_loadMore{
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self searchResult];
    }];
    // 上拉加载更多
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self p_loadMore];
    }];
    
    self.tabViewType = ContentTabType;
    NSString *keyword = self.keyword;

    if (keyword.length>0) {
        NSArray *historyArray = [NSUserDefaultsManager getObjectForKey:SEARCHSARRAY];
        
        NSMutableArray *newArray = [NSMutableArray array];
        [newArray addObjectsFromArray:historyArray];
        if ([newArray containsObject:keyword]) {
            [newArray removeObject:keyword];
        }
        [newArray insertObject:keyword atIndex:0];
        [NSUserDefaultsManager saveObject:newArray forKey:SEARCHSARRAY];
    }
    
    self.historyArray = [NSUserDefaultsManager getObjectForKey:SEARCHSARRAY];
    
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SearchDataProvider sharedInstance] search:keyword
                                    keywordType:_keywordType
                                          start:self.nextPageNumber
                                 withCompletion:^(id responseObject) {
                                     __strong __typeof(weakSelf)strongSelf = weakSelf;
                                     [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:NO];
                                     NSArray* results = responseObject[@"programSeries"];
                                     
                                     NSMutableArray* returnResults = [[NSMutableArray alloc] initWithCapacity:results.count];
                                     
                                     if ([results isKindOfClass:[NSDictionary class]]) {
                                         [returnResults addObject:[[SearchEntity alloc] initWithDict:(NSDictionary*)results]];
                                     }else{
                                         for (NSDictionary* dict in results) {
                                             [returnResults addObject:[[SearchEntity alloc] initWithDict:dict]];
                                         }
                                     }
                                     [strongSelf.videosArray addObjectsFromArray:returnResults];
                                     if (strongSelf.videosArray.count == 0) {
                                         //[MBProgressHUD showError:@"没有搜到该内容" toView:self.view];
                                         strongSelf.tabViewType = TipsTabType;
                                         // 下拉刷新
                                         self.tableView.mj_header = nil;
                                         // 上拉加载更多
                                         self.tableView.mj_footer = nil;
                                         strongSelf.tableView.tableHeaderView = strongSelf.defaultView;
                                     }
                                     else{
                                         strongSelf.keyword = keyword;
                                         strongSelf.tableView.tableHeaderView = nil;
                                         
                                     }
                                     [strongSelf.tableView reloadData];
                                   //  [strongSelf.tableView setContentOffset:CGPointMake(0,0) animated:NO];
                                     
                                     int currentPageNumber = [[(NSDictionary *)responseObject objectForKey:@"start"] intValue];
                                     
                                     if (strongSelf.nextPageNumber == 1) {
                                         [strongSelf.tableView.mj_header endRefreshing];
                                     }else{
                                         [strongSelf.tableView.mj_footer endRefreshing];
                                     }
                                     if (strongSelf.videosArray.count>0) {
                                         strongSelf.nextPageNumber = currentPageNumber + 1;
                                     }
                                 } failure:^(NSString *error) {
                                     __strong __typeof(weakSelf)strongSelf = weakSelf;
                                     [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:NO];
                                     [MBProgressHUD showError:@"没有搜到该内容" toView:strongSelf.view];
                                     strongSelf.tabViewType = TipsTabType;
                                     // 下拉刷新
                                     self.tableView.mj_header = nil;
                                     // 上拉加载更多
                                     self.tableView.mj_footer = nil;
                                     if (strongSelf.nextPageNumber == 1) {
                                         [strongSelf.tableView.mj_header endRefreshing];
                                     }else{
                                         
                                         [strongSelf.tableView.mj_footer endRefreshing];
                                     }
                                 }];
    
}

#pragma mark - 友盟统计
-(void)umengEvent:(NSString *)result{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.keyword forKey:@"text"];
    [dic setValue:result forKey:@"result"];
    
    [UMengManager event:@"U_AppSearch" attributes:dic];
}

#pragma mark - 友盟统计播放
-(void)umengEventPlay:(NSString *)content{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"常规视频" forKey:@"type_name"];
    [dic setValue:@"首页" forKey:@"first_nav"];
    [dic setValue:@"搜索" forKey:@"sec_nav"];
    [dic setValue:content forKey:@"program_name"];
    
    [UMengManager event:@"U_Play" attributes:dic];
}
@end
