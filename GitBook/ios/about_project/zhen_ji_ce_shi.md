# 真机测试

1. 注册开发者账号
https://developer.apple.com/
如果已有AppleID,只需要登陆一下同意一下协议
2. 打开XCode,点击Xcode菜单 Perference
  点Accounts
  登陆你的账号
3. 选中账号，点View Details
4. iOS Development 点Create
5. 关掉Preference,项目设置里，Team选你的账号，然后下面点Fix issue
6. 然后运行设备里选你的手机,点运行，项目的Deployment Target的版本要<=你手机的iOS版本，
7. 然后手机里通用->描述文件->你的账号->选择允许（需要网络,如果有问题，切换至流量试下)
8. 再次运行程序