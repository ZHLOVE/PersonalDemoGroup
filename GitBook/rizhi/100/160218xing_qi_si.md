# 160218星期四

####教学内容
1. 安装Xcode插件
2. 104 引起用户注意
    * UIAlertView
        * 简单提示框
        * 多按钮提示框
        * 带输入框的提示框
    * UIActionView
    * UIActionViewController(待)
3. 105 丰富的界面控件
    * 例子ControlFun. 

####练习与作业:
1. 10401 Attention
2. 10402 Attention_code
3. 10501 ControlFun
4. 10502 ControlFun_code
5. 在git.oschina.net建一个project,叫homework，把我的账号ruik@foxmail.com加入到开发者,后面的作业写完了就放进去并提交
6. *10403 百度搜索一下UIAlertController的用法(替代UIAlertView UIActionSheet的新类)，改写10401，用UIAlertController实现

***
##1 安装Xcode插件

1. 终端下运行以下命令:
```
curl -fsSL https://raw.github.com/alcatraz/Alcatraz/master/Scripts/install.sh | sh
```
2. 重新运行Xcode,选择Load Bundle

3. 选择Xcode菜单中Window下的Package Manager管理插件
搜索安装
    1. VVDocumenter-Xcode
    2. KSImageNamed-Xcode

***
##2 UIAlertView类

##3 UIActionSheet类


##4 UIButton背景图片
设置doSomething按钮的背景(需要对提供的图片进行拉伸设置）
#####1) 代码方式

```objc
// 代码实现设置按钮的背景图片
UIImage *img1 = [UIImage imageNamed:@"whiteButton"];
UIImage *img2 = [UIImage imageNamed:@"blueButton"];

// 创建拉伸的图片 (左右各留12像素不拉伸)
UIEdgeInsets insets = UIEdgeInsetsMake(0, 12, 0, 12);// 上左下右
UIImage *img3 = [img1 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
UIImage *img4 = [img2 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];

[self.doSomethingBtn setBackgroundImage:img3 forState:UIControlStateNormal];
[self.doSomethingBtn setBackgroundImage:img4 forState:UIControlStateHighlighted];
```
#####2) Assets方式 
删除原来拖到项目中的图片，重新拉图片放在Assets.scassets中,用Assets.scassets管理图片。
设置需要拉伸的图片的切片,图片被使用的时候会自动拉伸


