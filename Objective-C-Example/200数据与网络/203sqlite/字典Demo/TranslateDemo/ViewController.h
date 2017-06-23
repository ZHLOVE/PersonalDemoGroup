//
//  ViewController.h
//  TranslateDemo
//
//  Created by Qiang on 15/4/13.
//  Copyright (c) 2015年 QiangTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *sourceTextField;
- (IBAction)btnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;

@end

