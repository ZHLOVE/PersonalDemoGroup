//
//  MeViewController.m
//  60004TextBook
//
//  Created by student on 16/3/7.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "MeViewController.h"

#import "SignUpController.h"
@interface MeViewController ()




@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;


@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signInBtn.enabled = NO;
    self.signInBtn.alpha = 0.3;
    //添加text编辑事件，不为空，登陆才能点击
    [self.userNameTextField addTarget:self action:@selector(change) forControlEvents:UIControlEventEditingChanged];

}


- (IBAction)clearNote:(UIButton *)sender {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
     NSArray *tmpArray = [userDefault objectForKey:@"NoteBook"];
    NSMutableArray *mArray = [tmpArray mutableCopy];
    [mArray removeAllObjects];
    [userDefault setObject:[mArray copy] forKey:@"NoteBook"];
}

- (IBAction)signInBtnPressed:(UIButton *)sender {
   
    if ([self checkUserName:self.userNameTextField.text andPasswd:self.passwdTextField.text]) {
        [self stateSuccess];
    }else{
        [self stateFaild];
    }

}


- (IBAction)signUpBtnPressed:(UIButton *)sender {
//    NSLog(@"注册%s",__func__);
    SignUpController *signUp = [[SignUpController alloc]init];
    //模态窗口
    signUp.modalPresentationStyle = UIModalPresentationFullScreen;// iPhone只有全屏方式
    signUp.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:signUp animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)checkUserName:(NSString *)userName andPasswd:(NSString *)passwd{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userDefault objectForKey:@"account"];
    for (NSDictionary *d in array) {
            if ([d[@"userName"]isEqualToString:userName]) {
                return YES;
            }
    }
    
    return NO;
}
- (void)stateSuccess{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"登陆成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAlertAction = [UIAlertAction actionWithTitle:@"寡人知道了" style:UIAlertActionStyleDefault handler:nil];
    [alertControl  addAction:sureAlertAction];
    [self presentViewController:alertControl animated:YES completion:nil];
}

- (void)stateFaild{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"用户名或密码错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAlertAction = [UIAlertAction actionWithTitle:@"寡人知道了" style:UIAlertActionStyleDefault handler:nil];
    [alertControl  addAction:sureAlertAction];
    [self presentViewController:alertControl animated:YES completion:nil];
}

/**改变按钮状态*/
-(void)change
{
    if (self.userNameTextField.text.length > 0) {
        self.signInBtn.enabled = YES;
        self.signInBtn.alpha = 1;
    }else
    {
        self.signInBtn.enabled = NO;
        self.signInBtn.alpha = 0.3;
    }
    
}

@end
