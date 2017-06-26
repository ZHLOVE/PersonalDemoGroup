//
//  ViewController.m
//  SimpleTable
//
//  Created by student on 16/3/3.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSArray *list;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.list = @[@"起床",@"刷牙",@"吃早饭",@"到学校",@"上课",@"吃午饭",@"起床",@"刷牙",@"吃早饭",@"到学校",@"上课",@"吃午饭",@"起床",@"刷牙",@"吃早饭",@"到学校",@"上课",@"吃午饭",@"起床",@"刷牙",@"吃早饭",@"到学校",@"上课",@"吃午饭",@"起床",@"刷牙",@"吃早饭",@"到学校",@"上课",@"吃午饭"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//有几段
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"表格:第%ld行是什么内容?",indexPath.row);
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    //UITableViewCell的三个默认属性:
    // 1. 文本标签 textLabel
    cell.textLabel.text = self.list[indexPath.row];
    // 2. 图片视图imgView
    cell.imageView.image = [UIImage imageNamed:@"star"];
    cell.imageView.highlightedImage = [UIImage imageNamed:@"star2"];
    // 3. 副文本标签 detailLabel
    cell.detailTextLabel.text = [NSString stringWithFormat:@"测试%ld",indexPath.row];
    // 默认样式 UITableViewCellStyleDefault,
    // 带副标题样式1 UITableViewCellStyleValue1 副标题在最右侧
    // 带副标题样式2 UITableViewCellStyleValue2 不显示图片
    // 带副标题样式3 UITableViewCellStyleSubtitle	副标题在第二行
    
    return cell;
}

#pragma mark - 为表格提供时间处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"弄啥咧？" message:self.list[row] preferredStyle:UIAlertControllerStyleAlert];
    // 样式:
    //    UIAlertControllerStyleActionSheet = 0, 弹出操作表
    //    UIAlertControllerStyleAlert            弹出消息框
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"走你"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [self dismissViewControllerAnimated:YES completion:nil];}];
    //弹出alert
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
@end




















