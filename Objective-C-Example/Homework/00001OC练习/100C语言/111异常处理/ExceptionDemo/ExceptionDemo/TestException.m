//
//  TestException.m
//  ExceptionDemo
//
//  Created by qiang on 16/1/26.
//  Copyright © 2016年 Qiangtech. All rights reserved.
//

#import "TestException.h"

@implementation TestException

#pragma mark - 异常
- (void)test
{
    // 1
    NSLog(@"step 1");
    [self tryTwo];
    
    // 2
    NSLog(@"step 2");
}

//tryTwo方法代码：
- (void)tryTwo
{
    // 3
    NSLog(@"step 3");
    
    // 异常例子1 越界
    // 越界1
//    NSString *str = @"abc";
//    [str substringFromIndex:111];// 异常
//    [str substringFromIndex:1];// 正常
    // 越界2
//    NSArray *arr = @[@1,@2];
//    arr[3];
    
    // 异常例子2 发送给对象一个未知的消息
//    NSObject *o = [[NSObject alloc] init];
//    [o performSelector:@selector(noMethod) withObject:nil];
    
    // 异常例子3 数组问题
//    NSMutableArray *arr = [@[@1,@2,@3,@3,@4,@5] mutableCopy];
//    for(int i=0;i<arr.count;i++) // 这个不会异常,但是还有个3没删除
//    {
//        if([arr[i] integerValue] == 3)
//        {
//            [arr removeObjectAtIndex:i];
//        }
//    }
//    for(NSNumber *n in arr)
//    {
//        if([n intValue] == 3)
//        {
//            [arr removeObject:n];// 在遍历过程中,数组变动了,异常
//        }
//    }
//    NSLog(@"%@",arr);
    
    // 异常例子 4 自定义异常对象,抛出
//    NSException *exception = [[NSException alloc] initWithName:@"ExceptionName"
//                                                        reason:@"ExceptionReason"
//                                                      userInfo:nil];
//    @throw exception;
    
    // 4
    NSLog(@"step 4");
}

// 错误信息1:
//2016-01-26 11:22:17.452 ExceptionDemo[7463:150176] step 1
//2016-01-26 11:22:17.453 ExceptionDemo[7463:150176] step 3
//2016-01-26 11:22:17.464 ExceptionDemo[7463:150176] *** Terminating app due to uncaught exception 'NSRangeException', reason: '*** -[__NSCFConstantString substringFromIndex:]: Index 111 out of bounds; string length 3'
//*** First throw call stack:
//(
//	0   CoreFoundation                      0x00007fff8cc28ae2 __exceptionPreprocess + 178
//	1   libobjc.A.dylib                     0x00007fff92b3ef7e objc_exception_throw + 48
//	2   CoreFoundation                      0x00007fff8cc2898d +[NSException raise:format:] + 205
//	3   Foundation                          0x00007fff95c6d1c6 -[NSString substringFromIndex:] + 126
//	4   ExceptionDemo                       0x0000000100000e4e -[TestException tryTwo] + 78
//	5   ExceptionDemo                       0x0000000100000ddc -[TestException test] + 60
//	6   ExceptionDemo                       0x0000000100000d7e main + 94
//	7   libdyld.dylib                       0x00007fff8d87c5ad start + 1
//	8   ???                                 0x0000000000000001 0x0 + 1
// )
//libc++abi.dylib: terminating with uncaught exception of type NSException
//(lldb)

// 错误信息:(数组越界)
//2016-01-26 13:26:10.717 ExceptionDemo[11189:209709] *** Terminating app due to uncaught exception 'NSRangeException', reason: '*** -[__NSArrayI objectAtIndex:]: index 3 beyond bounds [0 .. 1]'
//*** First throw call stack:
//(
//	0   CoreFoundation                      0x00007fff8cc28ae2 __exceptionPreprocess + 178
//	1   libobjc.A.dylib                     0x00007fff92b3ef7e objc_exception_throw + 48
//	2   CoreFoundation                      0x00007fff8caf3554 -[__NSArrayI objectAtIndex:] + 164
//	3   ExceptionDemo                       0x0000000100000e04 -[TestException tryTwo] + 244
//	4   ExceptionDemo                       0x0000000100000cec -[TestException test] + 60
//	5   ExceptionDemo                       0x0000000100000c8e main + 94
//	6   libdyld.dylib                       0x00007fff8d87c5ad start + 1
//	7   ???                                 0x0000000000000001 0x0 + 1
// )
//libc++abi.dylib: terminating with uncaught exception of type NSException
//(lldb)

