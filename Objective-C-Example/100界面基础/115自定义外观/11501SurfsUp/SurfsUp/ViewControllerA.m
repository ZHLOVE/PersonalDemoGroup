//
//  ViewControllerA.m
//  SurfsUp
//
//  Created by niit on 16/3/10.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewControllerA.h"

@interface ViewControllerA ()
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation ViewControllerA

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    UIImage *minImage = [[UIImage imageNamed:@"slider_minimum"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    UIImage *maxImage = [[UIImage imageNamed:@"slider_maximum"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    UIImage *thumbImage = [UIImage imageNamed:@"thumb"];

    [self.slider setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [self.slider setThumbImage:thumbImage forState:UIControlStateNormal];
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

@end
