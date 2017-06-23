//
//  ViewController.m
//  FeedBackVC_Demo
//
//  Created by admin on 16/6/16.
//  Copyright © 2016年 AlezJi. All rights reserved.
//
//意见反馈页面

#import "ViewController.h"
#import "UIView+Ext.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define RGB(r, g, b) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) /255.0) alpha:1.0]


@interface ViewController ()<UITextViewDelegate,UIAlertViewDelegate>
@property(strong,nonatomic)UITextView *textView;
@property(strong,nonatomic)UILabel *placeHolderLabel;
@property(strong,nonatomic)UILabel *numLabel;
@property(strong,nonatomic)UIButton *saveBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

#pragma mark - initUI
-(void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _textView =[[UITextView alloc]initWithFrame:CGRectMake(10, 100, kScreenWidth-20, 100)];
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 5;
    _textView.layer.borderColor = [UIColor redColor].CGColor;
    _textView.layer.borderWidth = 2;
    _textView.delegate = self;
    [self.view addSubview:_textView];
    
    _placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100, 30)];
    _placeHolderLabel.text = @"请输入意见反馈";
    _placeHolderLabel.font = [UIFont systemFontOfSize:12];
    _placeHolderLabel.textColor = [UIColor lightGrayColor];
    [_textView addSubview:_placeHolderLabel];
    
    _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(_textView.width-65, _textView.height-30, 60, 30)];
    _numLabel.textAlignment = NSTextAlignmentRight;
    _numLabel.text = @"0/20";
    _numLabel.font = [UIFont systemFontOfSize:12];
    _numLabel.textColor = [UIColor lightGrayColor];
    [_textView addSubview:_numLabel];
    
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveBtn.frame = CGRectMake(30, _textView.y+_textView.height+20, kScreenWidth-60, 40);
    _saveBtn.layer.masksToBounds = YES;
    _saveBtn.layer.cornerRadius = 5;
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveBtn setBackgroundColor:RGB(37, 175, 153)];
    [_saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:_saveBtn];
    
}
-(void)saveAction
{
    NSLog(@"------------->意见反馈");
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [_textView becomeFirstResponder];
    //    NSLog(@"文本开始编辑");
    _placeHolderLabel.hidden = YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    //    NSLog(@"文本在变化");
    _numLabel.text = [NSString stringWithFormat:@"%d/20",20-(int)textView.text.length];
    
    if (textView.text.length >= 2000) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的字数超过20了" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        _textView.text = [textView.text substringToIndex:20];
        _numLabel.text = [NSString stringWithFormat:@"0/20"];
    }else if (textView.text.length ==0){
        _placeHolderLabel.hidden = NO;
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex ==1) {
        NSLog(@"确定");
    }else{
        NSLog(@"取消");
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    //     NSLog(@"文本结束编辑");
    
}



@end
