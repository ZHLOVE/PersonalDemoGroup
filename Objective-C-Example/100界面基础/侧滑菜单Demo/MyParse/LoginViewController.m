//
//  LoginViewController.m
//  MyParse
//
//  Created by niit on 16/4/20.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "LoginViewController.h"

#import "AppDelegate.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginBtnPressed:(id)sender
{
    if([self.nameTextField.text isEqualToString:@"jsp"] && [self.pwdTextField.text isEqualToString:@"888"])
    {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate loadMainController];
        
        NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
        [d setBool:YES forKey:@"logined"];
        [d synchronize];
    }
    else
    {
        
    }
}

@end
