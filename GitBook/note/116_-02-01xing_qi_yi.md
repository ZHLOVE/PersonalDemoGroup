# 1_16-02-01_星期一

### 问题用Xcode7.1新建playground界面报错
Unable to find execution service for selected run destination

解决方法:
1. 关闭Xcode
2. 在终端执行两行代码

```
rm -rf ~/Library/Developer/CoreSimulator/Devices
killall -9 com.apple.CoreSimulator.CoreSimulatorService
```

[来源:]<http://www.jianshu.com/p/0a406d50ecfd>