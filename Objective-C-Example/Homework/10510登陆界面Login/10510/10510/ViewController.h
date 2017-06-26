//
//  ViewController.h
//  10510
//
//  Created by 马千里 on 16/2/21.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *subUiView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPaswdTextField;

@property (weak, nonatomic) IBOutlet UITextField *verCode;



@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
- (IBAction)signInBtnPressed:(UIButton *)sender;


@end

