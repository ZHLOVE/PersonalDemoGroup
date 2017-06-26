# 常用项目info.plist


####Application requires iPhone environment
如果应用程序不能在ipod touch上运行，设置此项为true；

####Application uses Wi-Fi
如果应用程序需要wi-fi才能工作，应该将此属性设置为true。这么做会提示用户，如果没有打开wi-fi的话，打开wi-fi。为了节省电力，iphone会在30分钟后自动关闭应用程序中的任何wi-fi。设置这一个属性可以防止这种情况的发生，并且保持连接处于活动状态

####Bundle display name
这用于设置应用程序的名称，它显示在iphone屏幕的图标下方。应用程序名称限制在10－12个字符，如果超出，iphone将缩写名称。

####Bundle identifier
这个为应用程序在iphone developer program portal web站点上设置的唯一标识符。（就是你安装证书的时候，需要把这里对应修改）。

####Bundle version
这个会设置应用程序版本号，每次部署应用程序的一个新版本时，将会增加这个编号，在app store用的。

####Icon already includes gloss and bevel effects
默认情况下，应用程序被设置了玻璃效果，把这个设置为true可以阻止这么做。

####Icon file（这个不用多说了）
设置应用程序图标的。

####Main nib file base name
应用程序首次启动时载入的xib文件 这个基本用不到。

####Initial interface orientation 
确定了应用程序以风景模式还是任务模式启动

####Localizations
多语言。应用程序本地化的一列表，期间用逗号隔开，例如应用程序支持英语 日语，将会适用 English,Japanese.

####Status bar is initially hidden 
设置是否隐藏状态栏。你懂的。

####Status bar style
选择三种不同格式种的一种。

####URL types
应用程序支持的url标识符的一个数组。

####在项目的Info.plist中添加以下内容
```
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

####UIFileSharingEnabled


下面是对这里可能出现的字段的解释：
Localiztion native development region --- CFBundleDevelopmentRegion 本地化相关，如果用户所在地没有相应的语言资源，则用这个key的value来作为默认.
Bundle display name --- CFBundleDisplayName 设置程序安装后显示的名称。应用程序名称限制在10－12个字符，如果超出，将被显示缩写名称。
Executaule file -- CFBundleExecutable 程序安装包的名称
Icon file --- CFBundleIconFile 应用程序图标名称,一般为icon.png
Bundle identifier --- CFBundleIdentifier 该束的唯一标识字符串，该字符串的格式类似com.yourcompany.yourapp，如果使用模拟器跑你的应用，这个字段没有用处，如果你需要把你的应用部署到设备上，你必须生成一个证书，而在生成证书的时候，在apple的网站上需要增加相应的app IDs.这里有一个字段Bundle identifier，如果这个Bundle identifier是一个完整字符串，那么文件中的这个字段必须和后者完全相同，如果app IDs中的字段含有通配符*，那么文件中的字符串必须符合后者的描述。
InfoDictionary version --- CFBundleInfoDictionaryVersion  Info.plist格式的版本信息
Bundle OS Type code -- CFBundlePackageType：用来标识束类型的四个字母长的代码,(网上找的，不解？？)
Bundle versions string, short --- CFBundleShortVersionString 面向用户市场的束的版本字符串,(网上找的，不解？？)
Bundle creator OS Type code --- CFBundleSignature：用来标识创建者的四个字母长的代码,(网上找的，不解？？)
Bundle version --- CFBundleVersion 应用程序版本号，每次部署应用程序的一个新版本时，将会增加这个编号，在app store上用的。
Application require iPhone environment -- LSRequiresIPhoneOS:用于指示程序包是否只能运行在iPhone OS 系统上。Xcode自动加入这个键，并将它的值设置为true。您不应该改变这个键的值。
Main nib file base name -- NSMainNibFile 这是一个字符串，指定应用程序主nib文件的名称。如果您希望使用其它的nib文件（而不是Xcode为工程创建的缺省文件）作为主nib文件，可以将该nib文件名关联到这个键上。nib文件名不应该包含.nib扩展名。这个字段可以删除，你可以参考我前面的文章，main函数研究。
supported interface orientations -- UISupportedInterfaceOrientations 程序默认支持的方向。
 
 
下面是转载的。
Application uses Wi-Fi
如果应用程序需要wi-fi才能工作，应该将此属性设置为true。这么做会提示用户，如果没有打开wi-fi的话，打开wi-fi。为了节省电力，iphone会在30分钟后自动关闭应用程序中的任何wi-fi。设置这一个属性可以防止这种情况的发生，并且保持连接处于活动状态