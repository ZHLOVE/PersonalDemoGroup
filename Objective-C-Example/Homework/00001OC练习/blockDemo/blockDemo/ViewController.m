//
//  ViewController.m
//  blockDemo
//
//  Created by niit on 16/3/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"
#import "FirstTimeConfig.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // block 一段代码块，存放代码
    // ^ block标识
    // 和函数很相似:
    // * 保存代码
    // * 有返回值
    // * 有形参
    // * 调用方式一样
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"%s",__func__);
//    
//    // 无参数无返回值的block值
//    ^()
//    {
//        NSLog(@"abc123");
//    };
//    
//    // block的变量(无参数无返回值block类型)
//    void (^aBlock)();
//    aBlock = ^()
//    {
//        NSLog(@"abc123");
//    };
//    
//    // 执行这个block,才会运行
//    aBlock();
//    
//    void (^bBlock)(int);// 有参数无返回值block变量
//    void (^cBlock)(int,int);// 有2个参数 无返回值block变量
//    int (^dBlock)(int,int);// 2个参数 返回值的block变量
//
//    bBlock = ^(int a)
//    {
//        NSLog(@"传入的值是:%i,平方是%i",a,a*a);
//    };
//    
//    bBlock(10);
    
    
//    [self repeat:^{
//        self.textView.text = [self.textView.text stringByAppendingString:@"haha\n"];
//    } forTime:10];
    
    [self repeatStr:^(NSString *str) {
        self.textView.text = [self.textView.text stringByAppendingString:str];
    } forTime:10];
    
}

//void (^)() 无参数无返回值的block类型
//void (^)(int) int型参数无返回值block类型
//void (^)(NSString *) NSString型参数无返回值block类型

// 将block作为函数或者方法的参数
- (void)repeat:(void (^)())aBlock // 传入一个无参数无返回值的block
       forTime:(int)n
{
    for (int i=0; i<n; i++)
    {
        aBlock();
    }
}

- (void)repeatStr:(void (^)(NSString *))aBlock // 传入一个有参数无返回值的block
       forTime:(int)n
{
    for (int i=0; i<n; i++)
    {
        NSString *result = [NSString stringWithFormat:@"%i\n",i];
        aBlock(result);
    }
}

@end
