//
//  ViewController.m
//  ApiDemo
//
//  Created by niit on 16/3/28.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "NetManager.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UITextView *resultView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)btnPressed:(id)sender
{
    [self.activityView startAnimating];
    [NetManager requestInfoByPersonId:self.idTextField.text successBlock:^(NSString *result) {
        self.resultView.text = result;
        [self.activityView stopAnimating];
    } faiBlock:^(NSError *error) {
        self.resultView.text = [error localizedDescription];
        [self.activityView stopAnimating];
    }];
    
    
}

@end
