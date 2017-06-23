//
//  DependenceViewController.m
//  UIPickerViewDemo
//
//  Created by niit on 16/2/24.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "DependenceViewController.h"

@interface DependenceViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) NSDictionary *stateZips;
@property (nonatomic,strong) NSArray *states; // 城市名字的数组
@property (nonatomic,strong) NSArray *zips;// 当前选中城市的邮编数组

@end

@implementation DependenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 1 处理数据
    // 1.1 读出所有城市邮编信息
    NSString *path = [[NSBundle mainBundle] pathForResource:@"statedictionary" ofType:@"plist"];// 文件的路径
    self.stateZips = [NSDictionary dictionaryWithContentsOfFile:path];
    
    // 1.2 得到所有城市的名字数组
    self.states = [[self.stateZips allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    // 1.3 得到当前城市的邮编数组
    // 当前城市名字
    NSString *curState = self.states[0];
    // 使用城市名字从self.stateZips中取出当前城市的邮编数组
    self.zips = self.stateZips[curState];
    
}

- (IBAction)btnPressed:(id)sender;
{
    // 得到
    NSInteger sel1 = [self.pickView selectedRowInComponent:0];
    NSInteger sel2 = [self.pickView selectedRowInComponent:1];
    
    self.infoLabel.text =[NSString stringWithFormat:@"当前选中的是:%@城市的%@邮编",self.states[sel1],self.zips[sel2]];
}

#pragma mark - 为PickerView提供数据和事件处理
// 1. 有几列?
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// 2. 第几列有几行?
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
    {
        return self.states.count;
    }
    else
    {
        return self.zips.count;
    }
}

// 3. 第几列第几行是什么内容?
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
    {
        return self.states[row];
    }
    else
    {
        return self.zips[row];
    }
}

// 4. 当前滑动PickerView选项的时候触发的方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0)// 用户在改变左侧一列的数据的时候
    {
        // 1. 得到当前城市名字
        NSString *curState = self.states[row];
        // 2. 从self.stateZips中取出当前城市的邮编数组
        self.zips = self.stateZips[curState];
        
        // 3. 更新右侧一列的界面显示
        [self.pickView reloadComponent:1];
        // 4. 重新滑动到第一行
        [self.pickView selectRow:0 inComponent:1 animated:YES];
    }
    else
    {
        self.infoLabel.text = [NSString stringWithFormat:@"邮编是:%@",self.zips[row]];
    }
}

@end
