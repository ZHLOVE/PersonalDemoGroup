# 160229星期一

###内容:
1. UIScorllView
2. 自定义视图封装

## 从xib创建自定义视图对象

```objc
NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"QXHImageScrollView" owner:nil options:nil];
MyView *view = arr[0];
```

## 封装自定义视图流程
####第一步: 创建对象
* 方式1: 在initWithFrame中创建对象,不需要指定尺寸位置 (注:一般在initWithFrame中，因为init -> 也会调用 initWithFrame)
* 方式2: 采用懒加载方式创建对象
* 方式3: 采用xib文件初始化对象

####第二步: 重写layoutSubviews,设定位置和尺寸(xib方式也可以省略)
// 父视图一旦被设定frame,就会调用该方法调整本视图里子视图的位置
```
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //当前视图的尺寸 self.bounds
    
    // 设定scorllView的位置和尺寸
    self.scrollView.frame = self.bounds;
    
    // 调制里面图片视图的大小
    CGFloat imgWidth = self.scrollView.bounds.size.width;
    CGFloat imgHeight = self.scrollView.bounds.size.height;
    for (int i=0; i<self.imageNames.count; i++)
    {
        UIImageView *imgView = self.scrollView.subviews[i];
        imgView.frame = CGRectMake(imgWidth * i, 0, imgWidth, imgHeight);
    }
    self.scrollView.contentSize = CGSizeMake(imgWidth * self.imageNames.count, 0);
    
    // 设定pageControl的位置和尺寸
    CGFloat pageW = 100;
    CGFloat pageH = 20;
    CGFloat pageX = self.bounds.size.width/2 - pageW/2;
    CGFloat pageY = self.bounds.size.height - pageH;
    
    self.pageControl.frame = CGRectMake(pageX,pageY, pageW, pageH);
    
    [self addSubview:self.pageControl];
}
```
####第三步:设定对应的数据模型对象(非必须)
如果视图比较简单，没有数据，不需要进行设置

