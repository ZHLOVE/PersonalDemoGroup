//
//  ViewController.m
//  SqliteDemo
//
//  Created by niit on 15/11/4.
//  Copyright © 2015年 niit. All rights reserved.
//

#import "ViewController.h"

#import <sqlite3.h>

#import "Student.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    // 创建数据库的指针
    sqlite3 *db;
    
    NSMutableArray *stuList;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createDb];
}

// 数据库路径
- (NSString *)dbFilePath
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *dbPath = [path stringByAppendingPathComponent:@"school.sqlite"];
    
    return dbPath;
}

// 创建数据库
- (void)createDb
{
    // 路径
    NSString *dbPath = [self dbFilePath];
    NSLog(@"%@",dbPath);
    
    // [str UTF8String] NSString -> char *
    // SQLITE_OK 语句执行成功
    if(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK)
    {
        NSLog(@"打开成功");
        
        // 创建表SQL语句
        NSString *sql = @"CREATE TABLE IF NOT EXISTS students(studentId text, studentName text, studentClass text)";
        
        // 执行SQL语句
        char *error;
        if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &error) == SQLITE_OK)
        {
            NSLog(@"建表成功");
        }
        else
        {
            NSLog(@"建表失败");
        }
    }
    else
    {
        NSLog(@"打开失败");
    }
    sqlite3_close(db);
}

- (IBAction)add:(id)sender
{
    if(sqlite3_open([[self dbFilePath] UTF8String], &db) == SQLITE_OK)
    {
        // 插入数据的SQL语句
        NSString *sql = @"INSERT INTO students (studentId,studentName,studentClass) VALUES(?,?,?)";
        
        // 预处理
        sqlite3_stmt *statment;
        if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statment, NULL) == SQLITE_OK)
        {
            // 绑定参数
            sqlite3_bind_text(statment, 1, [self.idTextField.text UTF8String], -1, NULL);
            sqlite3_bind_text(statment, 2, [self.nameTextField.text UTF8String], -1, NULL);
            sqlite3_bind_text(statment, 3, [self.classTextField.text UTF8String], -1, NULL);
            
            // 执行
            if(sqlite3_step(statment) == SQLITE_DONE)
            {
                NSLog(@"插入成功");
            }
            else
            {
                NSLog(@"插入失败");
            }
        }
        
        
        // 插入一条完整数据
//        NSString *sql = [NSString stringWithFormat:@"INSERT INTO students (studentId,studentName,studentClass) VALUES(%@,%@,%@)",self.idTextField.text,self.nameTextField.text,self.classTextField.text];
//        sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL);
        
        // 部分数据
//        NSString *sql = [NSString stringWithFormat:@"INSERT INTO students (studentId,studentName) VALUES('%@','%@')",self.idTextField.text,self.nameTextField.text];
//        NSLog(@"%@",sql);
//        NSLog(@"result = %i",sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL));
    }
    sqlite3_close(db);
}

- (IBAction)remove:(id)sender
{
    if(sqlite3_open([[self dbFilePath] UTF8String], &db) == SQLITE_OK)
    {
        // 插入数据的SQL语句
        // delete from students 删除所有
        // delete from students where 条件1
        // delete from students where 条件1 and 条件2 or 条件3
        NSString *sql = @"delete from students where studentId = ?";
        
        sqlite3_stmt *statment;
        if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statment, NULL) == SQLITE_OK)
        {
            // 绑定参数
            sqlite3_bind_text(statment, 1, [self.idTextField.text UTF8String], -1, NULL);
            
            if(sqlite3_step(statment) == SQLITE_DONE)
            {
                NSLog(@"删除成功");
            }
            else
            {
                NSLog(@"删除失败");
            }
        }
    }
    sqlite3_close(db);
}
- (IBAction)modify:(id)sender
{
    if(sqlite3_open([[self dbFilePath] UTF8String], &db) == SQLITE_OK)
    {
        // 修改数据的SQL语句
        // update 表格名称 字段1 = 值1,字段2 = 值2 where 字段3 = 值3
        NSString *sql = @"update students set studentName = ?,studentClass = ? where studentId = ?";
        
        sqlite3_stmt *statment;
        if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statment, NULL) == SQLITE_OK)
        {
            // 绑定参数
            sqlite3_bind_text(statment, 1, [self.nameTextField.text UTF8String], -1, NULL);
            sqlite3_bind_text(statment, 2, [self.classTextField.text UTF8String], -1, NULL);
            
            sqlite3_bind_text(statment, 3, [self.idTextField.text UTF8String], -1, NULL);
            
            if(sqlite3_step(statment) == SQLITE_DONE)
            {
                NSLog(@"更新成功");
            }
            else
            {
                NSLog(@"更新失败");
            }
        }
    }
    sqlite3_close(db);
    
}
- (IBAction)find:(id)sender
{
    if(sqlite3_open([[self dbFilePath] UTF8String], &db) == SQLITE_OK)
    {
        // 修改数据的SQL语句
        // select * from 表格名  查询所有记录
        // select * from 表格名 where 条件1 and 条件2 or 条件3  查询符合条件的记录
        // select studentId form 表格名 查询所有的序号
        NSString *sql = @"select * from students where studentId = ?";
        
        sqlite3_stmt *statment;
        if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statment, NULL) == SQLITE_OK)
        {
            // 绑定参数
            sqlite3_bind_text(statment, 1, [self.idTextField.text UTF8String], -1, NULL);
            
            while(sqlite3_step(statment) == SQLITE_ROW)
            {
                char *stuId = (char *)sqlite3_column_text(statment, 0);
                char *stuName = (char *)sqlite3_column_text(statment, 1);
                char *stuClass = (char *)sqlite3_column_text(statment, 2);
                
                // char * -> NSString
                self.nameTextField.text = [[NSString alloc] initWithUTF8String:stuName];
                self.classTextField.text = [[NSString alloc] initWithUTF8String:stuClass];
            }
        }
    }
    sqlite3_close(db);
}
- (IBAction)findAll:(id)sender
{
    stuList = [NSMutableArray array];
    if(sqlite3_open([[self dbFilePath] UTF8String], &db) == SQLITE_OK)
    {
        // 修改数据的SQL语句
        // select * from 表格名  查询所有记录
        // select * from 表格名 where 条件1 and 条件2 or 条件3  查询符合条件的记录
        // select studentId form 表格名 查询所有的序号
        NSString *sql = @"select * from students";
        
        sqlite3_stmt *statment;
        if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statment, NULL) == SQLITE_OK)
        {
            
            while(sqlite3_step(statment) == SQLITE_ROW)
            {
                char *stuId = (char *)sqlite3_column_text(statment, 0);
                char *stuName = (char *)sqlite3_column_text(statment, 1);
                char *stuClass = (char *)sqlite3_column_text(statment, 2);
                
                NSLog(@"%@:%@,%@",[[NSString alloc] initWithUTF8String:stuId],[[NSString alloc] initWithUTF8String:stuName],[[NSString alloc] initWithUTF8String:stuClass]);
                
                Student *stu =[[Student alloc] init];
                stu.studentId = [[NSString alloc] initWithUTF8String:stuId];
                stu.studentName = [[NSString alloc] initWithUTF8String:stuName];

                stu.studentClass = [[NSString alloc] initWithUTF8String:stuClass];
                [stuList addObject:stu];
                
                [self.tableView reloadData];
                
            }
        }
    }
    sqlite3_close(db);
}

#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return stuList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    Student *stu =stuList[indexPath.row];
    
    cell.textLabel.text = stu.studentName;
    cell.detailTextLabel.text = stu.studentClass;
    return cell;
}
@end
