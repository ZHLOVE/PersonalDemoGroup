//
//  DoubleViewController.m
//  UIPickerView
//
//  Created by student on 16/2/23.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "DoubleViewController.h"

@interface DoubleViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) NSArray *leftList;
@property (nonatomic,strong) NSArray *rightList;


@end

@implementation DoubleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftList = @[@"电脑",@"手机",@"电视",@"冰箱",@"空调"];
    self.rightList = @[@"体积",@"重量",@"电量",@"使用时间",@"价格"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  }


- (IBAction)btnPressed:(UIButton *)sender {
    int sel1 = [self.pickView selectedRowInComponent:0];
    int sel2 = [self.pickView selectedRowInComponent:1];
    
//    self.infoLabel.text = [NSString stringWithFormat:@"我的%@的%@",self.leftList[sel1],self.rightList[sel2]];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.leftList.count;
    }else{
        return self.rightList.count;
    }
    
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return self.leftList[row];
    }else{
        return self.rightList[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{


    NSString *str = [[NSString alloc]init];
    int sel1 = [self.pickView selectedRowInComponent:0];
    int sel2 = [self.pickView selectedRowInComponent:1];
    
    str = [self.leftList[sel1] stringByAppendingString:self.rightList[sel2]];
    self.infoLabel.text = str;
    
}















@end
