//
//  ViewController.m
//  Contacts
//
//  Created by niit on 16/4/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

#import <MessageUI/MessageUI.h>

// 练习:
// 网上搜索Contact ContactsUI相关资料,替代AddressBook AddressBookUI实现本程序

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

- (IBAction)selectContactBtnPressed:(id)sender
{
    // 创建了联系人列表界面
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
//    picker.delegate = self; // 错误
    picker.peoplePickerDelegate = self;
    // 弹出
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)callPhone:(id)sender
{
    // tel://13812341234
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.label2.text]]];
}

- (IBAction)sendSMS:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",self.label2.text]]];
}

- (IBAction)sendEmail:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",self.label3.text]]];
}

- (IBAction)openWeb:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.baidu.com"]];
}


- (IBAction)sendSMS2:(id)sender
{
    MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
    messageVC.messageComposeDelegate = self;
    [messageVC setRecipients:@[self.label2.text]];
    [messageVC setBody:@"O(∩_∩)O哈哈~"];
    [self presentViewController:messageVC animated:YES completion:nil];
}

- (IBAction)sendEmail2:(id)sender
{
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
    mailVC.mailComposeDelegate = self;
    [mailVC setToRecipients:@[self.label3.text]];
    [mailVC setMessageBody:@"哈哈" isHTML:NO];
    [self presentViewController:mailVC animated:YES completion:nil];
}

#pragma mark - 选择联系人界面的代理方法 ABPeoplePickerNavigationControllerDelegate Method
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    // 信息就在person中
    
    // 1 .简单属性
    //ABRecordCopyValue(参数1,参数2)
    //使用ABRecordCopyValue函数可以从ABRecordRef中获得联系人的简单属性
    //参数1 person 联系人指针
    //参数2 要获得的属性名字
    
    // * 名字
    NSString *name = (__bridge NSString *)(ABRecordCopyValue(person,kABPersonLastNameProperty));// 姓
    self.label1.text = name;
    
    // 2. 多重属性
    // ABRecordCopyValue函数返回的就是ABMultiValueRef类型的数据
    // ABMultiValueCopyValueAtIndex(参数1,参数2) 从 ABMultiValueRef多重数据中取出第几个数据
    
    // * 电话
    ABMultiValueRef tels = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString *tel = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(tels,0));// 取出第一个电话
    self.label2.text = tel;
    
    // * 邮箱
    ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
    NSString *email = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(emails,0));
    self.label3.text = email;
    
    // 3 复杂属性
    // * 邮政编码 zip
    ABMultiValueRef addresses = ABRecordCopyValue(person, kABPersonAddressProperty);
    if(ABMultiValueGetCount(addresses)>0)
    {
        NSDictionary *address = (__bridge NSDictionary *)(ABMultiValueCopyValueAtIndex(addresses,0));
        self.label4.text = address[@"ZIP"];
    }
    // 5. 头像
    if(ABPersonHasImageData(person))
    {
        self.iconImageView.image = [UIImage imageWithData:(__bridge NSData*)ABPersonCopyImageData(person)];
    }
}

#pragma mark - 发消息界面的代理方法MFMessageComposeViewControllerDelegate Method
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    // 发送的结果
//    MessageComposeResultCancelled,
//    MessageComposeResultSent,
//    MessageComposeResultFailed
    switch (result)
    {
        case MessageComposeResultSent:
            NSLog(@"消息发送成功");
            break;
        case MessageComposeResultFailed:
            NSLog(@"消息发送失败");
            break;
        case MessageComposeResultCancelled:
            NSLog(@"消息发送取消");
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 发邮件界面的代理方法 MFMailComposeViewControllerDelegate Method
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error
{
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
