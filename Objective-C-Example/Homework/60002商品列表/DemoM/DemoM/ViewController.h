//
//  ViewController.h
//  DemoM
//
//  Created by student on 16/2/26.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (weak, nonatomic) IBOutlet UIButton *removeBtn;

@property (weak, nonatomic) IBOutlet UIView *uiViewLoadImages;


- (IBAction)addBtnPressed:(UIButton *)sender;

- (IBAction)removeBtnPressed:(UIButton *)sender;

@end

