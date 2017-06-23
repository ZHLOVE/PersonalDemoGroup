//
//  DoubleViewController.m
//  UIPickerViewDemo
//
//  Created by niit on 16/2/23.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "DoubleViewController.h"

@interface DoubleViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) NSArray *leftList;
@property (nonatomic,strong) NSArray *rightList;

@end

@implementation DoubleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pickView.dataSource = self;
    self.pickView.delegate = self;
    
    self.leftList = @[@"电视机",@"床",@"冰箱",@"电饭锅",@"沙发"];
    self.rightList = @[@"上面",@"下面",@"里面"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnPressed:(id)sender
{
    int sel1 = [self.pickView selectedRowInComponent:0];
    int sel2 = [self.pickView selectedRowInComponent:1];
    
    self.infoLabel.text =[NSString stringWithFormat:@"我的手机在%@%@",self.leftList[sel1],self.rightList[sel2]];
}

#pragma mark - 

// 有几列？
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// 第几列有几行?
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
    {
        return self.leftList.count;
    }
    else
    {
        return self.rightList.count;
    }
}

// 第几行第几列是什么内容
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
    {
        return self.leftList[row];
    }
    else
    {
        return self.rightList[row];
    }
}


// 触发的事件
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0)
    {
        NSLog(@"当前你选择了%@",self.leftList[row]);
    }
    else
    {
        NSLog(@"当前你选择了%@",self.rightList[row]);    }
}

@end
