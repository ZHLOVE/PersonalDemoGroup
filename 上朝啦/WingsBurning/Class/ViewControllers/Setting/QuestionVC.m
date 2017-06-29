//
//  QuestionVC.m
//  WingsBurning
//
//  Created by MBP on 16/8/25.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "QuestionVC.h"

@interface QuestionVC ()

@property(nonatomic,strong) UIButton *phoneBtn;
@property(nonatomic,strong) UILabel *phoneCallLabel;
@property(nonatomic,strong) UIWebView *questionView;

@end

@implementation QuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)setUpUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"常见问题";
    __weak typeof(self) weakSelf = self;
    [self.view addSubview:self.questionView];
    [self.questionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view);
        make.left.right.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-46 * ratio);
    }];
    [self.view addSubview:self.phoneCallLabel];
    [self.phoneCallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(46 * ratio);
    }];
    [self.view addSubview:self.phoneBtn];
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(-15 * ratio);
        make.width.mas_equalTo(100 * ratio);
        make.height.mas_equalTo(46 * ratio);
        make.centerY.mas_equalTo(weakSelf.phoneCallLabel.mas_centerY);
    }];
}

- (void)phoneBtnPressed{
    NSString *phoneNum = @"0510-81819939";// 电话号码
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

- (UIWebView *)questionView{
    if (_questionView == nil) {
        CGRect tableFrame = self.view.frame;
        _questionView = [[UIWebView alloc]initWithFrame:CGRectMake(tableFrame.origin.x, tableFrame.origin.y, tableFrame.size.width, tableFrame.size.height - 46 * ratio)];
        NSURL* url = [NSURL URLWithString:@"https://www.shangchao.la/questions.html"];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        [_questionView loadRequest:request];
    }
    return _questionView;
}

- (UIButton *)phoneBtn{
    if (_phoneBtn == nil) {
        _phoneBtn = [[UIButton alloc]init];
        [_phoneBtn setTitle:@"服务热线" forState:UIControlStateNormal];
        _phoneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_phoneBtn setTitleColor:[UIColor colorWithHexString:@"#03c873"] forState:UIControlStateNormal];
        [_phoneBtn setImage:[UIImage imageNamed:@"icon_hotline"] forState:UIControlStateNormal];
        _phoneBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _phoneBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _phoneBtn.backgroundColor = [UIColor clearColor];
        [_phoneBtn addTarget:self action:@selector(phoneBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneBtn;
}

- (UILabel *)phoneCallLabel{
    if (_phoneCallLabel == nil) {
        _phoneCallLabel = [[UILabel alloc]init];
        _phoneCallLabel.backgroundColor = [UIColor whiteColor];
        _phoneCallLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _phoneCallLabel.font = [UIFont systemFontOfSize:14];
        _phoneCallLabel.text = @"   还没解决您的问题？";
    }
    return _phoneCallLabel;
}














@end
