//
//  ViewController.m
//  CADisplayLinkDemo
//
//  Created by student on 16/4/7.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

#import "DrawView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet DrawView *drawView;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnPressed:(id)sender {
    self.drawView.playing = !self.drawView.playing;
    [self.btn setTitle:self.drawView.playing?@"停止":@"开始" forState:UIControlStateNormal];
}

@end
