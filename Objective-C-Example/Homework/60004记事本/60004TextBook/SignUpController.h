//
//  SignUpController.h
//  60004TextBook
//
//  Created by 马千里 on 16/3/13.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
- (IBAction)signUpBtnPress:(UIButton *)sender;

- (IBAction)cancelBtnPress:(UIButton *)sender;

@end
