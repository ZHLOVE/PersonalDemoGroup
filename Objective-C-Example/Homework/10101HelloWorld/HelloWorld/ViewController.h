//
//  ViewController.h
//  HelloWorld
//
//  Created by niit on 16/1/28.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

// 视图控制器类
@interface ViewController : UIViewController

//@property (nonatomic,strong) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UILabel *label;

@property(nonatomic,copy) NSString *name;


@end
