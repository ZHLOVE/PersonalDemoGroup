//
//  CitysViewController.m
//  10803省市PickerView
//
//  Created by student on 16/2/24.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "CitysViewController.h"

@interface CitysViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

//所有省会名字
@property(nonatomic,strong) NSArray *provinces;
// 保存所有城市名字
@property(nonatomic,strong) NSArray *cities;

@end

@implementation CitysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 得到左侧一列数据
    self.provinces = [[ChinaArea provinces] copy];
//    NSLog(@"%@",self.provinces[12]);
    // 右侧一列数据
    NSString *curState = self.provinces[0];
    self.cities = [ChinaArea citiesForProvince:curState];
//    NSLog(@"%@",self.cities[5]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.provinces.count;

    }else{
        return self.cities.count;

    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView
                      titleForRow:(NSInteger)row
                     forComponent:(NSInteger)component{
    
    if(component == 0)
    {
        return self.provinces[row];
       
    }
    else
    {
        return self.cities[row];

    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    int sel_1 = [self.citysPickView selectedRowInComponent:0];
    int sel_2 = [self.citysPickView selectedRowInComponent:1];
    
    if (component == 0) {
        NSString *curProvice = self.provinces[row];
        self.cities = [ChinaArea citiesForProvince:curProvice];
        [self.citysPickView reloadComponent:1];
        [self.citysPickView selectRow:0 inComponent:1 animated:YES];
        self.cityInfoLabel.text = [NSString stringWithFormat:@"%@%@",self.provinces[sel_1],self.cities[0]];
    }else{
        
        self.cityInfoLabel.text = [NSString stringWithFormat:@"%@%@",self.provinces[sel_1],self.cities[sel_2]];
    }
}


@end
