# 160219星期五
***
1 105作业
2 思考

***
## gitoschina创建项目,并提交作业

1. git.oschina.net创建项目 
    1. 项目名 homework
    2. 项目介绍 可空
    3. 项目语言 Objective-C
    4. Gitignore Objective-C .gitignore
    5. 开源许可证 可以不选
    6. 项目属性 私有或公有都可以
    7. Remdme 说明文件
    8. 点击创建
    9. 创建好之后可以得到如以下项目地址 https://git.oschina.net/ruik2080/homework_qiang.git
    10. 管理->项目成员管理->添加项目成员
         将我的账号ruik@foxmail.com及你项目的组长的git账号添加到项目里
2. 空项目下载到本地目录
    点击+号按钮,点击Clone Repository
3. 将作业项目复制到目录里(这个项目不能已有git管理)
4. gitbox commit 并push


## NSString 字符串替换
```objc
NSString *s = @"姓名:<name> 年龄:<age>";
NSLog(@"%@",[[s stringByReplacingOccurrencesOfString:@"<name>" withString:@"小明"] stringByReplacingOccurrencesOfString:@"<age>" withString:@"18"]);
```
