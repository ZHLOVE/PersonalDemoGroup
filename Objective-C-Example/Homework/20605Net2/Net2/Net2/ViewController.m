//
//  ViewController.m
//  Net2
//
//  Created by student on 16/3/28.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

#import <MBProgressHUD.h>
#import <SVProgressHUD.h>
#import <TBXML.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)loginBtnPressed:(UIButton*)sender
{
    // GET JSON
    //    http://192.168.13.28:8080/MJServer/login?username=123&pwd=123&method=get&type=JSON
    //请求地址的字符串
    NSString *urlStr = [NSString stringWithFormat:@"http:192.168.13.28:8080/MJServer/login?username=%@&pwd=%@&method=get&type=JSON",self.userNameTextfield.text,self.pswdTextField.text];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [SVProgressHUD showWithStatus:@"正在登陆"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDStyleDark];
    //发送异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError == nil) {
            NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (dict[@"error"] != nil) {
                //隐藏HUD
                [SVProgressHUD dismiss];
                NSString *message = [NSString stringWithFormat:@"错误信息:%@",dict[@"error"]];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self  dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertController addAction:alertAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }else{
                //提示登陆成功
                [SVProgressHUD showWithStatus:@"登陆成功"];
                //1s后跳转以下页面
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //隐藏HUD
                    [SVProgressHUD dismiss];
                    //跳转下一页
                    [self performSegueWithIdentifier:@"gotoNext" sender:nil];
                });
            }
        }else{
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

- (IBAction)loginBtn2Pressed:(id)sender
{
    //POST JSON
    NSString *urlStr = @"http:192.168.13.28:8080/MJServer/login";
    NSString *param = [NSString stringWithFormat:@"username=%@&pwd=%@&type=JSON",self.userNameTextfield.text,self.pswdTextField.text];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlRequest.HTTPMethod = @"POST";
    urlRequest.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError == nil) {
            NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
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
                [self performSegueWithIdentifier:@"gotoNext" sender:nil];
                
            }

        }
        else
        {
            NSLog(@"%@",connectionError,[connectionError localizedDescription]);
        }
    }];
    
    
}
- (IBAction)loginBtn3Pressed:(id)sender
{
    
    NSString *urlStr = @"http://192.168.13.28:8080/MJServer/login";
    NSString *param = [NSString stringWithFormat:@"username=%@&pwd=%@&type=XML",self.userNameTextfield.text,self.pswdTextField.text];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlRequest.HTTPMethod = @"POST";
    urlRequest.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
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
                    [self performSegueWithIdentifier:@"gotoNext" sender:nil];
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
