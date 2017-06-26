//
//  ViewControllerB.h
//  PresentViewController
//
//  Created by student on 16/2/24.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerB : UIViewController

@property (nonatomic,assign) int num;

@property (weak, nonatomic) IBOutlet UILabel *resuleLabel;



- (IBAction)cancelBtnPressed:(UIButton *)sender;



@end
