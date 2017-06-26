# 丰富的用户界面


## 什么是UIImageView
* UIKit框架提供了非常多的UI控件,但并不是每一个都很常用,有些控件可能一年内都用不上一次,有些控件天天用，比如UIButton,UILabel,UIImageView,UITableView等等
* UIImageView及其常用,功能比较单一:显示图片

## 什么是UILabel
* UILabel及其常用,功能比较专一:显示文字

## 什么是按钮
* 点击某个控件后,会做出相应的反应的一般都是按钮
* 按钮的功能比较多,技能显示文字,有能显示图片,还能随时调整内部图片和文字的位置

## UIButton的状态
* normal(普通状态)
	* 默认情况 (Default)
	* 对应的的枚举常量:UIControlStateNormal
* highlighted (高亮状态)
	* 按钮被按下去的时候(手指还未松开)
	* 对应的枚举常量:UIControlStateHighlighted
* disabled(失效状态)
	* 如果enabled属性为NO,就是出于disable状态,代表按钮不可以被点击
	* 对应的枚举常量:UIControlStateDisabled