//
//  ViewController.m
//  ApiDemo
//
//  Created by niit on 16/3/28.
//  Copyright © 2016年 NIIT. All rights reserved.
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

- (IBAction)btnPressed:(id)sender
{
    NSString *httpUrl = @"http://apis.baidu.com/apistore/idservice/id";
    NSString *httpArg = [NSString stringWithFormat:@"id=%@",self.idTextField.text];
    [self request: httpUrl withHttpArg: httpArg];
}


-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    // 网址字符串
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    // 网址
    NSURL *url = [NSURL URLWithString: urlStr];
    // 请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    // GET请求
    [request setHTTPMethod: @"GET"];
    // 设置请求头
    [request addValue: @"60defbd45a27b44aee82ba6755c9a9c3" forHTTPHeaderField: @"apikey"];
    
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
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
