//
//  ViewController.m
//  11207
//
//  Created by student on 16/3/4.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"
#import "ChinaArea.h"


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) ChinaArea *area;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.area = [[ChinaArea alloc]init];
}

//有几段
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.area.provinces.count;
}

//有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *province = self.area.provinces[section];
    
    return [ChinaArea citiesForProvince:province].count;
}

//表头
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *province = self.area.provinces[section];
    
    return province;
}
//单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"表格:第%ld行是什么内容?",indexPath.row);
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
 
    // 1. 文本标签 textLabel
    NSString *province = self.area.provinces[indexPath.section];
    NSArray *city = [ChinaArea citiesForProvince:province];
//    NSLog(@"%@",city);
    cell.textLabel.text = city[indexPath.row];
  
    //  副文本标签 detailLabel
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"测试%ld",indexPath.row];
    // 默认样式 UITableViewCellStyleDefault,
    // 带副标题样式1 UITableViewCellStyleValue1 副标题在最右侧
    // 带副标题样式2 UITableViewCellStyleValue2 不显示图片
    // 带副标题样式3 UITableViewCellStyleSubtitle	副标题在第二行
    
    return cell;
}

//导航列表
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.area.provinces;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
