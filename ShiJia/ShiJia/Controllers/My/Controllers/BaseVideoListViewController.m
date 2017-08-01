//
//  VideoListBaseViewController.m
//  HiTV
//
//  created by iSwift on 3/9/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "BaseVideoListViewController.h"
#import "RecentTableViewCell.h"
#import "RecentViewController.h"
const CGFloat CellHeight = 50;

@interface BaseVideoListViewController ()<UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIButton *deleteAllButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutConstraint;

@property (strong, nonatomic) UIButton* editButton;

@end

@implementation BaseVideoListViewController

- (void)dealloc{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

- (instancetype)init{
    return [super initWithNibName:@"BaseVideoListViewController" bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.editing = NO;
    self.view.backgroundColor = klightGrayColor;

    
    [self.tableView registerNib:[UINib nibWithNibName:cRecentListCellID bundle:nil] forCellReuseIdentifier:cRecentListCellID];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setEditing:NO animated:NO];

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = kTabLineColor;
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mineBackground"]];
    imageView.contentMode = UIViewContentModeTop;
    [self.view insertSubview:imageView atIndex:0];
    imageView.frame = self.view.bounds;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    [self.selectAllBtn setImage:[UIImage imageNamed:@"对勾.png"] forState:UIControlStateSelected];
    [self.selectAllBtn setImage:[UIImage imageNamed:@"未选中.png"] forState:UIControlStateNormal];
    if (editing) {
        [self.editButton setImage:nil forState:UIControlStateNormal];
        [self.editButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.deleteView setHidden:NO];
//        self.deleteAllButton.hidden = NO;
        self.tableViewLayoutConstraint.constant = 44;
    }else{
        [self.editButton setTitle:@"删除" forState:UIControlStateNormal];
//        self.deleteAllButton.hidden = YES;
        [self.deleteView setHidden:YES];
        self.tableViewLayoutConstraint.constant = 0;
    }
}

- (UIView*)editView{
    if (!_editView) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton addTarget:self
                        action:@selector(p_updateEditing)
              forControlEvents:UIControlEventTouchUpInside];
        [_editButton setTitleColor:kNavTitleColor forState:UIControlStateNormal];
        [self.editButton setTitle:@"删除" forState:UIControlStateNormal];
        _editButton.titleLabel.font = [UIFont systemFontOfSize:16];
        
        
//        [_editButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        
        _editView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        _editView.backgroundColor = [UIColor clearColor];
        [_editView addSubview:_editButton];
        

        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
            _editButton.frame = CGRectMake(37, 0, 60, 44);
        }else{
            _editButton.frame = CGRectMake(47, 0, 60, 44);
        }

    }
    return _editView;
}
- (IBAction)selectAll:(id)sender {
    [self.selectAllBtn setSelected:!self.selectAllBtn.selected];
    [self.tableView reloadData];
}

- (IBAction)deleteButtonTapped:(id)sender {
    [self removeAllVideos];
}

- (IBAction)deleteAllVideoButtonTapped:(id)sender {
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"是否删除全部条目？" delegate:self
                                                    cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

#pragma mark - private
- (void)p_updateEditing{
//    [self setEditing:!self.editing animated:YES];
    self.editing = !self.editing;
    if (self.editing) {
        [self.editButton setImage:nil forState:UIControlStateNormal];
        [self.editButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.deleteView setHidden:NO];
        self.deleteAllButton.hidden = NO;
        self.tableViewLayoutConstraint.constant = 44;
    }else{
        [self.editButton setTitle:@"删除" forState:UIControlStateNormal];
        self.deleteAllButton.hidden = YES;
        [self.deleteView setHidden:YES];
        self.tableViewLayoutConstraint.constant = 0;
    }
    [self.tableView reloadData];
        
}
    
- (void)removeAllVideos{
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [self removeAllVideos];
    }
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.videosArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cRecentListCellID];
    if (self.editing) {
        [cell.selectedBtn setHidden:NO];
    }
    else
    {
        [cell.selectedBtn setHidden:YES];
    }
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CellHeight;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"全部清空";
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
        //YOUR_HEIGHT 为最高的那个headerView的高度
        CGFloat sectionHeaderHeight = CellHeight;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
EMPTY_TABLE_HEADER
@end
