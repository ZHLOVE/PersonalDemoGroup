//
//  TPAddressBookViewController.m
//  HiTV
//
//  Created by yy on 15/11/11.
//  Copyright © 2015年 Lanbo Zhang. All rights reserved.
//

#import "TPAddressBookViewController.h"
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import "AddressBook.h"
#import "TPAddressBookTableViewCell.h"
//#import "UMSocialSnsPlatformManager.h"

@interface TPAddressBookViewController ()<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITableView *table;
@property (nonatomic, weak) IBOutlet UIView *searchView;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSMutableArray *resultList;
@property (nonatomic, assign) BOOL isSearching;

@end

@implementation TPAddressBookViewController

#pragma mark - view
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"通讯录";
    self.resultList = [[NSMutableArray alloc] init];
    self.textField.backgroundColor = [UIColor blackColor];
    self.textField.textColor = [UIColor whiteColor];
    NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:@"请输入搜索内容"
                                                                      attributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    self.textField.attributedPlaceholder = placeholder;
    [self.table registerNib:[UINib nibWithNibName:kTPAddressBookTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:kTPAddressBookTableViewCellIdentifier];
    [self getLocalAddressBook];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearching) {
        return self.resultList.count;
    }
    return self.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TPAddressBookTableViewCell";
    TPAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:kTPAddressBookTableViewCellIdentifier owner:self options:nil] lastObject];
    }
    
    if (self.isSearching) {
       [cell showData:self.resultList[indexPath.row]];
    }
    else{
        [cell showData:self.list[indexPath.row]];
    }
    
    [cell setShareButtonClickBlock:^(TPAddressBookTableViewCell *sender) {
        if([MFMessageComposeViewController canSendText])
            
        {
            MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
            controller.delegate = self;
            NSMutableArray *telArray = [[NSMutableArray alloc]init];
            
            AddressBook *data = self.list[indexPath.row];
            [telArray addObject:data.tel];
            controller.recipients = telArray;
            
            controller.body = [HiTVGlobals sharedInstance].shareContent;
            controller.messageComposeDelegate = self;
            [self presentViewController:controller animated:YES completion:nil];
        }
        else
        {
            [self showAlertWithMessage:@"该设备不支持短信功能"];
            
        }

    }];
    
    return cell;
    
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    
    hud.mode = MBProgressHUDModeText;
    
    
    switch (result) {
        case MessageComposeResultCancelled:
        {
            hud.labelText = @"已取消";
            [controller dismissViewControllerAnimated:YES completion:nil];
            
        }
            break;
        case MessageComposeResultSent:
        {
            
           hud.labelText = @"短信发送成功";
            [controller dismissViewControllerAnimated:YES completion:^{
               [self.navigationController popViewControllerAnimated:YES];
            }];
        }
            break;
        case MessageComposeResultFailed:
        {
            hud.labelText = @"短信发送失败";
            [controller dismissViewControllerAnimated:YES completion:nil];
        }
            
            break;
            
        default:
            break;
    }
    
    [hud show:YES];
    [hud hide:YES afterDelay:2.0];

}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self searchContent:textField.text];
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)textFieldValueChanged:(UITextField *)sender
{
    [self searchContent:sender.text];
}

- (void)searchContent:(NSString *)content
{
    if (content.length != 0) {
        
        self.isSearching = YES;
        [self.resultList removeAllObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",content];
       
        for (AddressBook *data in self.list) {
            
            //检索名字
            NSString *enName = [HiTVConstants CHTOEN:data.name];
            if (data.name == nil) {
                data.name = @"";
            }
            if ([predicate evaluateWithObject:data.name]||[predicate evaluateWithObject:enName] || [predicate evaluateWithObject:data.tel]) {
                [self.resultList addObject:data];
            }

        }
    }
    else{
        self.isSearching = NO;
    }
    
    [self.table reloadData];
}

#pragma mark - Alert
- (void)showAlertWithMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles: nil];
    [alert show];
}

#pragma mark - data
-(void)getLocalAddressBook
{
    self.list = [[NSMutableArray alloc] init];
    
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
        
    {
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        
        //获取通讯录权限
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    
    else
        
    {
        addressBooks = ABAddressBookCreate();
        
    }
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    
    
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        AddressBook *addressBook = [[AddressBook alloc] init];
        
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        addressBook.name = nameString;
        addressBook.recordID = (int)ABRecordGetRecordID(person);;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
        
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        addressBook.tel = (__bridge NSString*)value;
                        break;
                    }
                    case 1: {// Email
                        addressBook.email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        [self.list addObject:addressBook];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    
    [self.table reloadData];
}

@end
