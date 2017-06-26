//
//  ViewController.h
//  ViewAndViewController
//
//  Created by niit on 16/1/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *redView;

@property (weak, nonatomic) IBOutlet UIButton *hideBtn;
- (IBAction)hideBtnPressed:(id)sender;


- (IBAction)bringFront:(id)sender;
- (IBAction)sendBack:(id)sender;

- (IBAction)changeColor:(id)sender;
@end

