//
//  ViewController.h
//  PresentViewController
//
//  Created by niit on 16/2/24.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerA : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *numTextField;

- (IBAction)popCBtnPressed:(id)sender;

@end