// 错误信息2:
//2016-01-26 11:24:28.881 ExceptionDemo[7605:152129] step 1
//2016-01-26 11:24:28.882 ExceptionDemo[7605:152129] step 3
//2016-01-26 11:24:28.883 ExceptionDemo[7605:152129] -[NSObject noMethod]: unrecognized selector sent to instance 0x100c03940
//2016-01-26 11:24:28.884 ExceptionDemo[7605:152129] *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[NSObject noMethod]: unrecognized selector sent to instance 0x100c03940'
//*** First throw call stack:
//(
//	0   CoreFoundation                      0x00007fff8cc28ae2 __exceptionPreprocess + 178
//	1   libobjc.A.dylib                     0x00007fff92b3ef7e objc_exception_throw + 48
//	2   CoreFoundation                      0x00007fff8cc2bb9d -[NSObject(NSObject) doesNotRecognizeSelector:] + 205
//	3   CoreFoundation                      0x00007fff8cb64601 ___forwarding___ + 1009
//	4   CoreFoundation                      0x00007fff8cb64188 _CF_forwarding_prep_0 + 120
//	5   ExceptionDemo                       0x0000000100000e7e -[TestException tryTwo] + 110
//	6   ExceptionDemo                       0x0000000100000dec -[TestException test] + 60
//	7   ExceptionDemo                       0x0000000100000d8e main + 94
//	8   libdyld.dylib                       0x00007fff8d87c5ad start + 1
//	9   ???                                 0x0000000000000001 0x0 + 1
// )
//libc++abi.dylib: terminating with uncaught exception of type NSException
//(lldb)

#pragma mark - 处理异常
//- (void)test
//{
//    @try
//    {
//        // 1
//        NSLog(@"step 1");
//        [self tryTwo];
//    }
//    @catch (NSException *exception)
//    {
//        // 2
//        NSLog(@"step 2");
//        NSLog(@"%s\n%@", __FUNCTION__, exception);
//        // @throw exception;
//    }
//    @finally
//    {
//        // 3
//        NSLog(@"step 3");
//        NSLog(@"我一定会执行");
//    }
//    // 4
//    // 这里一定会执行
//    NSLog(@"step 4");
//}
//
////tryTwo方法代码：
//- (void)tryTwo
//{
//    @try
//    {
//        // 5
//        NSLog(@"step 5");
//        NSString *str = @"abc";
////        [str substringFromIndex:111];// 异常
//        [str substringFromIndex:1];// 正常
//        
//        // 程序到这里会崩
//    }
//    @catch (NSException *exception)
//    {
//        // 6
//        // 抛出异常，即由上一级处理
////        NSLog(@"step 6");
////        @throw exception;
//        
//        // 7
//        NSLog(@"step 7");
//        NSLog(@"%s\n%@", __FUNCTION__, exception);
//    }
//    @finally
//    {
//        // 8
//        NSLog(@"step 8");
//        NSLog(@"tryTwo - 我一定会执行");
//    }
//    // 9
//    // 如果抛出异常，那么这段代码则不会执行
//    NSLog(@"step 9");
//    NSLog(@"如果这里抛出异常，那么这段代码则不会执行");
//}

// 如果正常
// 1 -> 5 -> 8 -> 9 -> 3 -> 4
// 如果第6步抛出异常让上一级处理
// 1 -> 5 -> 6 -> 8 -> 2 -> 3 -> 4
// 第六步不抛异常让上一级处理
// 1 -> 5 -> 7 -> 8 -> 9 -> 3 -> 4

@end
