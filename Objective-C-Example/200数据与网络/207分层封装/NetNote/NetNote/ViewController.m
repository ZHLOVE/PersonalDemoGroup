//
//  ViewController.m
//  NetNote
//
//  Created by niit on 16/4/5.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"
#import "NetManager.h"
#import "SVProgressHUD.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender
{
    NoteModel *note = [[NoteModel alloc] init];
    note.Content = self.textView.text;
    
    [SVProgressHUD showWithStatus:@"正在添加"];
    
    // 添加
    [NetManager addNote:note SuccessBlock:^{
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failBlock:^(NSError *error) {
        NSString *msg = [NSString stringWithFormat:@"%@",[error localizedDescription]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
}
@end
