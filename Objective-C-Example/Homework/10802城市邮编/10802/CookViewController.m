//
//  CookViewController.m
//  10802
//
//  Created by 马千里 on 16/2/23.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "CookViewController.h"

@interface CookViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) NSArray *leftList;
@property (nonatomic,strong) NSArray *rightList;

@end

@implementation CookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftList = @[@"火腿",@"火鸡",@"金枪鱼",@"花生酱",@"鸡丁沙拉",@"烤牛肉"];
    self.rightList = @[@"白面包",@"粗粉面包",@"麦芽面包",@"酸面包",@"起司面包"];
    NSString *strChoose = [NSString stringWithFormat:@"选择%@和%@",self.leftList[0],self.rightList[0]];
    [self.btnChoose setTitle:strChoose forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



- (IBAction)btnPressed:(UIButton *)sender {
    NSMutableString *mStr = [sender.currentTitle mutableCopy];
    [mStr deleteCharactersInRange:NSMakeRange(0, 2)];
    self.infoLabel.text = [NSString stringWithFormat:@"我的早饭是%@",mStr];
}

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

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.leftList[row];
    }else{
        return self.rightList[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    int sel_1 = [self.pickerView selectedRowInComponent:0];
    int sel_2 = [self.pickerView selectedRowInComponent:1];
 
    NSString *strChoose = [NSString stringWithFormat:@"选择%@和%@",self.leftList[sel_1],self.rightList[sel_2]];
    [self.btnChoose setTitle:strChoose forState:UIControlStateNormal];
}





@end
