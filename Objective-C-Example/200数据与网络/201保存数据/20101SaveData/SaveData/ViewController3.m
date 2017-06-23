//
//  ViewController3.m
//  SaveData
//
//  Created by niit on 16/3/14.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController3.h"

#import "StudentModel.h"

// 练习:
// 在页面下方添加一个tableview,用于显示学生信息（学号、姓名、年龄,都要显示）
// 每次添加、删除、修改之后，更新表格信息

@interface ViewController3 ()

// 学生数组
@property (nonatomic,strong) NSMutableArray *stuList;

@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;

@end

@implementation ViewController3

/** 重写getter方法 懒加载 */
- (NSMutableArray *)stuList
{
    if(_stuList == nil)
    {
        // 判断存档文件是否存在，如果之前已有存档文件，则从中解档出来以前的数据
        NSFileManager *fm = [NSFileManager defaultManager];
        if([fm fileExistsAtPath:[self dataPath]])
        {
            // 解档
            // 1. 读出数据(二进制数据)
            NSData *data = [NSData dataWithContentsOfFile:[self dataPath]];
            // 2. 创建解档对象
            NSKeyedUnarchiver *unArch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            // 3. 从解档对象中解档Student(和归档时使用相同的key)
            _stuList = [unArch decodeObjectForKey:@"Students"];
            // 4. 完成解档
            [unArch finishDecoding];
        }
        
        if(_stuList == nil)
        {
            // 没有存档文件或存档文件中没有读取出数据来，则新建一个空数组
            _stuList = [NSMutableArray array];
        }
    }
    return _stuList;
}

// 归档文件存储路径
- (NSString *)dataPath
{
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"students.arch"];
    //    NSLog(@"存储位置:%@",filePath);
    return filePath;
}

// 保存数据(归档)
- (void)saveData
{
    // 1. 创建可变数据对象用于归档存入
    NSMutableData *mData = [NSMutableData data];
    // 2. 创建归档对象
    NSKeyedArchiver *arch = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
    // 3. 归档数组对象(数组本身是支持归档，数组的元素也要支持归档)
    [arch encodeObject:self.stuList forKey:@"Students"];
    // 4. 完成归档
    [arch finishEncoding];
    // 5. 数据存入文件
    [mData writeToFile:[self dataPath] atomically:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)add:(id)sender
{
    // 1. 将信息存储到对象中
    StudentModel *m = [[StudentModel alloc] initWithId:self.idTextField.text
                                               andName:self.nameTextField.text
                                                andAge:self.ageTextField.text];
    // 2. 将对象加入到数组中
    [self.stuList addObject:m];
    // 3. 保存
    [self saveData];
}

- (IBAction)remove:(id)sender
{
    // 1. 遍历学生数组
    for(StudentModel *m in self.stuList)
    {
        // 2. 如果学号相同
        if([m.stuId isEqualToString:self.idTextField.text])
        {
            // 3. 将该学生这个字典从数组中移除
            [self.stuList removeObject:m];
            break;
        }
    }
    // 4. 数组保存一下
    [self saveData];
}
- (IBAction)modify:(id)sender
{
    // 1. 遍历学生数组
    for(StudentModel *m in self.stuList)
    {
        // 2. 如果学号相同
        if([m.stuId isEqualToString:self.idTextField.text])
        {
            // 3. 修改该学生信息
            m.stuName = self.nameTextField.text;
            m.stuAge = self.ageTextField.text;
            break;
        }
    }
    // 4. 数组保存一下
    [self saveData];
}

- (IBAction)find:(id)sender
{
    // 1. 遍历学生数组
    for(StudentModel *m in self.stuList)
    {
        // 2. 如果学号相同
        if([m.stuId isEqualToString:self.idTextField.text])
        {
            // 3. 将查询到的学生信息显示到界面
            self.nameTextField.text = m.stuName;
            self.ageTextField.text = m.stuAge;
            break;
        }
    }
}

- (IBAction)findAll:(id)sender
{
    for (StudentModel *m in self.stuList)
    {
        NSLog(@"%@",m);
    }
}


@end
