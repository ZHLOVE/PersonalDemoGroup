# CocoaPods与第三方库

#1先确认student有管理功能
先在系统偏好设置->用户群组
student账号设置为可管理

#2安装cocopods
##1)移除原先的源
gem sources --remove https://rubygems.org/

##2)添加国内的源
gem sources -a https://ruby.taobao.org/

注意是 https

##3)进行安装 需要输入student的密码
sudo gem install cocoapods

##4)
pod setup
会比较慢,耐心等待

##5)查找pop动画库
pod search pop


如果最后显示: 就是安装正常了
-> pop (1.0.8)
   Extensible animation framework for iOS and OS X.
   pod 'pop', '~> 1.0.8'
   - Homepage: https://github.com/facebook/pop
   - Source:   https://github.com/facebook/pop.git
   - Versions: 1.0.8, 1.0.7, 1.0.6, 1.0.5, 1.0.4, 1.0.3, 1.0.2, 1.0.1, 1.0.0 [master repo]

# 3项目中使用pod
##1)项目跟目录下创建一个Podfile文件
内容:
pod 'pop', '~> 1.0.8'

##2)用pod管理项目
打开终端,输入运行命令行下:
cd 项目目录 
pod install

安装完毕后,使用CocoaPods
  
  
# 4 项目中删除Cocoapods
1)删除工程文件夹下的Podfile、Podfile.lock及Pods文件夹
2)删除xcworkspace文件使用xcodeproj文件打开工程，
3)删除Frameworks组下的Pods.xcconfig及libPods.a引用在工程设置中的Build Phases下
4)删除Check Pods Manifest.lock及Copy Pods Resources
