//
//  DependenceViewController.h
//  UIPickerViewDemo
//
//  Created by niit on 16/2/24.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

// DependenceViewController修改版
// 将数据的处理封装到StateZips类
@interface DependenceViewController2 : UIViewController

@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
- (IBAction)btnPressed:(id)sender;

@end
