//
//  ViewController.h
//  UIView
//
//  Created by qiang on 16/1/29.
//  Copyright © 2016年 Qiangtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *redView;

// 隐藏
@property (weak, nonatomic) IBOutlet UIButton *hideBtn;
- (IBAction)hideBtnPressed:(id)sender;

// 置前
- (IBAction)bringFront:(id)sender;
// 置后
- (IBAction)sendBack:(id)sender;

// 变色
- (IBAction)changeColor:(id)sender;

@end

