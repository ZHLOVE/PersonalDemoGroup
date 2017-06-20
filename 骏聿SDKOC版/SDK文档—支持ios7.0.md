<link rel="stylesheet" href="http://yandex.st/highlightjs/8.0/styles/solarized_dark.min.css">
<script src="http://yandex.st/highlightjs/8.0/highlight.min.js"></script>
<script>hljs.initHighlightingOnLoad();</script>




#SafeDark OC版本SDK文档—支持iOS7.0

##导入SDK
1. 直接将SDK文件拖入项目中：
![JT1.png](http://o9rpnyegw.bkt.clouddn.com/JT1.png)

JYNetwork
+  SDK文件包含的内容：
![JT3.png](http://o9rpnyegw.bkt.clouddn.com/JT3.png)

+ 设置Build Settings->Linking->Other Linker Flags中加上`-all_load`
![JT2.png](http://o9rpnyegw.bkt.clouddn.com/JT2.png)

+ 设置Build Phases->LBWL->添加libc++.tbd【添加任意c++文件即可】
![JT4.png](http://o9rpnyegw.bkt.clouddn.com/JT4.png)

+ 项目中引入头文件


```
//网络请求
#import "JYNetwork.h"  
//照片打分
#import "JYGrade.h"
//也可以直接引入SafeDark
#import "SafeDark.h" 
```

 
##调用JYNetwork
+ Network初始化,初始化需要传入appKey,appSecret两个参数。  
  
  	
    
```
	/*
	APP_KEY,APP_SECRET为在SDK后台申请密钥
    */
 	JYNetwork *network = [JYNetwork sharedNetwork];//使用单例
    [network setAppKey:appKey appSecret:appSecret];
```



+ 创建照片任务

```
	/*
	beginColor和endColor参数用于生成照片背景色
    请在颜色列表中查找beginColor和endColor参数
    SpecKey是将要生成的规格参数KEY,请在规格列表中查找SpecKey参数
    */
   	UIImage *img = [UIImage imageNamed:@"测试照片.jpg"];
    [JYNetwork createTask:img
               beginColor:16777215
                 endColor:16777215
                  SpecKey:specKey
             successBlock:^(NSDictionary *dict) {
                 NSLog(@"任务ID\n%@",dict[@"task_id"]);
             } failBlock:^(NSString *errorMessage) {
                 NSLog(@"%@",errorMessage);
             }];
```


+ 获取任务信息

```	
	/*
	taskId就是在创建照片任务请求中得到的
	任务状态：SUCCESS 成功；PENDING 等待处理；STARTED 开始处理；RETRY 重试; FAILURE 失败
	只有SUCCESS状态下才有image_preview_url:预览图url
	只有FAILURE状态下才有description:失败原因
	STARTED状态表示开始处理了，PENDING状态表示正在处理,RETRY表示需要重试。
	出现STARTED、PENDING、RETRY这三种状态中任意一种，都可以再请求一次。
	*/
    [JYNetwork getTaskState:taskId successBlock:^(NSDictionary *dict) {
        NSLog(@"任务状态%@",dict[@"status"]);
        NSLog(@"预览图URL%@",dict[@"image_preview_url"]);
        NSLog(@"描述%@",dict[@"description"]);
    } failBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
```

+ 创建订单

```
	/*
	创建订单时候taskId不能为空
	taskId就是在创建照片任务请求中得到的
	*/
    if (taskId != nil) {
        [JYNetwork createOrder:taskId successBlock:^(NSDictionary *dict) {
            if (dict[@"message"] !=nil) {
                NSString *str = dict[@"message"];
                NSLog(@"%@",str);
            }else{
                NSDictionary *order = dict[@"order"];
                NSLog(@"ID\n%@",order[@"id"]);
                NSLog(@"订单号\n%@",order[@"order_no"]);
                NSLog(@"付款时间\n%@",order[@"paid_at"]);
                NSLog(@"付款状态\n%@",order[@"state"]);  //注意付款状态有已创建created和已付款paid,目前只会返回paid,建议使用时候判断一下。
            }
        } failBlock:^(NSString *errorMessage) {
            NSLog(@"%@",errorMessage);
        }];
    }
```


+ 获取订单对应的证件照URL

```
	//获取订单时候order_no不能为空
	//order_no就是在创建订单时得到的订单号
    if (order_no != nil) {
        [JYNetwork getURLofOrder:order_no successBlock:^(NSDictionary *dict) {
            NSLog(@"%@",dict);
        } failBlock:^(NSString *errorMessage) {
            NSLog(@"%@",errorMessage);
        }];
    }
```



##调用JYGrade获得照片评分

```

    UIImage *img = [UIImage imageNamed:@"测试照片.jpg"];
    NSDictionary *dict = [JYGrade getScore:img];
    for (NSString *key in dict) {
    	//评分项目--->分数
        NSLog(@"%@ --> %@",key,dict[key]);
    }
    
```
![JT6.png](http://o9rpnyegw.bkt.clouddn.com/JT6.png)







