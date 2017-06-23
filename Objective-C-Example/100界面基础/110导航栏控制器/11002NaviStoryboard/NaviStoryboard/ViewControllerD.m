//
//  ViewControllerD.m
//  NaviStoryboard
//
//  Created by niit on 16/2/26.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewControllerD.h"

@interface ViewControllerD ()

@end

@implementation ViewControllerD

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
