//
//  main.m
//  文件操作
//
//  Created by niit on 16/1/11.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        
#pragma mark - 重要路径
#pragma mark -
#pragma mark 当前操作路径:currentDirectoryPath
        NSString *curDir = [fm currentDirectoryPath];
        NSLog(@"应用程序:%@",curDir);// 一开始的当前路径是程序生成的可执行文件所在路径
#pragma mark  当前用户路径:NSHomeDirectory()
        NSString *homeDir  = NSHomeDirectory();//User/niit
        NSLog(@"home目录:%@",homeDir);
#pragma mark  临时文件路径:NSTemporaryDirectory()
        //(用于保存临时文件,不需要负责删除,系统会定时清空)
        NSString *tmpDir = NSTemporaryDirectory();
        NSLog(@"临时目录:%@",tmpDir);
        
#pragma mark - NSFileManager
#pragma mark - 文件操作
#pragma mark -
#pragma mark 1.更改当前操作路径
//        NSString *newCurDir = [NSHomeDirectory() stringByAppendingString:@"/fileoperate"];
        NSString *newCurDir = [NSHomeDirectory() stringByAppendingPathComponent:@"fileoperate"];// 自动添加/
        NSLog(@"%@",newCurDir);
        if([fm changeCurrentDirectoryPath:newCurDir])
        {
            NSLog(@"更改当前操作路径成功:%@",[fm currentDirectoryPath]);
        }
        
#pragma mark 2.判断文件是否存在
        NSString *filePath1 = [NSHomeDirectory() stringByAppendingPathComponent:@"fileoperate/1.txt"];
        if([fm fileExistsAtPath:filePath1])
        {
            NSLog(@"%@ 存在",filePath1);
        }
        else
        {
            NSLog(@"%@ 不存在",filePath1);
        }
        
#pragma mark 3.复制文件
        NSError *error;// 创建一个指针
        // 把指针地址传给函数，如果出错，fm会创建NSError错误对象，指针指向NSError错误对象
        if(![fm copyItemAtPath:@"/Users/niit/fileoperate/1.txt" toPath:@"/Users/niit/fileoperate/2.txt" error:&error])
        {
            NSLog(@"复制出错:%@",error.localizedDescription);
        }
        else
        {
            NSLog(@"复制成功");
        }
        
        //contentsAtPath:
        //createFileAtPath
        NSData *fileData = [fm contentsAtPath:@"/Users/niit/fileoperate/1.txt"];
        if(fileData != nil)
        {
            if([fm createFileAtPath:@"/Users/niit/fileoperate/4.txt" contents:fileData attributes:nil])
            {
                NSLog(@"复制成功");
            }
            else
            {
                NSLog(@"复制出错");
            }
        }
        
#pragma mark 4.比较文件
        if([fm contentsEqualAtPath:filePath1 andPath:@"/Users/niit/fileoperate/4.txt"])
        {
            NSLog(@"相同");
        }
        else
        {
            NSLog(@"不相同");
        }
        
#pragma mark 5.移动
        if([fm moveItemAtPath:@"/Users/niit/fileoperate/1.txt" toPath:@"/Users/niit/fileoperate/5.txt" error:&error])
        {
            NSLog(@"移动成功");
        }
        else
        {
            NSLog(@"移动失败");
        }
        
#pragma mark 6.显示文件的信息
        NSDictionary *infoDict = [fm attributesOfItemAtPath:@"/Users/niit/fileoperate/" error:&error];
        NSLog(@"%@",infoDict);
        
//        2016-01-11 10:21:07.969 文件操作[3024:65374] {
//            NSFileCreationDate = "2015-12-22 07:18:26 +0000";
//            NSFileExtendedAttributes =     {
//                "com.apple.TextEncoding" = <7574662d 383b3133 34323137 393834>;
//            };
//            NSFileExtensionHidden = 1;
//            NSFileGroupOwnerAccountID = 20;
//            NSFileGroupOwnerAccountName = staff;
//            NSFileHFSCreatorCode = 0;
//            NSFileHFSTypeCode = 0;
//            NSFileModificationDate = "2015-12-22 07:23:23 +0000";
//            NSFileOwnerAccountID = 501;
//            NSFileOwnerAccountName = niit;
//            NSFilePosixPermissions = 420;
//            NSFileReferenceCount = 1;
//            NSFileSize = 315;// 文件的大小
//            NSFileSystemFileNumber = 3606175;
//            NSFileSystemNumber = 16777217;
//            NSFileType = NSFileTypeRegular;// <- 文件类型
//        }

