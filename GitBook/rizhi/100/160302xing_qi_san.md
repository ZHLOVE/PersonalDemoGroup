# 160302星期三

1. 应用程序对象
UIApplicaiton *app = [UIApplication sharedApplication];
2. 应用程序代理类对象
AppDelegate *appDelegate = app.delegate;

3. 应用程序的窗体
appDelegate.window

4. 根视图控制器
appDelegate.window.rootViewController

//-------------------------------------------
5. 视图控制器对象 (ViewController)
-self.view

命名的时候 控制器
ViewController
Controller

6 视图对象,看得到的东西(UIView的子类)

自定义的视图
View为后缀
Buttun


7 模型对象 (NSObject继承的子类)

Model

## 代码适配

```objc
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
// 竖屏使用
#define W(x) (x * kScreenWidth / 320.0)
#define H(y) (y * kScreenHeight / 568.0)
// 横屏使用
#define WR(y) (y * kScreenHeight / 320.0)
#define HR(x) (x * kScreenWidth / 568.0)

// 根据iPhone5计算
//int width = 20;// iphone5下 屏幕宽是320
//int width2 = 20 * 375 / 320.0;// 23 iphone6下 屏幕款375
//int winth3 = 20 * 414 / 320.0;// 25 iphone6 plus下 屏幕款414

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@end

@implementation ViewController

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"1 将要旋转到方向%i",toInterfaceOrientation);
    
    NSLog(@"%@",NSStringFromCGRect([UIScreen mainScreen].bounds));
    
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        // 水平方向
        self.label1.frame = CGRectMake(WR(20),HR(20),WR(125),HR(125));
        self.label2.frame = CGRectMake(WR(20),HR(155),WR(125),HR(125));
        self.label3.frame = CGRectMake(WR(177),HR(20), WR(125),HR(125));
        self.label4.frame = CGRectMake(WR(177),HR(155),WR(125),HR(125));
        self.label5.frame = CGRectMake(WR(328),HR(20), WR(125),HR(125));
        self.label6.frame = CGRectMake(WR(328),HR(155), WR(125),HR(125));
    }
    else
    {
        // 垂直方向
        self.label1.frame = CGRectMake(W(20),H(20),W(125),H(125));
        self.label2.frame = CGRectMake(W(172),H(20),W(125),H(125));
        self.label3.frame = CGRectMake(W(20),H(168),W(125),H(125));
        self.label4.frame = CGRectMake(W(175),H(168),W(125),H(125));
        self.label5.frame = CGRectMake(W(20),H(315),W(125),H(125));
        self.label6.frame = CGRectMake(W(175),H(315),W(125),H(125));
    }
}

@end
```

## 使用代码实现Autolayout的方法1
- 创建约束

```objc
+(id)constraintWithItem:(id)view1
attribute:(NSLayoutAttribute)attr1
relatedBy:(NSLayoutRelation)relation
toItem:(id)view2
attribute:(NSLayoutAttribute)attr2
multiplier:(CGFloat)multiplier
constant:(CGFloat)c;
* view1 ：要约束的控件
* attr1 ：约束的类型（做怎样的约束）
* relation ：与参照控件之间的关系
* view2 ：参照的控件
* attr2 ：约束的类型（做怎样的约束）
* multiplier ：乘数
* c ：常量
```

- 添加约束

```objc
- (void)addConstraint:(NSLayoutConstraint *)constraint;
- (void)addConstraints:(NSArray *)constraints;
```

- 注意
    - 一定要在拥有父控件之后再添加约束
    - 关闭Autoresizing功能
    ```objc
    view.translatesAutoresizingMaskIntoConstraints = NO;
    ```

## 使用代码实现Autolayout的方法2 - VFL
- 使用VFL创建约束数组

```objc
+ (NSArray *)constraintsWithVisualFormat:(NSString *)format
options:(NSLayoutFormatOptions)opts
metrics:(NSDictionary *)metrics
views:(NSDictionary *)views;
* format ：VFL语句
* opts ：约束类型
* metrics ：VFL语句中用到的具体数值
* views ：VFL语句中用到的控件
```

- 使用下面的宏来自动生成views和metrics参数

```objc
NSDictionaryOfVariableBindings(...)
```

## 使用代码实现Autolayout的方法3 - Masonry
<http://www.tuicool.com/articles/vYF363>
- 使用步骤
    - 添加Masonry文件夹的所有源代码到项目中
    - 添加2个宏、导入主头文件
    ```objc
    // 只要添加了这个宏，就不用带mas_前缀
    #define MAS_SHORTHAND
// 只要添加了这个宏，equalTo就等价于mas_equalTo
#define MAS_SHORTHAND_GLOBALS
// 这个头文件一定要放在上面两个宏的后面
#import "Masonry.h"
    ```

- 添加约束的方法

```objc
// 这个方法只会添加新的约束
 [view makeConstraints:^(MASConstraintMaker *make) {

 }];

// 这个方法会将以前的所有约束删掉，添加新的约束
 [view remakeConstraints:^(MASConstraintMaker *make) {

 }];

 // 这个方法将会覆盖以前的某些特定的约束
 [view updateConstraints:^(MASConstraintMaker *make) {

 }];
```

- 约束的类型
```objc
1.尺寸：width\height\size
2.边界：left\leading\right\trailing\top\bottom
3.中心点：center\centerX\centerY
4.边界：edges