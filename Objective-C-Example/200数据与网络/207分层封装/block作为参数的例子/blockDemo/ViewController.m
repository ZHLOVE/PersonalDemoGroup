//
//  ViewController.m
//  blockDemo
//
//  Created by niit on 16/3/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "Person.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonnull,strong) NSMutableArray *personList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.personList = [NSMutableArray array];
    Person *p;
    p= [[Person alloc] init];
    p.name = @"小明";
    p.age = 11;
    p.height = 172;
    [self.personList addObject:p];
    p= [[Person alloc] init];
    p.name = @"张三";
    p.age = 12;
    p.height = 173;
    [self.personList addObject:p];
    p= [[Person alloc] init];
    p.name = @"李四";
    p.age = 13;
    p.height = 174;
    [self.personList addObject:p];
    p= [[Person alloc] init];
    p.name = @"王五";
    p.age = 14;
    p.height = 175;
    [self.personList addObject:p];
    p= [[Person alloc] init];
    p.name = @"赵六";
    p.age = 15;
    p.height = 176;
    [self.personList addObject:p];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    // 1.
//    [self repeat:^{
//        self.textView.text = [self.textView.text stringByAppendingString:@"haha\n"];
//    } forTime:10];
    
    // 2.
//    [self repeatStr:^(NSString *str) {
//        self.textView.text = [self.textView.text stringByAppendingString:str];
//    } forTime:10];
    
    // 3.
    NSArray *resultArr = [self findPersonBy:^BOOL(Person *person) {
        if(person.age<12 && person.height >170)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }];
    
    // 显示符合条件的学生
    for (int i=0;i<resultArr.count;i++)
    {
        Person *p = resultArr[i];
        NSLog(@"%@:年龄:%i高度%i",p.name,p.age,p.height);
    }
    
}

//void (^)() 无参数无返回值的block类型
//void (^)(NSString *) NSString型参数无返回值block类型
//BOOL (^)(Person *) 参数是Person 返回值是BOOL类型的block

// 1.
- (void)repeat:(void (^)())aBlock // 传入一个无参数无返回值的block
       forTime:(int)n
{
    for (int i=0; i<n; i++)
    {
        aBlock();
    }
}

// 2.
- (void)repeatStr:(void (^)(NSString *))aBlock // 传入一个有参数无返回值的block
       forTime:(int)n
{
    for (int i=0; i<n; i++)
    {
        NSString *result = [NSString stringWithFormat:@"%i\n",i];
        aBlock(result);
    }
}

// 2.
- (NSArray *)findPersonBy:(BOOL (^)(Person *))block
{
    NSMutableArray *mArr = [NSMutableArray array];
    for(int i=0;i<self.personList.count;i++)
    {
        Person *p = self.personList[i];
        if(block(p))
        {
            [mArr addObject:p];
        }
    }
    return mArr;
}




@end
