//
//  MSCameraViewController_OC.h
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 29/10/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSimpleCamera.h"

@interface MSCameraViewController_OC : UIViewController

@property (strong, nonatomic) LLSimpleCamera *camera;

-(void)hideNavigationController;

- (void)snapButtonPressed:(UIButton *)button;
- (void)albumButtonPressed:(UIButton *)button;
- (void)backButtonPressed:(UIButton *)button;

@end
