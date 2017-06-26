//
//  ViewController.m
//  WebServiceDemo
//
//  Created by niit on 16/3/31.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "NetManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UITextView *resultView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnPressed:(id)sender
{
    [self.activityView startAnimating];
    [NetManager requestInfoByMobileId:self.idTextField.text successBlock:^(NSDictionary *dict) {
        self.resultView.text = [NSString stringWithFormat:@"状态:%@\n消息::%@\n省:%@\n市:%@",dict[@"status"],dict[@"message"],dict[@"province"],dict[@"city"]];
        [self.activityView stopAnimating];
    } failBlock:^(NSError *error) {
        self.resultView.text = [error localizedDescription];
        [self.activityView stopAnimating];
    }];
    
}

@end
