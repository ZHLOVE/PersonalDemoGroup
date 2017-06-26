//
//  MainViewController.m
//  10703toolBar
//
//  Created by student on 16/2/22.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()




@end

@implementation MainViewController

- (AreaViewController *)areaVC{
    if (_areaVC == nil) {
        _areaVC = [[AreaViewController alloc]init];
    }
    return _areaVC;
}

- (VolumeViewController *)volumeVC{
    if (_volumeVC == nil) {
        _volumeVC = [[VolumeViewController alloc]init];
    }
    return _volumeVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self areaBtnItemPressed:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)areaBtnItemPressed:(UIBarButtonItem *)sender {
    [self.view insertSubview:self.areaVC.view atIndex:0];
    [self.volumeVC.view removeFromSuperview];
    
}
- (IBAction)volumeBtnItemPressed:(UIBarButtonItem *)sender {

    [self.view insertSubview:self.volumeVC.view atIndex:0];
    [self.areaVC.view removeFromSuperview];
//    NSLog(@"算体积");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
