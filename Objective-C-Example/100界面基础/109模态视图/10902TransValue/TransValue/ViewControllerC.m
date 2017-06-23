//
//  ViewControllerC.m
//  TransValue
//
//  Created by niit on 16/2/25.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewControllerC.h"

@interface ViewControllerC ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation ViewControllerC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)registerBtnPressed:(id)sender
{
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *email = self.emailTextField.text;
    
    NSLog(@"C:将数据传给代理人");
    [self.delegate transUserName:username
                     andPassword:password
                        andEmail:email];
    NSLog(@"C:关闭");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
