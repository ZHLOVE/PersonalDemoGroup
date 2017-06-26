# NSError

参考资料:<http://www.cnblogs.com/xiaodao/archive/2012/07/04/2576292.html>

##NSError对象中,主要有三个私有变量:
* 错误域（NSInteger）： _domain
* 错误标示（NSString *）：_code
* 错误详细信息（NSDictionary *）：_userInfo

通常用_domain和_code一起标识一个错误信息


```
#define CustomErrorDomain @"com.niit.errortest"

typedef enum {
　　  XDefultFailed = -1000,
　　  XRegisterFailed,
　　  XConnectFailed,
　　  XNotBindedFailed
}CustomErrorFailed;
 
NSDictionary *userInfo = @{NSLocalizedDescriptionKey:@"错误描述信息"};
NSError *aError = [NSError errorWithDomain:CustomErrorDomain code:XDefultFailed userInfo:userInfo];
```
* 其中，自定义错误域对象CustomErrorDomain，通常用域名反写，也可以是任何其他字符串
* code错误标识, 系统的code一般都大于零，自定code可以用枚举（最好用负数, 但不是必须的）
* userInfo自定义错误信息，NSLocalizedDescriptionKey是NSError头文件中预定义的键，标识错误的本地化描述
可以通过NSError的localizedDescription方法获得对应的值信息