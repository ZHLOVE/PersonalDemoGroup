# 160224星期三

##课程内容:
1. PickerView 双列依赖
2. PickerView 自定义
3. 模态视图
4. 页面值

##知识点:

####模型
- 专门用来存放数据的对象
- 一般都是一些直接继承自NSObject的纯对象
- 内部会提供一些属性来存放数据

####常见问题
- 项目里面的某个.m文件无法使用
    - 检查：Build Phases -> Compile Sources
- 项目里面的某个资源文件（比如plist、音频等）无法使用
    - 检查：Build Phases -> Copy Bundle Resources

####添加文件到项目时的正确选择
![](http://www.qiangtech.com/blog/wp-content/uploads/2016/02/添加文件到项目时的正确选择.png)

####模态窗口 
1. Storyboard连线方式
    * 直接按钮触发跳转
    * 代码指定沿着某根连线跳转
2. 代码创建对象，弹出方式 
    * 通过Storyboard中的场景创建新视图控制器对象,代码弹出
    * 通过xib创建新视图控制器对象,代码弹出

