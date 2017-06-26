# 16-02-22 星期一

## xib和storyborad对比
1. 共同点
    * 都用来描述软件界面
    * 本质都是转换为代码来初始化创建控件
2. 不同
    * xib是轻量级,描述局部UI界面
    * Storyboard是重量级,用来描述整个软件多个界面，并能展示多个界面的跳转关系


## 加载xib的方法

```
// 方式1:
// nil 默认是[NSBundle mainBundle]
NSArray *arrs = [[NSBundle mainBundle] loadNibNamed:@"TestView" owner:nil 
options:nil];

// 方式2:
[self.view addSubviews:arrs[0]];
UINib *nib = [[UINib nibWithNibName:@"TestView" bundle:[NSBundle mainBundle]];
NSArray *arrs = [nib instantiateWithOwner:nil options:nil];
[self.view addSubviews:arrs[0]];
```


1 UIToolBar
2 UITabBarController
