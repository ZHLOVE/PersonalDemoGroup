//
//  AddViewController.m
//  60004TextBook
//
//  Created by student on 16/3/7.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "AddViewController.h"



@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *noteTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *noteDetailTextField;
@property (weak, nonatomic) IBOutlet UILabel *DateTimeLabel;

@property (nonatomic,strong)NSMutableDictionary *noteMuDict;
@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noteMuDict = [NSMutableDictionary dictionary];
    self.DateTimeLabel.text = [self time];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveBtnPresed:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (NSString *)time{
    NSDate *now = [NSDate date];
    NSDateFormatter *time = [[NSDateFormatter alloc] init];
    [time setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [time stringFromDate:now];
    return dateStr;
}

- (void)save{
    [self.noteMuDict setObject:self.noteTitleTextField.text forKey:@"title"];
    [self.noteMuDict setObject:self.DateTimeLabel.text forKey:@"time"];
    [self.noteMuDict setObject:self.noteDetailTextField.text forKey:@"detail"];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *mArray = [NSMutableArray array];
    mArray = [[userDefault objectForKey:@"NoteBook"] mutableCopy];
    
    if (mArray == nil) {
        NSMutableArray *newArray = [NSMutableArray array];
        [newArray addObject:[self.noteMuDict copy]];
        [userDefault setObject:[newArray copy] forKey:@"NoteBook"];
        [userDefault synchronize];
    }else{
        [mArray addObject:[self.noteMuDict copy]];
        [userDefault setObject:[mArray copy] forKey:@"NoteBook"];
        [userDefault synchronize];
    }
}

//保存按钮
- (IBAction)saveBtnPresed:(UIButton *)sender {
    if (self.noteTitleTextField.text.length == 0) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"写上标题!" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"寡人知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertControl addAction:alertAction];
        [self presentViewController:alertControl animated:YES completion:nil];
    }else{
        [self save];
    }
}


// 触摸开始的时候触发的方法，当前视图属于UIView类,UIView从UIResponder继承了这个方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 关闭键盘
    [self.view endEditing:YES];
}


@end
