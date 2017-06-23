//
//  ViewControllerB.m
//  TransValue
//
//  Created by niit on 16/2/25.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewControllerB.h"

@interface ViewControllerB ()

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation ViewControllerB

- (void)loadView
{
    [super loadView];
    NSLog(@"%s",__func__);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"%s",__func__);
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.resultLabel.text = [NSString stringWithFormat:@"用户名:%@密码:%@\n%@",self.username,self.password,                             [self.username isEqualToString:@"admin"]&&[self.password isEqualToString:@"123456"]?@"登陆成功":@"登陆失败"];
//    if(self.username.)
}

- (IBAction)cancelBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
