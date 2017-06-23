//
//  ViewController.m
//  SaveData
//
//  Created by niit on 16/3/14.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "StudentModel.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // 得到沙盒目录路径:

    // 方式1: NSSearchPathForDirectoriesInDomains
    NSLog(@"方式1:");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath1 = paths[0];
    NSLog(@"Documents路径:%@",docPath1);

    // 方式2: NSHomeDirectory()
    NSLog(@"方式2:");
    NSLog(@"沙盒目录:%@",NSHomeDirectory());
    NSString *docPath2 = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    NSLog(@"Documents路径:%@",docPath2);
}

#pragma mark - NSUserDefault方式
#define kStuId @"StuId"
#define kStuName @"StuName"
#define kStuAge @"StuAge"
- (IBAction)save1:(id)sender
{
    // 得到NSUserDefault单例对象
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    // 使用key将信息写入
    // setObject 数据是:NSString NSNumber NSArray NSDictionary类型
    [d setObject:self.idTextField.text forKey:kStuId];
    [d setObject:self.nameTextField.text forKey:kStuName];
    [d setObject:self.ageTextField.text forKey:kStuAge];

    // 也可以存入基本类型(实际上是nsnumber类型存储)
//    [d setInteger:5 forKey:@"number1"];
//    [d setFloat:10.5f forKey:@"number2"];
//    [d setDouble:10.5 forKey:@"number3"];
//    [d setBool:YES forKey:@"number4"];
    
    [d synchronize];// 同步(存盘一下)
}

- (IBAction)read1:(id)sender
{
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    // 读取时使用一致的key
    self.idTextField.text = [d objectForKey:kStuId];
    self.nameTextField.text = [d objectForKey:kStuName];
    self.ageTextField.text = [d objectForKey:kStuAge];
    
    // 取出基本类型
//    [d integerForKey:@"nubmer1"];
//    [d floatForKey:@"number2"];
//    [d doubleForKey:@"number3"];
//    [d boolForKey:@"number4"];
}

#pragma mark - plist方式 (信息存入数组或者字典)
- (IBAction)save2:(id)sender
{
    // 存取位置
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"student.plist"];
    NSLog(@"存储位置:%@",filePath);
    // NSString 的方法
    // stringByAppendingString:        字符串追加字符串产生新的字符串
    // stringByAppendingPathComponent: 字符串追加字符串产生新的字符串,会自动中间加个 /
    
    // 1. 信息放入一个字典
    NSDictionary *dict = @{@"stuId":self.idTextField.text,
                           @"stuName":self.nameTextField.text,
                           @"stuAge":self.ageTextField.text};
    // 2. 字典写入到文件
    [dict writeToFile:filePath atomically:YES];
    
}

- (IBAction)read2:(id)sender
{
    // 存取位置
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"student.plist"];
    NSLog(@"读取位置:%@",filePath);
    
    // 1. 从文件中读取信息到字典对象
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    // 2. 将信息显示到界面
    self.idTextField.text = dict[@"stuId"];
    self.nameTextField.text = dict[@"stuName"];
    self.ageTextField.text = dict[@"stuAge"];
    
}

#pragma mark - 归档方式 (数据放入支持归档的对象)
- (IBAction)save3:(id)sender {
    
    // 存取位置
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"student.arch"];
    NSLog(@"存储位置:%@",filePath);
    
    // 1. 将信息存储到对象中
    StudentModel *m = [[StudentModel alloc] initWithId:self.idTextField.text
                                               andName:self.nameTextField.text
                                                andAge:self.ageTextField.text];
    // 2. 创建可变数据对象用于归档存入
    NSMutableData *mData = [NSMutableData data];
    // 3. 创建归档对象
    NSKeyedArchiver *arch = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
    // 4. 归档StuentModel对象
    [arch encodeObject:m forKey:@"Student"];
    // 5. 完成归档
    [arch finishEncoding];
    // 6. 数据存入文件
    [mData writeToFile:filePath atomically:YES];
    
}

- (IBAction)read3:(id)sender
{
    // 存取位置
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"student.arch"];
    NSLog(@"读取位置:%@",filePath);
    
    // 1. 读出数据(二进制数据)
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    // 2. 创建解档对象
    NSKeyedUnarchiver *unArch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    // 3. 从解档对象中解档Student(和归档时使用相同的key)
    StudentModel *stu = [unArch decodeObjectForKey:@"Student"];
    // 4. 完成解档
    [unArch finishDecoding];
    // 5. 将信息显示到界面
    self.idTextField.text = stu.stuId;
    self.nameTextField.text = stu.stuName;
    self.ageTextField.text = stu.stuAge;
    
}

@end
