# 160222星期一

##课程内容:
1. 使用xib
2. 使用工具栏实现多视图
3. 使用标签栏控制器实现多视图


##知识点

#### NSBundle
* 一个NSBundle对象对应一个资源包
* NSBundle用来访问对应资源文件内部的文件，可以用来获得文件的全路径。
* 项目中添加的资源都会被添加到主资源包
* [NSBundle mainBundle]关联的就是项目的竹资源包

```objc
NSString *fileName = @"data.plist";
NSBundle *bundle = [NSBundle mainBundle];
NSString *path = [bundle pathForResource:fileName ofType:nil];
NSLog(@"%@",path);
```

####Xib

```
//xib 编译打包后生成 nib
//初始化的时候
//xib是帮助你初始化界面的,相当于你手写创建代码
ViewController *vc = [[ViewController alloc] init];// 默认会用同名的nib文件初始化
ViewController *vc = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
ViewController *vc = [[ViewController alloc] initWithNibName:@"ViewController2" bundle:nil];// 指定nib文件名进行初始化
```

####xib和storyborad对比
1. 共同点
    * 都用来描述软件界面
    * 本质都是转换为代码来初始化创建控件
2. 不同点
    * xib是轻量级,描述局部UI界面
    * Storyboard是重量级,用来描述整个软件多个界面，并能展示多个界面的跳转关系

####采用工具栏实现多视图

```objc
#import "SwitchViewController.h"


#import "BlueViewController.h"
#import "YellowViewController.h"

@interface SwitchViewController ()


@property (nonatomic,strong) BlueViewController *blueVC;
@property (nonatomic,strong) YellowViewController *yellowVC;

@property (nonatomic,assign) BOOL curBlue;

@end

@implementation SwitchViewController

// 懒加载 节省内存
// 重写getter方法
// 第一次用到这个对象时候去创建这个对象，如果始终没用到这个对象,则不会创建,节省了内存
- (BlueViewController *)blueVC
{
    if(_blueVC == nil)
    {
        _blueVC = [[BlueViewController alloc] init];
    }
    return _blueVC;
}

- (YellowViewController *)yellowVC
{
    if(!_yellowVC)
    {
        _yellowVC = [[YellowViewController alloc] init];
    }
    return _yellowVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // 采用懒加载，以下两行删除
//    self.blueVC = [[BlueViewController alloc] init];
//    self.yellowVC = [[YellowViewController alloc] init];
    
    [self switch:nil];
}

- (IBAction)switch:(id)sender
{
    
    // 动画效果 (UIView简单切换动画)
    [UIView beginAnimations:@"ViewFlip" context:nil];
    [UIView setAnimationDuration:1.25];// 动画的时间
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];// 运动方式
//    UIViewAnimationCurveEaseInOut,         // 慢入慢出
//    UIViewAnimationCurveEaseIn,            // 开头逐渐加速
//    UIViewAnimationCurveEaseOut,           // 界面逐渐减速
//    UIViewAnimationCurveLinear             // 匀速
    
    if(self.curBlue)
    {
        [self.view insertSubview:self.yellowVC.view atIndex:0];
        [self.blueVC.view removeFromSuperview];
        
        // 动画的样式
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
//        UIViewAnimationTransitionNone,            无
//        UIViewAnimationTransitionFlipFromLeft,    左侧翻转
//        UIViewAnimationTransitionFlipFromRight,   右侧翻转
//        UIViewAnimationTransitionCurlUp,          上翻页
//        UIViewAnimationTransitionCurlDown,        下翻页
    }
    else
    {
        [self.view insertSubview:self.blueVC.view atIndex:0];
        [self.yellowVC.view removeFromSuperview];
        
        // 动画的样式
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    }
    
    [UIView commitAnimations];// 动画开始播放
    
    self.curBlue = !self.curBlue;
}

@end

```