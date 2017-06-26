# UIApplication

先参考:http://www.cnblogs.com/wendingding/p/3766347.html

##简介
1. UIApplication对象是应用程序的象征，一个UIApplication对象就代表一个应用程序。

2. 每一个应用都有自己的UIApplication对象，而且是单例的，如果试图在程序中新建一个UIApplication对象，那么将报错提示。

3. 通过[UIApplicationsharedApplication]可以获得这个单例对象

4. 一个iOS程序启动后创建的第一个对象就是UIApplication对象，且只有一个（通过代码获取两个UIApplication对象，打印地址可以看出地址是相同的）。

5. 利用UIApplication对象，能进行一些应用级别的操作