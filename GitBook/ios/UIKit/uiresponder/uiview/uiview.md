# UIView

## UIView的常见属性

```objc
@property (nonatomic) CGRect frame;// 控件矩形框在父控件中的位置和尺寸(以父控件的左上角为坐标原点)
@property (nonatomic) CGRect bounds;// 控件矩形框的位置和尺寸(以自己左上角为坐标原点)
@property (nonatomic) CGPoint center;// 控件中点的位置(以父控件的左上角为坐标原点)

@property(nullable, nonatomic,copy) UIColor          *backgroundColor;// 背景色
@property(nonatomic) CGFloat alpha;// 透明度 (0.0~1.0 透明到不透明)
@property(nonatomic,getter=isOpaque) BOOL opaque;// 不透明度
@property(nonatomic) BOOL clipsToBounds;// 超出本视图大小子视图是否显示

@property(nonatomic,getter=isHidden) BOOL hidden;// 是否隐藏
@property(nonatomic) UIViewContentMode contentMode;// 内容的显示模式（拉伸自适应）

@property (nonatomic,readonly) UIView *superview;// 得到自己的父控件对象
@property (nonatomic,readonly,copy) NSArray *subviews;// 得到自己的子控件对象数组

@property (nonatomic) NSInteger tag;// 空间的ID(标识),父控件可以通过tag找到对应的子控件

@property (nonatomic) CGAffineTransform transform;// 形变

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

参考资料
1 alpha、hidden和opaque属性之间的关系和区别
<http://blog.csdn.net/wzzvictory/article/details/10076323>

2 UIView详解
<http://blog.csdn.net/zhaopenghhhhhh/article/details/16105421>