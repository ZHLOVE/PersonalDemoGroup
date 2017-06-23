//
//  NoteListViewController.m
//  Note
//
//  Created by niit on 16/3/16.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "NoteListViewController.h"

#import "NoteModel.h"
#import "AddNoteViewController.h"

@interface NoteListViewController ()<AddNoteViewControllerDelegate>

@property (nonatomic,strong) NSMutableArray *noteList;

@property (nonatomic,strong) NSIndexPath *curSel;

@end

@implementation NoteListViewController

- (NSMutableArray *)noteList
{
    if(_noteList == nil)
    {
        _noteList = [NSMutableArray array];
        
        NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
        NSArray *arr = [d objectForKey:@"noteList"];
        if(arr != nil)
        {
            for (NSDictionary *dict in arr)
            {
                NoteModel *n = [NoteModel noteWithDict:dict];
                [_noteList addObject:n];
            }
        }
    }
    return _noteList;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //self.noteList = [NSMutableArray array];
}

- (void)saveData
{
    //self.noteList 对象数组 -> 字典数组
    NSMutableArray *mArr = [NSMutableArray array];
    for (NoteModel *m in self.noteList)
    {
        NSDictionary *d  = @{@"title":m.title,@"content":m.content,@"time":m.time};
        [mArr addObject:d];
    }
    
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [d setObject:mArr forKey:@"noteList"];
    [d synchronize];
}

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
    // 
    cell.detailTextLabel.text = m.content;
    
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
        // 数据要删除
        [self.noteList removeObjectAtIndex:indexPath.row];
        // 保存
        [self saveData];
        // 表格删除行
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// 因为prepareForSegue 发生在didSelectRow之前，所以不能用didSelectRow来记录用户点了哪行
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 记录当前用户将要点了哪行
    self.curSel = indexPath;
    return indexPath;
}

#pragma mark -
- (void)addNoteWithTitle:(NSString *)title andContent:(NSString *)content
{
    NoteModel *m = [[NoteModel alloc] init];
    m.title = title;
    m.content = content;
    m.time = [NSDate date];
    
    [self.noteList insertObject:m atIndex:0];
    [self saveData];
    [self.tableView reloadData];
}

- (void)refresh
{
    [self saveData];
    [self.tableView reloadData];
}

@end

