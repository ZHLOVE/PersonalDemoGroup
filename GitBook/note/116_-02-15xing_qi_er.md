# 1_16-02-15_星期二

##App Icon on iPad and iPhone

<xcdoc://?url=developer.apple.com/library/etc/redirect/xcode/ios/1151/qa/qa1686/_index.html>


##Xcode定位到项目导航栏快捷键
cmd+shift+j


##提交问题

使用gitbox,commit出现:

fatal: pathspec 'DSWeibo/DSWeibo/Assets.xcassets/Brand Assets.launchimage/Contents.json' did not match any files

使用命令
git add ./
git commit -m "初始化项目"
git push
正常

##疑问?

```
DSWeibo
Optional(DSWeibo.HomeTableViewController)
<DSWeibo.HomeTableViewController: 0x7fc58ada5100>
DSWeibo
Optional(DSWeibo.MessageTableViewController)
<DSWeibo.MessageTableViewController: 0x7fc58ac37ef0>
DSWeibo
Optional(DSWeibo.DiscoverTableViewController)
<DSWeibo.DiscoverTableViewController: 0x7fc58af0f7b0>
DSWeibo
Optional(DSWeibo.ProfileTableViewController)
<DSWeibo.ProfileTableViewController: 0x7fc58ac37ef0>
```
为什么第二个对象和第四个对象是同一地址?


原因:
创建的对象未被加入到父对象，局部变量指向的对象被销毁了，内存空出来用于创建了新对象。
添加加入到父对象的代码，后地址不一样了。

```
DSWeibo
Optional(DSWeibo.HomeTableViewController)
<DSWeibo.HomeTableViewController: 0x7fd91150d4b0>
DSWeibo
Optional(DSWeibo.MessageTableViewController)
<DSWeibo.MessageTableViewController: 0x7fd911720010>
DSWeibo
Optional(DSWeibo.DiscoverTableViewController)
<DSWeibo.DiscoverTableViewController: 0x7fd911739ac0>
DSWeibo
Optional(DSWeibo.ProfileTableViewController)
<DSWeibo.ProfileTableViewController: 0x7fd91174aef0>
```