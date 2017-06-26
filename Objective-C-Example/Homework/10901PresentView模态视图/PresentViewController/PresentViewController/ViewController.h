//
//  ViewController.h
//  PresentViewController
//
//  Created by student on 16/2/24.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)btnCPressed:(UIButton *)sender;

- (IBAction)btnDPressed:(UIButton *)sender;
- (IBAction)btnEPressed:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *infoTextFielld;

@end

