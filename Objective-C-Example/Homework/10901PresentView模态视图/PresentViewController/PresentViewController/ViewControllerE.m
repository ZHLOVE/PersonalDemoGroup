//
//  ViewControllerE.m
//  PresentViewController
//
//  Created by student on 16/2/24.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewControllerE.h"

@interface ViewControllerE ()

@end

@implementation ViewControllerE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancelBtnPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
