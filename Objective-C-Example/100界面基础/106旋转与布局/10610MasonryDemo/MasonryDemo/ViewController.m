//
//  ViewController.m
//  MasonryDemo
//
//  Created by niit on 16/3/2.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"


// 定义之后可以不用带mas_前缀
#define MAS_SHORTHAND
// 定义之后equalTo等于mas_equalTo
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self test1];
}

- (void)test1
{
    UIView *blueView = [[UIView alloc] init];
    blueView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:blueView];
    
    // 尺寸:100*100
    // 位置:距离顶部和左边间距20
    
    // 写法1:
//    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@100);
//        make.height.equalTo(@100);
//        make.left.equalTo(self.view.mas_left).offset(20);
//        make.top.equalTo(self.view.mas_top).offset(20);
//    }];
    
    // 写法2:
//    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(100);// mas_equalTo 与 equalTo 区别
//        make.height.mas_equalTo(100);
//        make.left.equalTo(self.view.mas_left).offset(20);
//        make.top.equalTo(self.view.mas_top).offset(20);
//    }];
    
    // 写法3:
//    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
//        // 宽高同时
//        make.width.height.mas_equalTo(100);
//        make.left.equalTo(self.view.mas_left).offset(20);
//        make.top.equalTo(self.view.mas_top).offset(20);
//    }];
    
    // 写法4:
//    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
//        // 宽高同时
//        make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(100, 100)]);
////        make.size.mas_equalTo(CGSizeMake(100, 100));// 写法5
////        make.size.mas_equalTo(100);// 写法6
//        make.left.equalTo(self.view.mas_left).offset(20);
//        make.top.equalTo(self.view.mas_top).offset(20);
//    }];
    
    // 用法7:
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.view).multipliedBy(0.5).offset(-100);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.view.mas_top).offset(20);
    }];
}

// 1. 创建约束
//- (NSArray *)mas_makeConstraints:(void(^)(MASConstraintMaker *))block;
// 2. 更新约束(覆盖之前的约束)
//- (NSArray *)mas_updateConstraints:(void(^)(MASConstraintMaker *))block;
// 3. 删除已有约束，创建新约束
//- (NSArray *)mas_remakeConstraints:(void(^)(MASConstraintMaker *make))block;

// mas_equalTo 与 equalTo 区别
// mas_equalTo 会将参数包装成对象

//equalTo
//greaterThanOrEqualTo
//lessThanOrEqualTo

// 约束的类型
// 尺寸:width height
// 边界:left\leading\right\trailing\top\bottom


@end
