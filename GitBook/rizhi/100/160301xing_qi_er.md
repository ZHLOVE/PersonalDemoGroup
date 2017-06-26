# 160301星期二


##NSUserDefaults
* 轻量级存储
* 通过键值方式，类似字典
* 存储位置是该应用程序的沙盒目录下 Library/Preferences/


1. 得到NSUserDefault对象
```objc
NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
```
3. 保存信息
```objc
// 设置
[userDefault setObject:version forKey:@"lastOpenVersion"];
// 同步(保存)
[userDefault synchronize];
```        
3. 读取信息

```objc
NSString *lastVersion = [userDefault objectForKey:@"lastOpenVersion"];
```

##得到沙盒目录的地址
```objc
NSLog(@"%@",NSHomeDirectory());
```





```