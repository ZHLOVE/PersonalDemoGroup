# 程序错误处理

## 1. 编译错误

* 编译错误,一般指语法上的错误.
    
如:

```
int a
```
报错信息:

```
Expected ';' at end of declaration
```
    
## 2. 链接错误

* 函数只声明没有具体的定义,或者.m文件没有加入项目参与编译。

```
// 链接错误1:
//Ld ...
//Undefined symbols for architecture x86_64:
//"_func1", referenced from:
//_main in main.o
//ld: symbol(s) not found for architecture x86_64
//clang: error: linker command failed with exit code 1 (use -v to see invocation)
```
原因:main.m中调用了func1函数,但函数没有具体的定义.

* 函数在两个.m文件中重复定义.

```
// 链接错误2:
//Ld ...
//
//duplicate symbol _func2 in:
///Users/qiang/Library/Developer/Xcode/DerivedData/ExceptionDemo-grrmffxzlxfcntfidisruffirymu/Build/Intermediates/ExceptionDemo.build/Debug/ExceptionDemo.build/Objects-normal/x86_64/main.o
///Users/qiang/Library/Developer/Xcode/DerivedData/ExceptionDemo-grrmffxzlxfcntfidisruffirymu/Build/Intermediates/ExceptionDemo.build/Debug/ExceptionDemo.build/Objects-normal/x86_64/TestLinkError.o
//ld: 1 duplicate symbol for architecture x86_64
//clang: error: linker command failed with exit code 1 (use -v to see invocation)
```
原因:func2在main.m和TestLinkError.m中重复定义.


##3. 运行时异常

* 越界

```
// 越界1
NSString *str = @"abc";
[str substringFromIndex:111];// 异常
[str substringFromIndex:1];// 正常
// 越界2
NSArray *arr = @[@1,@2];
arr[3];
```
    
* 发送给对象一个未知的消息

```    
NSObject *o = [[NSObject alloc] init];
[o performSelector:@selector(noMethod) withObject:nil];
```
    
* 数组问题

```    
NSMutableArray *arr = [@[@1,@2,@3,@3,@4,@5] mutableCopy];
for(int i=0;i<arr.count;i++) // 这个不会异常,但是还有个3没删除
{
    if([arr[i] integerValue] == 3)
    {
        [arr removeObjectAtIndex:i];
    }
}
for(NSNumber *n in arr)
{
    if([n intValue] == 3)
    {
        [arr removeObject:n];// 在遍历过程中,数组变动了,异常
    }
}
NSLog(@"%@",arr);
```
    
* 自定义异常对象,抛出

```    
NSException *exception = [[NSException alloc] initWithName:@"ExceptionName"
                                                    reason:@"ExceptionReason"
                                                  userInfo:nil];
@throw exception;
```