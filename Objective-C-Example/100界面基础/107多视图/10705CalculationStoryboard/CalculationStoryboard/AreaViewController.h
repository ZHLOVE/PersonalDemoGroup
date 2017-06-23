//
//  AreaViewController.h
//  Calculation
//
//  Created by niit on 16/2/22.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *widthTextField;
@property (weak, nonatomic) IBOutlet UITextField *heightTextField;
@property (weak, nonatomic) IBOutlet UITextField *rectangleAreaTextField;

@property (weak, nonatomic) IBOutlet UITextField *rediusTextField;
@property (weak, nonatomic) IBOutlet UITextField *circleAreaTextField;

- (IBAction)calBtnPressed:(id)sender;

@end
