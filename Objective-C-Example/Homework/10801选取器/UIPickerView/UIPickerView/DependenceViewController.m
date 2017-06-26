//
//  DependenceViewController.m
//  UIPickerView
//
//  Created by student on 16/2/24.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "DependenceViewController.h"
#import "StateZips.h"

@interface DependenceViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) NSDictionary *stateZips;
@property (nonatomic,strong) NSArray *states; //城市名字的数组
@property (nonatomic,strong) NSArray *zips; //当前选中城市的邮编数组

@end

@implementation DependenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //得到左侧一列
    self.states = [StateZips states];
    //右侧一列
    NSString *curState = self.states[0];
    self.zips = self.stateZips[curState];
    
//    // 1 处理数据
//    // 1.1 读出所有城市邮编信息
//
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"statedictionary" ofType:@"plist"];
//    
//    self.stateZips = [NSDictionary dictionaryWithContentsOfFile:path];
//    
////    NSLog(@"%@",self.stateZips);
//      // 1.2 得到所有城市的名字数组
//    self.states = [[self.stateZips allKeys] sortedArrayUsingSelector:@selector(compare:)];
//    // 1.3 得到当前城市的邮编数组
//    // 当前城市名字
//    NSString *curState = self.states[0];
//     // 使用城市名字从self.stateZips中取出当前城市的邮编数组
//    self.zips = self.stateZips[curState];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnPressed:(UIButton *)sender{
    // 得到
    NSInteger sel1 = [self.pickView selectedRowInComponent:0];
    NSInteger sel2 = [self.pickView selectedRowInComponent:1];
    
    self.infoLabel.text =[NSString stringWithFormat:@"当前选中的是:%@城市的%@邮编",self.states[sel1],self.zips[sel2]];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0 ) {
        return self.states.count;
        
    }else{
        return self.zips.count;
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0 ) {
        return self.states[row];
        
    }else{
        return self.zips[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0 ) {
        //当前城市名字
        NSString *curState = self.states[row];
        //取出当前城市的邮编数组
        self.zips = self.stateZips[curState];
        //更新右侧一列界面
        [self.pickView reloadComponent:1];
        //重新滑动到第一行
        [self.pickView selectRow:0 inComponent:1 animated:YES];
    }else{
        self.infoLabel.text = [NSString stringWithFormat:@"邮编是:%@",self.zips[row]];
    }
}

@end
