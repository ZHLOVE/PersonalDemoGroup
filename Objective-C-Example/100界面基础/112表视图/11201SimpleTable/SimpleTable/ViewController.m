//
//  ViewController.m
//  SimpleTable
//
//  Created by niit on 16/3/3.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *list;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.list = @[@"起床",@"刷牙",@"吃早饭",@"到学校",@"上课",@"吃午饭",@"起床",@"刷牙",@"吃早饭",@"到学校",@"上课",@"吃午饭",@"起床",@"刷牙",@"吃早饭",@"到学校",@"上课",@"吃午饭",@"起床",@"刷牙",@"吃早饭",@"到学校",@"上课",@"吃午饭",@"起床",@"刷牙",@"吃早饭",@"到学校",@"上课",@"吃午饭"];
    
    
    // 表格的相关属性
    
    // 分割线样式
    // 1. 隐藏分隔线
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 2. 分隔线颜色
    self.tableView.separatorColor = [UIColor redColor];
    
    // 设置整个表格里每行的高度
    self.tableView.rowHeight = 100;
    
}

#pragma mark - 为表格提供数据(表格本身只负责绘制的工作。它会来调用这些方法.)
// 有几段?
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"表格:有几段?");
    return 1;
}

// 有几行？
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"表格:有几行?");
    return self.list.count;
}

// 第几段第几行的单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"表格:第%lu行是什么内容?",indexPath.row);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];// 查找已移除屏幕的单元格，进行复用
    if(cell == nil)
    {
        static int count = 0;
        NSLog(@"新建了%i个单元格",++count);
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    // UITableViewCell的三个默认属性:
    // 1. 文本标签 textLabel
    cell.textLabel.text = self.list[indexPath.row];
    // 2. 图片视图 imageView
    cell.imageView.image = [UIImage imageNamed:@"star"];
    cell.imageView.highlightedImage = [UIImage imageNamed:@"star2"];
    // 3. 副文本标签 detailLabel
    cell.detailTextLabel.text = [NSString stringWithFormat:@"测试%lu",indexPath.row];
    
    // 默认样式 UITableViewCellStyleDefault,
    // 带副标题样式1 UITableViewCellStyleValue1 副标题在最右侧
    // 带副标题样式2 UITableViewCellStyleValue2 不显示图片
    // 带副标题样式3 UITableViewCellStyleSubtitle	副标题在第二行
    
    // 默认的背景色
//    cell.backgroundColor = [UIColor blueColor];
    
    // 选中的样式
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 右边的箭头
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    UITableViewCellAccessoryNone,                                                      // don't show any accessory view
//    UITableViewCellAccessoryDisclosureIndicator,                                       // regular chevron. doesn't track
//    UITableViewCellAccessoryDetailDisclosureButton __TVOS_PROHIBITED,                 // info button w/ chevron. tracks
//    UITableViewCellAccessoryCheckmark,                                                 // checkmark. doesn't track
//    UITableViewCellAccessoryDetailButton NS_ENUM_AVAILABLE_IOS(7_0)  __TVOS_PROHIBITED // info button. tracks
    
    // 右边的视图自定义
    cell.accessoryView = [[UISwitch alloc] init];
    
    return cell;
}

// 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row %2 == 0)
    {
        return 50;
    }
    else
    {
        return 100;
    }
}

#pragma mark - 为表格提供事件处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    // 使用UIAlertController 替代 UIAlertView UIActionSheet
    
    // 1. 创建UIAlertController弹框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你要干啥去?" message:self.list[row] preferredStyle:UIAlertControllerStyleAlert];
    // 样式:
//    UIAlertControllerStyleActionSheet = 0, 弹出操作表
//    UIAlertControllerStyleAlert            弹出消息框
    
    // 2. 添加确定按钮
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action];
    
    // 3. 弹出
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
