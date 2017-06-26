# 160129星期五

##1 控件(UIControl)的状态

```objc
typedef NS_OPTIONS(NSUInteger, UIControlState) {
    UIControlStateNormal       = 0,
    UIControlStateHighlighted  = 1 << 0,                  // used when UIControl isHighlighted is set
    UIControlStateDisabled     = 1 << 1,
    UIControlStateSelected     = 1 << 2,                  // flag usable by app (see below)
    UIControlStateFocused NS_ENUM_AVAILABLE_IOS(9_0) = 1 << 3, // Applicable only when the screen supports focus
    UIControlStateApplication  = 0x00FF0000,              // additional flags available for application use
    UIControlStateReserved     = 0xFF000000               // flags reserved for internal framework use
};

UIControlStateNormal 普通状态
UIControlStateHighlighted 高亮状态(按钮按下)
UIControlStateDisabled 不可用状态(按钮的enable属性被设置为true)
```

##2 控件(UIControl)的事件

```objc
typedef NS_OPTIONS(NSUInteger, UIControlEvents) {
    UIControlEventTouchDown                                         = 1 <<  0,      // on all touch downs
    UIControlEventTouchDownRepeat                                   = 1 <<  1,      // on multiple touchdowns (tap count > 1)
    UIControlEventTouchDragInside                                   = 1 <<  2,
    UIControlEventTouchDragOutside                                  = 1 <<  3,
    UIControlEventTouchDragEnter                                    = 1 <<  4,
    UIControlEventTouchDragExit                                     = 1 <<  5,
    UIControlEventTouchUpInside                                     = 1 <<  6,
    UIControlEventTouchUpOutside                                    = 1 <<  7,
    UIControlEventTouchCancel                                       = 1 <<  8,

    UIControlEventValueChanged                                      = 1 << 12,     // sliders, etc.
    UIControlEventPrimaryActionTriggered NS_ENUM_AVAILABLE_IOS(9_0) = 1 << 13,     // semantic action: for buttons, etc.

    UIControlEventEditingDidBegin                                   = 1 << 16,     // UITextField
    UIControlEventEditingChanged                                    = 1 << 17,
    UIControlEventEditingDidEnd                                     = 1 << 18,
    UIControlEventEditingDidEndOnExit                               = 1 << 19,     // 'return key' ending editing

    UIControlEventAllTouchEvents                                    = 0x00000FFF,  // for touch events
    UIControlEventAllEditingEvents                                  = 0x000F0000,  // for UITextField
    UIControlEventApplicationReserved                               = 0x0F000000,  // range available for application use
    UIControlEventSystemReserved                                    = 0xF0000000,  // range reserved for internal framework use
    UIControlEventAllEvents                                         = 0xFFFFFFFF
};

常用:
UIControlEventTouchUpInside 按钮默认事件
```

##3 代码创建窗口及控制器

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // 创建界面
    
    // 1.创建self.window
    // 创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 作为主要窗体并可见(这样窗体可见并接受用户输入响应)
    [self.window makeKeyAndVisible];
    // 窗体背景色
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 2.创建视图控制器
    
    // 创建一个视图控制器
    ViewController *vc = [[ViewController alloc] init];
    // 把视图控制器作为window的根视图控制器(这样这个控制器控制的视图作为self.window的子视图了)
    self.window.rootViewController = vc;
    
    
    return YES;
}
```

##4 代码创建界面上的控件

```objc
// 将创建按钮的代码封装成一个方法
- (void)addButtonWithTitle:(NSString *)title andFrame:(CGRect)frame andTag:(int)tag andColor:(UIColor *)color
{
    // 创建按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    // 设置按钮文字
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
//    btn.font = [UIFont systemFontOfSize:50]; //deprecated 过时的属性或方法,在新版本里仍旧可以使用。
    btn.titleLabel.font = [UIFont systemFontOfSize:50];
    btn.tag = tag;
    
    // 添加事件处理
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

// viewDidLoad 当视图载入的时候
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建Label
    self.label = [[UILabel alloc] init];
    self.label.frame = CGRectMake(40, 40, 200, 50);
    self.label.text = @"一段文字";
    self.label.textColor = [UIColor redColor];
    [self.view addSubview:self.label];
    
    // 创建3个按钮
    [self addButtonWithTitle:@"红色" andFrame:CGRectMake(25, 150, 100, 50) andTag:1 andColor:[UIColor redColor]];
    [self addButtonWithTitle:@"绿色" andFrame:CGRectMake(125, 150, 100, 50) andTag:2 andColor:[UIColor greenColor]];
    [self addButtonWithTitle:@"蓝色" andFrame:CGRectMake(225, 150, 100, 50) andTag:3 andColor:[UIColor blueColor]];
    
}
```

## 5 真机测试
1. 注册开发者账号
https://developer.apple.com/
如果已有AppleID,只需要登陆一下同意一下协议
2. 打开XCode,点击Xcode菜单 Perference
  点Accounts
  登陆你的账号
3. 选中账号，点View Details
4. iOS Development 点Create
5. 关掉Preference,项目设置里，Team选你的账号，然后下面点Fix issue
6. 然后运行设备里选你的手机,点运行，项目的Deployment Target的版本要<=你手机的iOS版本，
7. 然后手机里通用->描述文件->你的账号->选择允许（需要网络,如果有问题，切换至流量试下)
8. 再次运行程序


## 6 UIColor

```objc
// 常用颜色
+ (UIColor *)blackColor;      // 0.0 white 
+ (UIColor *)darkGrayColor;   // 0.333 white 
+ (UIColor *)lightGrayColor;  // 0.667 white 
+ (UIColor *)whiteColor;      // 1.0 white 
+ (UIColor *)grayColor;       // 0.5 white 
+ (UIColor *)redColor;        // 1.0, 0.0, 0.0 RGB 
+ (UIColor *)greenColor;      // 0.0, 1.0, 0.0 RGB 
+ (UIColor *)blueColor;       // 0.0, 0.0, 1.0 RGB 
+ (UIColor *)cyanColor;       // 0.0, 1.0, 1.0 RGB 
+ (UIColor *)yellowColor;     // 1.0, 1.0, 0.0 RGB 
+ (UIColor *)magentaColor;    // 1.0, 0.0, 1.0 RGB 
+ (UIColor *)orangeColor;     // 1.0, 0.5, 0.0 RGB 
+ (UIColor *)purpleColor;     // 0.5, 0.0, 0.5 RGB 
+ (UIColor *)brownColor;      // 0.6, 0.4, 0.2 RGB 
+ (UIColor *)clearColor;      // 0.0 white, 0.0 alpha 
```

```objc
//随机色
UIColor *color = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:(arc4random()%255)/255.0];
```

## 7 屏幕大小

```objc
CGRect winSize = [UIScreen mainScreen].bounds;
NSLog(@"%@",NSStringFromCGRect(winSize));//iPhone6输出：（0.0,0.0,375.0,667.0）
CGRect appSize = [UIScreen mainScreen].applicationFrame;// 不含状态栏
NSLog(@"%@",NSStringFromCGRect(appSize));//iPhone6输出：（0.0,20.0,375.0,647.0）
```
