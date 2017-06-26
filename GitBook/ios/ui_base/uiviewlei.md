# UIView类

## 什么是控件?
* 屏幕上的所有UI元素都叫做控件(也有叫做视图、组件)
* 比如按钮(UIButton) 文本(UILabel）都是控件

## 控件的共同属性有哪些?
* 尺寸
* 位置
* 背景色

## UIView是什么?
UIView表示屏幕上的一块矩形区域，它在App中占有绝对重要的地位，因为IOS中几乎所有可视化控件都是UIView的子类。负责渲染区域的内容，并且响应该区域内发生的触摸事件

## 苹果将控件的共同属性都抽取到父类UIView中
* 所有的控件最终都继承自UIView
* UIButton UILabel都继承自UIView(可以查看头文件验证)

## UIView的功能?
1. 管理矩形区域里的内容
2. 处理矩形区域中的事件
3. 子视图的管理 
4. 还能实现动画
5. UIView的子类也具有这些功能 

## 父控件、子控件
* 每个控件都是一个容器,能容纳其他控件
* 内部小空间是大控件的子控件
* 大控件是内部小控件的父控件
* 每一个控制器(UIViewController)内部都有个默认的UIView属性


## UIView的常见属性

```
@property (nonatomic,readonly) UIView *superview;// 得到自己的父控件对象
@property (nonatomic,readonly,copy) NSArray *subviews;// 得到自己的子控件对象数组
@property (nonatomic) NSInteger tag;// 空间的ID(标识),父控件可以通过tag找到对应的子控件
@property (nonatomic) CGAffineTransform transform;
@property (nonatomic) CGRect frame;// 控件矩形框在父控件中的位置和尺寸(以父控件的左上角为坐标原点)
@property (nonatomic) CGRect bounds;// 控件矩形框的位置和尺寸(以自己左上角为坐标原点)
@property (nonatomic) CGPoint center;// 控件中点的位置(以父控件的左上角为坐标原点)
```

## UIView的常见方法

```objc
- (void)addSubview:(UIView *)view;// 添加一个子控件view,子控件会添加到subviews数组的最后
- (void)removeFromSuperview;// 从父控件中移除
- (UIView *)viewWithTag:(NSInteger)tag;// 根据一个tag标识找出对应的控件
// 将子控件view放到子控件siblingSubview的下面
- (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview;
// 将子控件view放到子控件siblingSubview的上面
- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview;
// 将子控件view放到数组的最后面,显示在最上面
- (void)bringSubviewToFront:(UIView *)view;
// 将子控件view放到数组的最前面,显示在最下面
- (void)sendSubviewToBack:(UIView *)view;
```

## 可能用的上的UI控件
* 为了便于开发者打造各式各样的优秀App,UIKit框架提供了非常多功能强大又易用的UI控件
* 以下列举一些在开发中可能的上的UI控件
	* UIButton 按钮
	* UILabel 文本标签
	* UITextField 文本输入框
	* UIImageView 图片视图
	* UIScrollView 滑动视图
	* UITableView 表格视图
	* UICollectionView 集合视图
	* UIWebView 网页视图
	* UIAlertView 对话弹框
	* UINavigationBar 导航条
	* UIPageControl 分页控件
	* UITextView 文本控件
	* UIActivityIndicator 转菊花视图
	* UISwitch 开关视图
	* UIActionSheet 弹框
	* UIDatePicker 日期选择器
	* UIToolbar 工具条
	* UIProgressView 进度条
	* UISlider 滑动条
	* UISegmentControl 分段控件
	* UIPickerView 选取器
	* 

## 视图的最基本属性

|属性||
|-|-|
|frame|是CGRect  frame的origin是相对于父视图的左上角原点(0,0)的位置，改变视图的frame会改变center|
|center|是CGPoint  指的就是整个视图的中心点，改变视图的center也会改变frame|
|bounds|是CGRect  是告诉子视图本视图的原点位置(通俗的说就是，子视图的frame的origin与父视图的bounds的origin的差，就是子视图相对于父视图左上角的位置，如果结果为负，则子视图在父视图外)|

frame和center都是相对于父视图的，bounds是相对于自身的