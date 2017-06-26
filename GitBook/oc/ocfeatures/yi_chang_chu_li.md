# 异常处理

在开发APP时，我们有时候需要捕获异常，防止应用程序突然的崩溃，防止给予用户不友好的一面。

异常处理是管理非典型事件（例如未被识别的消息）的过程，此过程将会中断正常的程序执行。如果没有足够的错误处理，遇到非典型事件时，程序可能立刻抛出（或者引发）一种被称之为异常的东西，然后结束运行。

格式:
```objc]]]
@try 
{  
    // 可能会出现崩溃的代码
}
@catch (NSException *exception) 
{  
    // 捕获到的异常exception
}
@finally 
{  
    // 结果处理
}
```

抛出异常
```
@throw exception;
```

实例:

```
- (void)test
{
    @try
    {
        // 1
        NSLog(@"step 1");
        [self tryTwo];
    }
    @catch (NSException *exception)
    {
        // 2
        NSLog(@"step 2");
        NSLog(@"%s\n%@", __FUNCTION__, exception);
        // @throw exception;
    }
    @finally
    {
        // 3
        NSLog(@"step 3");
        NSLog(@"我一定会执行");
    }
    // 4
    // 这里一定会执行
    NSLog(@"step 4");
}

//tryTwo方法代码：
- (void)tryTwo
{
    @try
    {
        // 5
        NSLog(@"step 5");
        NSString *str = @"abc";
//        [str substringFromIndex:111];// 异常
        [str substringFromIndex:1];// 正常
        
        // 程序到这里会崩
    }
    @catch (NSException *exception)
    {
        // 6
        // 抛出异常，即由上一级处理
//        NSLog(@"step 6");
//        @throw exception;
        
        // 7
        NSLog(@"step 7");
        NSLog(@"%s\n%@", __FUNCTION__, exception);
    }
    @finally
    {
        // 8
        NSLog(@"step 8");
        NSLog(@"tryTwo - 我一定会执行");
    }
    // 9
    // 如果抛出异常，那么这段代码则不会执行
    NSLog(@"step 9");
    NSLog(@"如果这里抛出异常，那么这段代码则不会执行");
}

// 如果正常
// 1 -> 5 -> 8 -> 9 -> 3 -> 4
// 如果第6步抛出异常让上一级处理
// 1 -> 5 -> 6 -> 8 -> 2 -> 3 -> 4
// 第六步不抛异常让上一级处理
// 1 -> 5 -> 7 -> 8 -> 9 -> 3 -> 4

```