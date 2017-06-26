# 项目允许透明传输

在项目的Info.plist中添加以下内容
```
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```