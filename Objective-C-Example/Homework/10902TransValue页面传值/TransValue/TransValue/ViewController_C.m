//
//  ViewController_C.m
//  TransValue
//
//  Created by student on 16/2/25.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController_C.h"

@interface ViewController_C ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;

@end

@implementation ViewController_C

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerBtnPressed:(UIButton *)sender {
    NSString *username = self.userNameTextField.text;
    NSString *password = self.passwdTextField.text;
    NSString *email = self.emailTextField.text;
    
    [self.delegate transUserName:username
                     andPassword:password
                        andEmail:email];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userNameTextField resignFirstResponder];
    [self.passwdTextField resignFirstResponder];
}


@end