//        {
//            NSFileCreationDate = "2016-01-11 01:39:53 +0000";
//            NSFileExtensionHidden = 0;
//            NSFileGroupOwnerAccountID = 20;
//            NSFileGroupOwnerAccountName = staff;
//            NSFileModificationDate = "2016-01-11 02:20:16 +0000";
//            NSFileOwnerAccountID = 501;
//            NSFileOwnerAccountName = niit;
//            NSFilePosixPermissions = 493;
//            NSFileReferenceCount = 8;
//            NSFileSize = 272;
//            NSFileSystemFileNumber = 3605433;
//            NSFileSystemNumber = 16777217;
//            NSFileType = NSFileTypeDirectory;// <- 目录类型
//        }
        
#pragma mark 7 删除
        if([fm removeItemAtPath:@"/Users/niit/fileoperate/5.txt" error:&error])
        {
            NSLog(@"删除成功");
        }
        else
        {
            NSLog(@"删除失败,%@",error);
        }
        
#pragma mark 8.显示文件的内容
        NSString *fileContent = [NSString stringWithContentsOfFile:@"/Users/niit/fileoperate/5.txt" encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"%@",fileContent);
        
#pragma mark - 文件夹操作
        // 未列出的操作,则和文件操作一样
#pragma mark 1.创建文件夹
        if([fm createDirectoryAtPath:@"/Users/niit/fileoperate/aaa"
                withIntermediateDirectories:YES
                          attributes:nil error:&error])
        {
            NSLog(@"创建成功");
        }
        else
        {
            NSLog(@"创建失败%@",error);
        }
#pragma mark 2.重命名文件夹
        if([fm moveItemAtPath:@"/Users/niit/fileoperate/aaa" toPath:@"/Users/niit/fileoperate/bbb" error:&error])
        {
            NSLog(@"移动成功");
        }
        else
        {
            NSLog(@"移动失败%@",error);
        }
#pragma mark 3.列出目录下文件
        
        // 方式1
        NSArray *files = [fm contentsOfDirectoryAtPath:@"/Users/niit/fileoperate/" error:&error];
        for (NSString *filePath in files)
        {
            NSLog(@"%@",filePath);
        }
        // 方式2
        NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:@"/Users/niit/fileoperate/"];
        NSString *path;
        path = [dirEnum nextObject];
        while (path!=nil)
        {
            NSLog(@"%@",path);
            path = [dirEnum nextObject];
        }
        
#pragma mark - NSFileHandle
        
        //1 打开文件
        NSFileHandle *f1 = [NSFileHandle fileHandleForReadingAtPath:@"/Users/niit/fileoperate/x1.txt"];// 读取方式打开
        if(![fm fileExistsAtPath:@"/Users/niit/fileoperate/x2.txt"])
        {
            [fm createFileAtPath:@"/Users/niit/fileoperate/x2.txt" contents:nil attributes:nil];
        }
        NSFileHandle *f2 = [NSFileHandle fileHandleForWritingAtPath:@"/Users/niit/fileoperate/x2.txt"];// 写入方式打开
        
        //2 读取、写入、追加
        
        // 2.1 移动文件操作指针
        // 文件操作指针一开始操作的位置都是0,可以通过seekToFileOffset seekToEndOfFile,移动到指定位置或者结尾
//        [f1 seekToFileOffset:9];// 设定读取开始的位置
        
        // 2.2 读取
