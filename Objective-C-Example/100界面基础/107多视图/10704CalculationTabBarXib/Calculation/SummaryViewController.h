//
//  SummaryViewController.h
//  Calculation
//
//  Created by niit on 16/2/22.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryViewController : UIViewController

// 方式2:
//1 创建一个属性
//2 其他控制器创建指向本视图控制器对象的弱引用
//3 把本视图控制器的对象赋值给其他控制器的弱引用
//4 其他视图控制器如果要修改,则通过弱引用直接访问修改
//注意问题:不要直接修改界面对象
@property (nonatomic,assign) int calCount;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


@end
