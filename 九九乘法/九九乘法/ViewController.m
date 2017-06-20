//
//  ViewController.m
//  九九乘法
//
//  Created by MBP on 2016/11/9.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "ViewController.h"
#define width 65
#define heifht 25

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self nineChengnie];

}


-(void)nineChengnie{
    for (int x = 0; x < 9; x++) {
        for (int y = 9; y>x; y--) {
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(x * width, y * heifht, width, heifht)];
            lab.text = [NSString stringWithFormat:@"%dx%d=%d",x+1,y,(x+1)*y];
            lab.layer.borderColor = [[UIColor lightGrayColor]CGColor];
            lab.layer.borderWidth = 0.5f;
            lab.textAlignment = NSTextAlignmentCenter;
            lab.layer.masksToBounds = YES;
            lab.textColor = [UIColor blueColor];
            lab.font = [UIFont systemFontOfSize:12];
            [self.view addSubview:lab];

        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