//        NSData *data =  [f1 readDataOfLength:5];// 读取从当前位置开始5字节的数据,读了之后指针停在原位置+5
        NSData *data =  [f1 readDataToEndOfFile];// 读取从当前位置开始所有数据
        
        // 2.3 写入
//        [f2 seekToEndOfFile];// 从结尾开始写
//        [f2 seekToFileOffset:10];// 从指定位置开始写
        
        [f2 writeData:data];// 写入文件
        
        //3 关闭文件
        [f1 closeFile];
        [f2 closeFile];
        
#pragma mark - 文件操作练习
        
        // 1. NSFileManager 练习
        // - /Users/student/aaa  (目录)
        //                   |_  hello1.txt
        //                   |_  bbb (目录)
        
        //1)建目录:
        //  先使用Finder下，在用户目录下创建一个aaa文件夹,aaa下创建一个bbb
        //2)建文件
        //(修改"文本编辑.app"的"偏好设置" 格式里选择"纯文本",这样新建文本就是纯文本)
        //使用文本编辑器,创建一个纯文本文件,输入内容Hello Xcode!
        //文件保存在/Users/student/aaa下  命名为hello1.txt
        
        // 以下代码实现:
        //1)判断文件是否存在hello1.txt
        //2)复制文件命名为 hello2.txt hello3.txt hello4.txt
        //3)重命名文件hello2.txt -> olleh2.txt
        //4)删除hello3.txt
        //5)显示hello4.txt文件大小
        //6)显示hello4.txt文件内容
        //7)将hello1.txt的内容读出到NSData对象中,然后用读出的NSData数据新建文件hello5.txt
        //8)改变当前目录到/Users/aaa/bbb
        //9)创建目录abc
        //10)重命名目录cba
        //11)移动文件hello4.txt 到 ./cba/hello6.txt
        //*12)编写一个函数,传入一个路径,可以遍历显示路径下所有目录树,以下方式显示(使用/Users/student/aaa测试)
        // - /Users/student/aaa
        //                 |- hello1.txt
        //                 |- olleh2.txt
        //                 |- olleh5.txt
        //                 |- bbb
        //                    |- cba
        //                        |- hello6.txt
        
        // 2.NSFileHandle 练习
        //1) 创建一个date.txt文件
        //写一个程序每秒钟往date.txt追加写入一个当前时间
        //2015-01-11 11:20:00
        //2) 创建3个文件 test1.txt test2.txt test3.txt 内容随便写一些内容。编写程序，合并这3个文件的内容，到all.txt
        //3) 实用NSFileHandle复制一个视频文件,每次最多读取50字节,显示打印复制的进度,最后在播放器中打开这个视频，查看能否正常播放。
        
        // *3.综合练习
        //设计制作一个简单学生信息管理系统，并用文件实现保存数据
        //Student类
        //stuId 学号
        //stuName 学生姓名
        //stuAge 年龄
        //运行程序后，需要先读取之前保存的学生信息。
        //界面程序显示菜单：使用者可以输入相应的选项进入并进行相应的操作
        //1 列出已有的学生名单
        //2 添加学生信息
        //3 删除学生信息
        //4 保存退出
        //提示:
        //a 保存到文件
        //  将每个学生信息,用空格或者逗号分隔,创建类似@"10001,王晓明,18" 字符串,存入文件
        //  Example:
        //  10001,王晓明,18
        //  10002,张三,13
        //b 从文件中读取出数据
        //  每读出一行,用componentsSeparatedByString方法，使用空格分割变成数组,然后将数组中的对应的内容放入到Studetn对象中
        //  NSString *stuInfo=@"10001,王晓明,18";
        //  NSArray *arr=[stuInfo componentsSeparatedByString:@","];
        //  NSLog(@"%@",arr);
        
#pragma mark - NSError
        
        // NSError
//        @interface NSError : NSObject <NSCopying, NSSecureCoding> {
//        @private
//            void *_reserved;
//            NSInteger _code; // 错误码
//            NSString *_domain;// 错误域
//            NSDictionary *_userInfo;// 详细的错误信息
//        }
//        localizedDescription
        
        
        
    }
    return 0;
}
