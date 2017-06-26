//
//  PresidentDetailTableViewController.m
//  11210
//
//  Created by student on 16/3/7.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "PresidentDetailTableViewController.h"

@interface PresidentDetailTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *fromTextField;
@property (weak, nonatomic) IBOutlet UITextField *toTextField;
@property (weak, nonatomic) IBOutlet UITextField *partyTextField;

@end

@implementation PresidentDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.nameTextField.text = self.pre.name;
    self.fromTextField.text = self.pre.fromYear;
    self.toTextField.text = self.pre.toYear;
    self.partyTextField.text = self.pre.party;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveBtnPressed:(id)sender {
    self.pre.name = self.nameTextField.text;
   self.pre.fromYear = self.fromTextField.text;
    self.pre.toYear = self.toTextField.text;
    self.pre.party= self.partyTextField.text;
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate refresh];
}


#pragma mark - Table view data source




@end
