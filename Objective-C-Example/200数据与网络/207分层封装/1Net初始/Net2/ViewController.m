//
//  ViewController.m
//  Net2
//
//  Created by niit on 16/3/28.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import <TBXML.h>
#import <SVProgressHUD.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
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

// GET JSON
- (IBAction)loginBtn1Pressed:(id)sender
{
//    http://192.168.13.28:8080/MJServer/login?username=123&pwd=123&method=get&type=JSON
    
    // 请求地址的字符串
    NSString *str = [NSString stringWithFormat:@"http://192.168.13.28:8080/MJServer/login?username=%@&pwd=%@&method=get&type=JSON",self.usernameTextField.text,self.pwdTextField.text];
    // 请求网址
    NSURL *url = [NSURL URLWithString:str];
    // 请求
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [SVProgressHUD showWithStatus:@"正在登陆"];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    // 发送异步请求
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(connectionError == nil)
        {
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",result);
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            //{"success":"登录成功"}
            //{"error":"密码不正确"}
            if(dict[@"error"] != nil)
            {
                // 隐藏HUD
                [SVProgressHUD dismiss];
                
                NSString *message = [NSString stringWithFormat:@"错误信息:%@",dict[@"error"]];
                // 登陆失败 显示错误信息
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *aciton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:aciton];
                [self presentViewController:alert animated:YES completion:nil];
                
                
            }
            else
            {
                // 提示登陆成功
                [SVProgressHUD showWithStatus:@"登陆成功"];
                // 1s后跳转下以页面
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 隐藏HUD
                    [SVProgressHUD dismiss];
                    // 条状下一页
                    [self performSegueWithIdentifier:@"gotoMain" sender:nil];
                });
            }
            
        }
        else
        {
            NSLog(@"%@",connectionError,[connectionError localizedDescription]);
            NSString *message = [NSString stringWithFormat:@"连接错误:%@",[connectionError localizedDescription]];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *aciton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:aciton];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }];
    
}

// POST JSON
- (IBAction)loginBtn2Pressed:(id)sender
{
    //    http://192.168.13.28:8080/MJServer/login?username=123&pwd=123&method=get&type=JSON
    
    NSString *str = @"http://192.168.13.28:8080/MJServer/login";
    NSString *param = [NSString stringWithFormat:@"username=%@&pwd=%@&type=JSON",self.usernameTextField.text,self.pwdTextField.text];
    NSURL *url = [NSURL URLWithString:str];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlRequest.HTTPMethod = @"POST";
    urlRequest.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];//NSString -> NSData
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(connectionError == nil)
        {
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",result);
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            //            {"success":"登录成功"}
            //{"error":"密码不正确"}
            if(dict[@"error"] != nil)
            {
                // 登陆失败 显示错误信息
                NSString *message = [NSString stringWithFormat:@"错误信息:%@",dict[@"error"]];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *aciton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:aciton];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                // 添加加ProgressHUD
                // 提示登陆成功
                // 1s
                
                // 登陆成功 跳转到下一页
                [self performSegueWithIdentifier:@"gotoMain" sender:nil];
                
            }
            
        }
        else
        {
            NSLog(@"%@",connectionError,[connectionError localizedDescription]);
        }
        
    }];
    
}

// POST XML
- (IBAction)loginBtn3Pressed:(id)sender
{
    //    http://192.168.13.28:8080/MJServer/login?username=123&pwd=123&method=get&type=JSON
    
    NSString *str = @"http://192.168.13.28:8080/MJServer/login";
    NSString *param = [NSString stringWithFormat:@"username=%@&pwd=%@&type=XML",self.usernameTextField.text,self.pwdTextField.text];
    NSURL *url = [NSURL URLWithString:str];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlRequest.HTTPMethod = @"POST";
    urlRequest.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];//NSString -> NSData
    
    // 显示
    [SVProgressHUD showWithStatus:@"正在登陆"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(connectionError == nil)
        {
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",result);
            //<error>密码不正确</error> // 当前就一个节点
            //<success>登录成功</success>
            
            TBXML *xml = [[TBXML alloc] initWithXMLData:data error:nil];
            
            TBXMLElement *root = xml.rootXMLElement;// 得到根节点
            NSString *elementName = [TBXML elementName:root];// 节点名字
            NSString *info = [TBXML textForElement:root];// 节点里的内容
            NSLog(@"%@",info);
            
            if([elementName isEqualToString:@"error"])// 判断节点名字是success还是error
            {
                // 隐藏
                [SVProgressHUD dismiss];
                
                // 登陆失败 显示错误信息
                NSString *message = [NSString stringWithFormat:@"错误信息:%@",info];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *aciton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:aciton];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:@"登陆成功!"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    // 登陆成功
                    [self performSegueWithIdentifier:@"gotoMain" sender:nil];
                });
                
                
            }
            
        }
        else
        {
            // 连接错误
            NSLog(@"%@",connectionError,[connectionError localizedDescription]);
        }
        
    }];
    
}

@end
