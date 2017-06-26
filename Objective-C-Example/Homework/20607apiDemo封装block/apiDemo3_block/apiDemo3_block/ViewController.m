//
//  ViewController.m
//  apiDemo3_block
//
//  Created by student on 16/3/29.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

#import "NetManageer.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activeView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)btnPressed:(UIButton *)sender {
    [self.activeView startAnimating];
    [NetManageer requestInfoByPersonId:self.idTextField.text successBlock:^(NSString *result) {
        self.textView.text = result;
        [self.activeView stopAnimating];
    } failBlock:^(NSError *error) {
        self.textView.text = [error localizedDescription];
        [self.activeView stopAnimating];
    }];
}
@end
