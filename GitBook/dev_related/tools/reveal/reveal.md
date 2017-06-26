# Reveal

##Step1 拖Reveal框架文件到项目中
Reveal 菜单Help->Show Reveal Library In Finder
Reveal.framework 拖到Xcode项目中

##Step2 修改编译选项,添加链接相关的标识
Xcode项目中
Build Settings中
Other Linker Flags 添加 -ObjC

##Step3 添加libz库
Xcode项目中
Build Phases中
Link Binary With Libraries 添加 libz

##Step4 运行项目
项目运行之后Log中显示: 则这个框架运行成功
INFO: Reveal Server started (Protocol Version 25).

##Step5
在Reveal软件中选择查看