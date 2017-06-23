//
//  ViewController.m
//  KVO_KVC_Play
//
//  Created by MBP on 2017/6/23.
//  Copyright © 2017年 leqi. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@property(nonatomic,strong) Person *p;

@property(nonatomic,strong) UIButton *myBtn;
@property(nonatomic,strong) UILabel *myLabel;

@end


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    /**
        KVC例子,通过key来给对象属性直接赋值
     */
    self.p = [[Person alloc]init];
    [self.p setValue:@"张三" forKey:@"name"];

    NSLog(@"%@",[self.p valueForKey:@"name"]);

    NSLog(@"%@",self.p.name);
    /**
        KVC 利用keyPath
     */
    Address *add = [[Address alloc]init];
    add.addStr = @"china";
    self.p.address = add;

    NSString *str = self.p.address.addStr;
    NSString *str2 = [self.p valueForKeyPath:@"address.addStr"];

    NSLog(@"%@~%@",str,str2);

    /**
        KVO建立在KVC之上
     */
    /*1.注册对象myKVO为被观察者:
     option中，
     NSKeyValueObservingOptionOld 以字典的形式提供 “初始对象数据”;
     NSKeyValueObservingOptionNew 以字典的形式提供 “更新后新的数据”;
     */
    [self.p addObserver:self forKeyPath:@"num" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];

}



/* 2.只要object的keyPath属性发生变化，就会调用此回调方法，进行相应的处理：UI更新：*/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"num"] && object == self.p) {
        self.myLabel.text = [NSString stringWithFormat:@"当前的num:%@",[change valueForKey:@"new"]];

        //上文注册时，枚举为2个，因此可以提取change字典中的新、旧值的这两个方法
        NSLog(@"\noldnum:%@ newnum:%@",[change valueForKey:@"old"],[change valueForKey:@"new"]);
    }
}


/* 3.移除KVO */
- (void)dealloc{
    [self.p removeObserver:self forKeyPath:@"num"];
}


- (void)setUpUI{
    [self.view addSubview:self.myBtn];
    [self.view addSubview:self.myLabel];
}


//按钮事件
- (void)changeNum:(UIButton *)sender {
    //按一次，使num的值+1
    self.p.num = self.p.num + 1;
}


- (UIButton *)myBtn{
    if (_myBtn == nil) {
        _myBtn = [[UIButton alloc]init];
        _myBtn.frame = CGRectMake(20, 300, 100, 30);
        _myBtn.backgroundColor = [UIColor lightGrayColor];
        [_myBtn setTitle:@"按钮" forState:UIControlStateNormal];
        [_myBtn addTarget:self action:@selector(changeNum:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myBtn;
}


- (UILabel *)myLabel{
    if (_myLabel == nil) {
        _myLabel = [[UILabel alloc]init];
        _myLabel.frame = CGRectMake(20, 150, 200, 30);
        _myLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _myLabel;
}


@end
