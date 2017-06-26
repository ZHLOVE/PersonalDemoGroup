# iOS开发概述

## iOS技术层次
![](http://www.qiangtech.com/blog/wp-content/uploads/2016/01/083143561.png.jpeg)

## MVC设计模式

||||
|-|-|
|Model|模型|提供底层数据和方法|
|View|视图|一个iOS程序由一个或多个视图组成，一个视图由不同的屏幕控件组成|
|Control|控制器|一般与视图配对，对用户的输入做出反应|

![](http://www.qiangtech.com/blog/wp-content/uploads/2016/01/1345386770_6553.jpg)

## 开发设备

|设备|屏幕大小(单位:点 point pt)|缩放因子|实际分辨率(单位:像素 px)|
|-|-|-|
|iPhone4|320*480|2|640*960|
|iPhone5|320*518|2|640*1136|
|iPhone6|375*667|2|750*1334|
|iPhone6 Plus|414*736|3|1242*2208|
|iPad2|1024*768|1|1024*768|
|iPad4|1024*768|2|2048*1536|

##简单分析
开发步骤:

1. 搭建基本的软件界面 (UI UserInterface)
2. 获得网络数据 (网络请求、JSON)
3. 显示数据到软件界面 (Model、UITableView)

##UI界面的组成-对象
文本对象 UILabel

图片对象 UIImageView

按钮对象 UIButton

结论:UI界面上每一个元素都是对象

##UIKit框架

除了UILabel、UIButton、UIImageView以外,还有其他UI元素么?

* 苹果给开发者提供了一个非常强大的UIKit框架
* UIKit框架中包含了丰富多彩的各种UI元素
	* UISwitch
	* UISlider
	
##其他框架
学号UIKit框架就够了么?
* 首先UIKit框架非常重要,必须要学号(不学好UIKit框架，别说你做过iOS开发)
* 要想做一个出色完整的iOS应用,还需要学习非常多的框架,比如QuartzCore、MapKit、CoreLocation、AVFoundation等,每一个框架都有特定的使用功能。
* 站在巨人的肩膀上编程

##开发水平
简单->复杂 循序渐进