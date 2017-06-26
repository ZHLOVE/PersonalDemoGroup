//
//  SingleViewController.m
//  UIPickerView
//
//  Created by student on 16/2/23.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "SingleViewController.h"

@interface SingleViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) NSArray *list;

@end

@implementation SingleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.list = @[@"张三",@"小明",@"江苏",@"浙江",@"黑龙江",@"湖北",@"湖南",@"安徽",@"福建",@"江西",@"河北",@"河南",@"吉林",@"辽宁",@"内蒙古",@"新疆",@"西藏",@"云南",@"贵州",@"海南"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btnPressed:(UIButton *)sender {
    int sel = [self.pickerView selectedRowInComponent:0];//第0列选择了几项
    NSString *name = self.list[sel];//通过第几项
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"选择了谁" message:name delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}


// 有几列?
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return  1; //当前就一列
    
}


// 第几列有几行?
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.list.count;
}

// 告诉pickView第几行是什么内容
- (nullable NSString *)pickerView:(UIPickerView *)pickerView
                      titleForRow:(NSInteger)row
                     forComponent:(NSInteger)component{
    return self.list[row];
    
}

// 选择pickView内容的时候触发的事件
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.infoLabel.text = self.list[row];
}


@end
