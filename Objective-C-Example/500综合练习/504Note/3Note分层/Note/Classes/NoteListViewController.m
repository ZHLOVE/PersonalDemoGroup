//
//  NoteListViewController.m
//  Note
//
//  Created by niit on 16/3/16.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "NoteListViewController.h"

#import "NoteModel.h"
#import "NoteGroup.h"
#import "AddNoteViewController.h"

@interface NoteListViewController ()<AddNoteViewControllerDelegate>

@property (nonatomic,weak) NSMutableArray *noteList;

@property (nonatomic,strong) NSIndexPath *curSel;

@end

@implementation NoteListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.noteList = [NoteGroup sharedNoteGroup].noteList;
}

// 传递数据给下一个页面
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddNoteViewController *destVC = segue.destinationViewController;
    destVC.delegate = self;
    
    if([segue.identifier isEqualToString:@"goEdit"])
    {
        NoteModel *m = self.noteList[self.curSel.row];
        destVC.note = m;
    }
}

- (IBAction)editBtnPressed:(id)sender
{
    // 切换表格编辑状态
    self.tableView.editing = !self.tableView.editing;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.noteList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NoteModel *m = self.noteList[indexPath.row];
    
    // 标题
    cell.textLabel.text = m.title;
    // 内容
    cell.detailTextLabel.text = m.content;
    // 时间
    if(cell.accessoryView == nil)
    {
        cell.accessoryView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80,40)];
    }
    UILabel *label = cell.accessoryView;
    // NSDate -> NSString
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterShortStyle;
    df.timeStyle = NSDateFormatterNoStyle;
    label.text = [df stringFromDate:m.time];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        // 数据层数据要删除        
        [[NoteGroup sharedNoteGroup] removeNoteByIndex:indexPath.row];
        // 表格删除行
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// 因为prepareForSegue 发生在didSelectRow之前，所以不能用didSelectRow来记录用户点了哪行,而是在willSelect里记录
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 记录当前用户将要点了哪行
    self.curSel = indexPath;
    return indexPath;
}

#pragma mark -
- (void)refresh
{
    // 刷新数据
    [self.tableView reloadData];
}

@end

