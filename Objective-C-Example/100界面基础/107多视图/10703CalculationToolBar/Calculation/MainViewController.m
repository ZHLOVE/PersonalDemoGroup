//
//  MainViewController.m
//  Calculation
//
//  Created by niit on 16/2/22.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "MainViewController.h"

#import "AreaViewController.h"
#import "VolumeViewController.h"

@interface MainViewController ()

@property (nonatomic,strong) AreaViewController *areaVC;
@property (nonatomic,strong) VolumeViewController *volumeVC;

@end



@implementation MainViewController

- (AreaViewController *)areaVC
{
    if(_areaVC == nil)
    {
        _areaVC = [[AreaViewController alloc] init];
    }
    return _areaVC;
}

- (VolumeViewController *)volumeVC
{
    if(!_volumeVC)
    {
        _volumeVC = [[VolumeViewController alloc] init];
    }
    return _volumeVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self showAreaCal:nil];
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
- (IBAction)showAreaCal:(id)sender
{
    [self.view insertSubview:self.areaVC.view atIndex:0];
    [self.volumeVC.view removeFromSuperview];
}
- (IBAction)showVolCal:(id)sender {
    [self.view insertSubview:self.volumeVC.view atIndex:0];
    [self.areaVC.view removeFromSuperview];
}


@end
