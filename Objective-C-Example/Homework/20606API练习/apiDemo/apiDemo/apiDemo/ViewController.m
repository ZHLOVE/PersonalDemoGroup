//
//  ViewController.m
//  apiDemo
//
//  Created by student on 16/3/29.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UITextView *resultView;

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

- (IBAction)btnPressed:(id)sender{
    NSString *httpUrl = @"http://apis.baidu.com/apistore/idservice/id";
    NSString *httpArg = [NSString stringWithFormat:@"id=%@",self.idTextField.text];
    NSLog(@"%@",httpArg);
    [self request: httpUrl withHttpArg: httpArg];
    
}

- (void)request: (NSString*)httpUrl withHttpArg: (NSString *)HttpArg{
    NSString *urlStr  = [[NSString alloc]initWithFormat:@"%@?%@",httpUrl,HttpArg];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //GET请求
    [request setHTTPMethod:@"GET"];
    //请求头
    [request addValue:@"25b8643f96b223e777d88ee519141eb9" forHTTPHeaderField:@"apiKey"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            NSLog(@"%@",connectionError.localizedDescription);
        }else{
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"HttpResponseCode:%ld", responseCode);
            NSLog(@"HttpResponseBody %@",responseString);
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary *dict1 = dict[@"retData"];
            self.resultView.text = [NSString stringWithFormat:@"生日:%@\n地址:%@\n性别:%@",dict1[@"birthday"],dict1[@"address"],dict1[@"sex"]];

        }
    }];
    
    
    
}




























@end
