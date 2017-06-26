//
//  ViewController.m
//  AddressBookUI
//
//  Created by student on 16/4/8.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

//跳转到系统页面打电话，发短信。。
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
//在程序中发短信邮件
#import <MessageUI/MessageUI.h>
// 练习:
// 网上搜索Contact ContactsUI相关资料
// 替代AddressBook AddressBookUI实现本程序
@interface ViewController ()<ABPeoplePickerNavigationControllerDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
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
- (IBAction)selectContactBtnPressed:(id)sender {
    // 创建了联系人列表界面
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    // 弹出
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - 选择联系人界面的代理方法 ABPeoplePickerNavigationControllerDelegate Method
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person{
    
    // 信息就在person中
    
    // 1 .简单属性
    //ABRecordCopyValue(参数1,参数2)
    //使用ABRecordCopyValue函数可以从ABRecordRef中获得联系人的简单属性
    //参数1 person 联系人指针
    //参数2 要获得的属性名字
    //1名字
    NSString *name = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));//姓
    self.label1.text = name;
    
    // 2. 多重属性
    // ABRecordCopyValue函数返回的就是ABMultiValueRef类型的数据
    // ABMultiValueCopyValueAtIndex(参数1,参数2) 从 ABMultiValueRef多重数据中取出第几个数据
    
    // 2. 电话
    ABMultiValueRef tels = ABRecordCopyValue(person, kABPersonEmailProperty);
     NSString *tel = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(tels,0));
    self.label2.text = tel;
    //3 邮箱
    ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
    NSString *email = (__bridge NSString *)(ABMultiValueCopyLabelAtIndex(emails, 0));
    self.label3.text = email;
    
    //4 zip
    ABMultiValueRef addresses = ABRecordCopyValue(person, kABPersonAddressProperty);
    if (ABMultiValueGetCount(addresses)>0) {
        NSDictionary *address = (__bridge NSDictionary *)(ABMultiValueCopyValueAtIndex(addresses, 0));
        NSLog(@"%@",address[@"ZIP"]);
        self.label4.text = address[@"ZIP"];
    }
    //5 头像
    if (ABPersonHasImageData(person)) {
        self.iconImageView.image = [UIImage imageWithData:(__bridge NSData*)ABPersonCopyImageData(person)];
    }
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)callPhone:(id)sender {
    //tel:13812341234
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.label2.text]]];
}


- (IBAction)senEmail:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",self.label3.text]]];
}


- (IBAction)senMessage:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",self.label2.text]]];
}

- (IBAction)openWeb:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.baidu.com"]];
}

- (IBAction)senMessage2:(id)sender {
    MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc]init];
    messageVC.messageComposeDelegate = self;
    [messageVC setRecipients:@[self.label2.text]];
    [messageVC setBody:@"O(∩_∩)O哈哈~"];
    [self presentViewController:messageVC animated:YES completion:nil];
    
}

#pragma mark - 发消息界面的代理方法MFMessageComposeViewControllerDelegate Method
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    //    MessageComposeResultCancelled,
    //    MessageComposeResultSent,
    //    MessageComposeResultFailed
    switch (result)
    {
        case MessageComposeResultSent:
            NSLog(@"发送成功");
            break;
        case MessageComposeResultFailed:
            NSLog(@"发送失败");
            break;
        case MessageComposeResultCancelled:
            NSLog(@"发送取消");
            break;
            
        default:
            break;
    }

    
}


- (IBAction)senEmail2:(id)sender {
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc]init];
    mailVC.mailComposeDelegate = self;
    [mailVC setToRecipients:@[self.label3.text]];
    [mailVC setMessageBody:@"哈哈" isHTML:NO];
    [self presentViewController:mailVC animated:YES completion:nil];
}

#pragma mark - 发邮件界面的代理方法 MFMailComposeViewControllerDelegate Method
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    //    MFMailComposeResultCancelled,
    //    MFMailComposeResultSaved,
    //    MFMailComposeResultSent,
    //    MFMailComposeResultFailed
    switch (result)
    {
        case MFMailComposeResultSent:
            NSLog(@"邮件发送成功");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"邮件保存草稿");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"邮件发送失败");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"邮件发送失败");
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}


























@end
