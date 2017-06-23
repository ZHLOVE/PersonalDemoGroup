//
//  AreaViewController.m
//  Calculation
//
//  Created by niit on 16/2/22.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "AreaViewController.h"

// 外部变量
extern int calCount;

@interface AreaViewController ()

@end

@implementation AreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

// 关闭键盘
- (IBAction)backgroundTap:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)calBtnPressed:(id)sender
{
    float width = [self.widthTextField.text floatValue];
    float height = [self.heightTextField.text floatValue];
    float area1 = width *height;
    self.rectangleAreaTextField.text = [NSString stringWithFormat:@"%g",area1];
    
    float radius = [self.rediusTextField.text floatValue];
    float area2 = M_PI * radius * radius;
    self.circleAreaTextField.text = [NSString stringWithFormat:@"%g",area2];
    
    calCount++;
    
}
@end
