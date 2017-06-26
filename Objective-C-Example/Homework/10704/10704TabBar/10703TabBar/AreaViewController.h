//
//  AreaViewController.h
//  10703TabBar
//
//  Created by student on 16/2/22.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *lengthTextField;
@property (weak, nonatomic) IBOutlet UITextField *widthTextField;
@property (weak, nonatomic) IBOutlet UITextField *rectangleAreaTextField;
@property (weak, nonatomic) IBOutlet UITextField *radiusTextField;
@property (weak, nonatomic) IBOutlet UITextField *circularTextField;
@property (weak, nonatomic) IBOutlet UIButton *resultBtn;



- (IBAction)resultBtnPressed:(UIButton *)sender;



@end
