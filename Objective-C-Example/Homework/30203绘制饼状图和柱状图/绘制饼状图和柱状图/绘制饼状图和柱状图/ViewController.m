//
//  ViewController.m
//  绘制饼状图和柱状图
//
//  Created by student on 16/4/6.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

#import "DrawView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet DrawView *drawView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *list = @[@{@"text":@"iOS",@"percent":@.40},
                      @{@"text":@"Android",@"percent":@.55},
                      @{@"text":@"其他",@"percent":@.05}];
    self.drawView.list = list;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.drawView.type = !self.drawView.type;
    NSMutableArray *mArr = [NSMutableArray array];
    int all = 0;
    for (int i=0; i<10; i++) {
        // 随机百分比
        CGFloat percent = arc4random_uniform(80);
        //如果超出则设置为剩余
        if (all+percent>100) {
            percent = 100 - all;
        }
        NSDictionary *dict = @{@"text":[NSString stringWithFormat:@"类型%i",i],@"percent":@(percent/100.0)};
        [mArr addObject:dict];
        all+=percent;
        if (all>=100) {
            break;
        }
    }
//    NSLog(@"%@",mArr);
    self.drawView.list = mArr;
}





























@end
