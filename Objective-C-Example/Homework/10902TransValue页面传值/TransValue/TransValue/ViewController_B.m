//
//  ViewController_B.m
//  TransValue
//
//  Created by student on 16/2/25.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController_B.h"

@interface ViewController_B ()
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;


@end

@implementation ViewController_B

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.resultLabel.text = [NSString stringWithFormat:@"用户名:%@密码:%@\n%@",self.username,self.password,
                             [self.username isEqualToString:@"admin"]&&[self.password isEqualToString:@"123456"]?@"登陆成功":@"登陆失败"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
