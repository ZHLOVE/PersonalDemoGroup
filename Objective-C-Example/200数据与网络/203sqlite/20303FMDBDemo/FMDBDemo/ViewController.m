//
//  ViewController.m
//  FMDBDemo
//
//  Created by niit on 16/4/14.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import <FMDB.h>
@interface ViewController ()

@property (nonatomic,strong) FMDatabase *db;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 连接创建数据库
    NSString *dbPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"school.sqlite"];
    self.db = [FMDatabase databaseWithPath:dbPath];
    
    // 连接数据库
    if([self.db open])
    {
        NSLog(@"打开数据库成功");
        
        // 创建表格
        NSString *sql = @"CREATE TABLE IF NOT EXISTS T_Students ("
        "id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "
        "name TEXT,"
        "age INTEGER,"
        "class TEXT,"
        "stuId INTEGER"
        ")";
        if([self.db executeUpdate:sql])
        {
            NSLog(@"创建表格成功");
        }
        else
        {
            NSLog(@"创建失败");
        }
        
    }
    else
    {
        NSLog(@"打开数据库失败");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn1Pressed:(id)sender {
    
    // 插入100个学生数据
    for(int i=0;i<100;i++)
    {
        NSString *name = [NSString stringWithFormat:@"学生%i",i];
//        NSString *sql = [NSString stringWithFormat:@"INSERT INTO T_Students (stuId,name,age) VALUES (%i,'%@',%i);",i+1,name,arc4random_uniform(10)+10];
        // executeUpdate 用 ? 占位
//        if([self.db executeUpdate:sql])
        if([self.db executeUpdate:@"INSERT INTO T_Students (stuId,name,age) VALUES (?,?,?);",@(i+1),name,@(arc4random_uniform(10)+10)])
        {
            NSLog(@"插入成功!");
        }
        else
        {
            NSLog(@"插入失败");
        }
    }

    
}

- (IBAction)btn2Pressed:(id)sender
{
    // 查询数据
    // executeQueryWithFormat 用%@ %i占位
    NSString *sql = @"SELECT * FROM T_Students WHERE age > %i";
    
//    FMResultSet *result = [self.db executeQuery:sql];
    FMResultSet *result = [self.db executeQueryWithFormat:sql,[self.ageTextField.text intValue]];
    
    while ([result next])
    {
        NSString *name = [result stringForColumn:@"name"];
        int age = [result intForColumn:@"age"];
        
        NSLog(@"名字:%@ 年龄:%i",name,age);
    }
    
    
    
}

@end
