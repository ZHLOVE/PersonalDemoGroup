//
//  main.m
//  FileHandle练习
//
//  Created by niit on 16/1/12.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DateSaver.h"

// 返回值类型 函数名(参数类型 形参1,参数类型 形参2)
//{
//    return 结果;
//}

// 思路: 逐步增加功能。 把大问题-> 一个个小问题
// 1 列出文件
// 2 如果是子目录,递归调用自己去列出
// 3 解决空格问题

// 大问题 -> 流程 流程1 -> 流程2 -> ...

void printDirectoryTree(NSString * path,int spaceCount)
{
    if(spaceCount == 0)
    {
        NSLog(@"%@",path);
        
        spaceCount = path.length-path.lastPathComponent.length+2;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    NSArray *files = [fm contentsOfDirectoryAtPath:path error:&error];
    for (NSString *filePath in files)
    {
        // 文件名 目录名
        NSString *childPath = [path stringByAppendingPathComponent:filePath];// 子文件完整路径
        // 得到文件的信息
        NSDictionary *infoDict =  [fm attributesOfItemAtPath:childPath error:&error];
        
        // 列出出
        if(![filePath hasPrefix:@"."])
        {
            // 添加空格
            NSMutableString *mStr = [NSMutableString string];
            for(int i=0;i<spaceCount;i++)
            {
                [mStr insertString:@" " atIndex:0];
            }
            [mStr appendString:[NSString stringWithFormat:@"|-%@",filePath]];
            
            NSLog(@"%@",mStr);
        }
        // 如果是子目录,还得显示子目录的子文件
        if([infoDict[NSFileType] isEqualToString:NSFileTypeDirectory])
        {
            printDirectoryTree(childPath,spaceCount+2);
        }
        
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        //*12)编写一个函数,传入一个路径,可以遍历显示路径下所有目录树,以下方式显示(使用/Users/student/aaa测试)
        // - /Users/student/aaa
        //                 |- hello1.txt
        //                 |- olleh2.txt
        //                 |- olleh5.txt
        //                 |- bbb
        //                    |- cba
        //                        |- hello6.txt
//        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"aaa"];
//        printDirectoryTree(path,0);
        
        //写一个程序每秒钟往date.txt追加写入一个当前时间
        //2015-01-11 11:20:00
//        DateSaver *d = [[DateSaver alloc] init];
//        [[NSRunLoop currentRunLoop] run];
        
        //3) 实用NSFileHandle复制一个视频文件,每次最多读取50字节,显示打印复制的进度,最后在播放器中打开这个视频，查看能否正常播放。
        
        //1 打开文件
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *f1Name = [NSHomeDirectory() stringByAppendingString:@"/1.mp4"];
        NSString *f2Name = [NSHomeDirectory() stringByAppendingString:@"/2.mp4"];
        
        NSFileHandle *f1 = [NSFileHandle fileHandleForReadingAtPath:f1Name];// 读取方式打开
        if(![fm fileExistsAtPath:f2Name])
        {
            [fm createFileAtPath:f2Name contents:nil attributes:nil];
        }
        NSFileHandle *f2 = [NSFileHandle fileHandleForWritingAtPath:f2Name];// 写入方式打开
        
        // 得到文件大小信息
        NSError *error;
        NSDictionary *d = [fm attributesOfItemAtPath:f1Name error:&error];
        if(error!=nil)
        {
            NSLog(@"错误信息:%@",error);
        }
        NSUInteger size = [d[NSFileSize] intValue];// 要读取的长度
        NSUInteger readed = 0;//已经读取的
        
        int percent =0;
        while (readed < size)
        {
            // 要读取的长度
            int needRead = readed+50<size ? 50:size-readed;
            NSData *data;
            data =  [f1 readDataOfLength:needRead];// 读取从当前位置开始所有数据,操作指针就会后移到读取完的位置
            [f2 writeData:data];// 写入文件，
            readed += needRead;
            
            // 显示百分率
            int curPercent = readed*100/size;
            if(percent != curPercent)
            {
                NSLog(@"%lu %%",curPercent);
                percent = curPercent;
            }
        }
        //3 关闭文件
        [f1 closeFile];
        [f2 closeFile];
        
    }
    return 0;
}
