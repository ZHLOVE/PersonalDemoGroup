//
//  ViewController.m
//  ChinaArea
//
//  Created by niit on 16/3/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "ChinaArea.h"

@interface ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) NSArray *provinces;
@property (nonatomic,strong) NSArray *cities;
@property (nonatomic,strong) NSArray *zones;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.provinces = [ChinaArea provinces];
    
    self.cities = [ChinaArea citsForProvince:self.provinces[0]];
    
    self.zones = [ChinaArea zoneForProvince:self.provinces[0] andCity:self.cities[0]];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==0)
    {
        return self.provinces.count;
    }
    else if(component == 1)
    {
        return self.cities.count;
    }
    else
    {
        return self.zones.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component==0)
    {
        return self.provinces[row];
    }
    else if(component == 1)
    {
        return self.cities[row];
    }
    else
    {
        return self.zones[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0)
    {
        NSString *curProvince = self.provinces[row];
        self.cities = [ChinaArea citsForProvince:curProvince];
        self.zones = [ChinaArea zoneForProvince:curProvince andCity:self.cities[0]];
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    else if(component == 1)
    {
        NSString *curProvince = self.provinces[[pickerView selectedRowInComponent:0]];
        NSString *curCity = self.cities[row];
        self.zones = [ChinaArea zoneForProvince:curProvince andCity:curCity];
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
}

@end
