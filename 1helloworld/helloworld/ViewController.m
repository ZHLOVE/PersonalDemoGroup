//
//  ViewController.m
//  helloworld
//
//  Created by MBP on 2016/11/2.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>

@interface ViewController ()

@property(nonatomic,strong) NSString *string;


@end

@implementation ViewController

- (void)UIImageNamed {
  UIImage *imgJ = [UIImage imageNamed:@"IMG_0044"];
    UIImage *imgP = [UIImage imageNamed:@"IMG_0694"];
    NSLog(@"%@",imgJ);
    NSLog(@"%@",imgP);
}

/*
@"iPhone5,1" : @"iPhone 5 (A1428)",
@"iPhone5,2" : @"iPhone 5 (A1429/A1442)",
@"iPhone5,3" : @"iPhone 5c (A1456/A1532)",
@"iPhone5,4" : @"iPhone 5c (A1507/A1516/A1526/A1529)",
@"iPhone6,1" : @"iPhone 5s (A1453/A1533)",
@"iPhone6,2" : @"iPhone 5s (A1457/A1518/A1528/A1530)",
@"iPhone7,1" : @"iPhone 6 Plus (A1522/A1524)",
@"iPhone7,2" : @"iPhone 6 (A1549/A1586)",
@"iPhone8,1" : @"iPhone 6s",
@"iPhone8,2" : @"iPhone 6s Plus",
@"iPhone9,1" : @"iPhone 7 (A1660/A1779A1780)",
@"iPhone9,2" : @"iPhone 7 Plus (A1661/A1785/A1786)",
@"iPhone9,3" : @"iPhone 7 (A1778)",
@"iPhone9,4" : @"iPhone 7 Plus (A1784)",
 18020506879
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"hello mccRee");
    NSString *str = @"";
    for (int i = 0; i < 3; i++) {
        str = [str stringByAppendingFormat:@"%@%@%@",@"嘛",@"卖",@"批"];
    }
    NSLog(@"%@",str);


}














- (void)getPrivateProperty{
    unsigned int count = 0;

    Ivar *ivars =  class_copyIvarList(NSClassFromString(@"ViewController"), &count);
    Ivar ivar = ivars[0];
    NSLog(@"类的属性个数%u",count);
    const char * name = ivar_getName(ivar);
    NSLog(@"拿到属性名字:%s",name);
    NSCoder *code = [[NSCoder alloc]init];
    for (int i=0; i<count; i++) {
        //拿到属性
        Ivar tempIvar = ivars[i];
        //属性的名称
        const char * tempName = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:tempName];
        [code encodeObject:[self valueForKey:key] forKey:key];
    }
    free(ivars);//释放C语言指针
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
