//
//  SingleViewController.m
//  UIPickerViewDemo
//
//  Created by niit on 16/2/23.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "SingleViewController.h"

@interface SingleViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) NSArray *list;

@end

@implementation SingleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 告诉PickerView谁为它提供数据信息,谁为他提供数据处理.如果xib或者storyboard里已拉线，则不需要代码指定
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    self.list = @[@"张三",@"李四",@"王五",@"赵六",@"乔布斯",@"李1",@"王2",@"赵3",@"张4",@"李5",@"王6",@"赵7",@"张8",@"李9"];
}

- (IBAction)btnPressed:(id)sender
{
    // selectedRowInComponent得到PickerView第几列选中了第几项
    int sel = [self.pickerView selectedRowInComponent:0];// 第0列选择了几项
    NSString *name = self.list[sel];// 通过第几项
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"选择了谁?" message:name delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

// 通过代理协议的方式为PikcerView提供数据以及事件处理 以下方法都是由PickerView对象来调用的。
#pragma mark UIPickerViewDataSource And Delegate Method

// 有几列?
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSLog(@"%s",__func__);
    return 1;// 当前就1列
}

// 第几列有几行?
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    NSLog(@"%s",__func__);
    return self.list.count;// 当前就一列,不需要判断传入的component,直接返回数组的数量
}

// 告诉pickView第几行是什么内容
- (nullable NSString *)pickerView:(UIPickerView *)pickerView
                      titleForRow:(NSInteger)row
                     forComponent:(NSInteger)component
{
    NSLog(@"%s 告诉pickerView的内容:%@",__func__,self.list[row]);
    return self.list[row];
}

// 选择pickView内容的时候触发的事件
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.infoLabel.text = self.list[row];
}

@end
