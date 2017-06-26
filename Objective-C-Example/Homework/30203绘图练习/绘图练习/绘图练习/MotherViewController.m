//
//  MotherViewController.m
//  绘图练习
//
//  Created by student on 16/4/6.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "MotherViewController.h"

#import "PicViewController.h"
@interface MotherViewController ()

@end

@implementation MotherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)btnMother1:(id)sender {
    PicViewController *picVC = [[PicViewController alloc] init];
    picVC.faceNum = 1;
    [self presentViewController:picVC animated:YES completion:nil];
    
}

- (IBAction)btnMother2:(id)sender {
    PicViewController *picVC = [[PicViewController alloc] init];
    picVC.faceNum = 2;
    [self presentViewController:picVC animated:YES completion:nil];
}

- (IBAction)btnMother3:(id)sender {
    PicViewController *picVC = [[PicViewController alloc] init];
    picVC.faceNum = 3;
    [self presentViewController:picVC animated:YES completion:nil];
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
