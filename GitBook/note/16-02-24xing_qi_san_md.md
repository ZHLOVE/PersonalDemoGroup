# 16-02-24 星期三

####instancetype
* instancetype在类型表示上,跟id一样,可以表示任何对象类型
* instancetype只能用在返回值类型上,不能像id一样用在参数类型上
* instancetype比id多一个好处,编译器会检测instancetype的真是类型

#### 字典转模型的过程最好封装在模型内部
- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)xxxWithDictionary:(NSDictionary *)dict;
 

#### 类前缀
在使用Objective-C开发iOS程序时,最好在每个类名前面加一个前缀,用来标识一下
Class Prefix


#### view的封装
* 如果一个view内部的子控件比较多,一般会考虑自定义一个view,把它内部的子控件的创建屏蔽起来，不让外界关心
* 外界可以传入对应的的模型数据给view，view拿到模型数据后给内部的子控件设置对应的数据
* 基本步骤
    - 在initWithFrame中添加子控件,提供便利构造方法
    - 在layoutSubviews方法中设置子控件的frame(一定要县调用supver的layoutSubviews)
* 增加模型属性,在模型属性set方法中设置到子控件