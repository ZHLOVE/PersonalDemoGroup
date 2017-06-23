//
//  AreaViewController.h
//  Calculation
//
//  Created by niit on 16/2/22.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SummaryViewController.h"

@interface AreaViewController : UIViewController

// 创建第三个视图控制器的弱引用,这样可以随时操作第三个页面
@property (nonatomic,weak) SummaryViewController *summaryVC;

@property (weak, nonatomic) IBOutlet UITextField *widthTextField;
@property (weak, nonatomic) IBOutlet UITextField *heightTextField;
@property (weak, nonatomic) IBOutlet UITextField *rectangleAreaTextField;

@property (weak, nonatomic) IBOutlet UITextField *rediusTextField;
@property (weak, nonatomic) IBOutlet UITextField *circleAreaTextField;

- (IBAction)calBtnPressed:(id)sender;

@end
