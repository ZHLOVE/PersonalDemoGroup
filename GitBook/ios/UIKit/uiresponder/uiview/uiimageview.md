# UIImageView

[待编辑]


UIKit中有一些类可以用来操纵单个图像，还有一个图像类可以用来显示图像。Apple还提供了一种特殊的导航控制器，用于从图像库中选择图像。
UIImage类对图像及其底层数据进行封装。它可以直接绘制在一个视图内，或者作为一个图像容器在另一个更大的图像视图容器中使用。这个类类提供的方法可以用来从各种来源中载入图像，在屏幕上设置图片的方向，以及提供有关图像的信息。对于简单的图形应用，可以将UIImage对象用在视图类的drawRect方法中，用来绘制图像和团模板。
你可以用文件来初始化，也可以用url、原始数据、或者一个Core Graphics图像的内容。静态方法(类方法)和实例方法都有;这些方法可以引用并缓存已有的图像内容，也可以实例化新的图像对象，如何使用完全取决于应用程序的需要。
使用一个图像的最简单方法就是通过静态方法。静态方法不会去管理图像的实例，与之相反，他们提供了直接的接口，可以用来共享位于框架内部的记忆体缓存对象。这有助于保持应用程序的整洁，也会生去做清理工作的需要。静态方法和实例方法都可以用来创建相同的对象。
一、使用文件创建(静态方法)
[java] view plain copy print?
UIImage *myImage = [UIImage imageNamed:@"ppp"];  
二、使用 URL 和原始数据(静态方法)
[java] view plain copy print?
NSData *imageData = [ NSData initWithBytes:image:imagePtr length:imageSize ]; // 假设 imagePtr 是一个指向原始数据的指针  
UIImage* myImage = [ [ UIImage alloc ]initWithData:imageData ];  
[java] view plain copy print?
UIImage *myImage2 =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.kutx.cn/xiaotupian/icons/png/200803/20080327095245737.png"]]];  
三、使用Core Graphics (静态方法)
[java] view plain copy print?
UIImage* myImage3 = [UIImage imageWithCGImage:myCGImageRef];  
四、使用文件(实例方法)
[java] view plain copy print?
UIImage* myImage4 = [[UIImage alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/ppp.png",NSHomeDirectory()]];  
五、使用 URL 和原始数据(实例方法)
如果图像存储在内存中，你可以创建一个NSData 对象作为initWithData 方法的原始输入，来初始化一个UIImage对象。
如果图像是一张网络图片，可以使用NSData来进行预载，然后用它来初始化UIImage对象：
[java] view plain copy print?
UIImage *myImage5 =[ [ UIImage alloc]initWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.kutx.cn/xiaotupian/icons/png/200803/20080327095245737.png"]] ];  
六、使用Core Graphics (实例方法)
[java] view plain copy print?
UIImage* myImage6 = [[UIImage alloc]initWithCGImage:myCGImageRef];  
七、显示图像
当视图类的drawRect 方法被唤起时，它们会调用内部的回吐例程。与其他图像类不同，UIImage对象不能被当成子 ,直接附着在其他视图上，因为他不是一个视图类。反过来，一个UIView类则可以在视图的drawRect例程中，调用图像的 drawRect 方法。这可以使得图像显在UIView类的显示区域内部。
只要一个视图对象的窗口的某些部分需要绘制，就可以调用它的drawRect方法。要在窗口内 部显示一个 UIImage 的内容，可以调用该对象的 drawRect 方法：
[java] view plain copy print?
- (void)drawRect:(CGRect)rect{  
    CGRect myRect;  
      
    myRect.origin.x = 0.0 ;  
    myRect.origin.y = 0.0;  
    myRect.size = myImage.size;  
    [myImage drawInRect:myRect];  
}  
注意不要在drawRect方法内分配任何新对象，因为他在每次窗口重绘时都被调用。
只有在视图初次绘制时，才会调用drawRect方法。要强制更新，可以使用视图类的 setNeedsDisplay 或者 setNeedsDisplayInRect  方法：
[java] view plain copy print?
[myView setNeedsDisplay];  
    [myView setNeedsDisplayInRect:self.view];  
八、绘制图案
如果图像是一个图案模板，你可以用UIImage类提供的另外一个方法 drawAsPatternInrect，在整个视图区域重复绘制该图像：
[java] view plain copy print?
UIView* myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];  
    [myImage drawInRect:myView.frame];  
    [self.view addSubview:myView];<span>    </span>  
九、方向
一个图像的方向，决定了它在屏幕上如何被旋转。因为iPhone 能被以6种不同的方式握持，所以在方向改变时，能够将图像做相应的旋转就十分必要了。UIImage 有个只读属性 imageOrientation 来标识它的方向。
[java] view plain copy print?
UIImageOrientation myOrientation =  myImage.imageOrientation ;  
可以设置以下方向：
[java] view plain copy print?
typedef enum {  
    UIImageOrientationUp,            // default orientation  默认方向  
    UIImageOrientationDown,          // 180 deg rotation    旋转180度  
    UIImageOrientationLeft,          // 90 deg CCW         逆时针旋转90度  
    UIImageOrientationRight,         // 90 deg CW          顺时针旋转90度  
    UIImageOrientationUpMirrored,    // as above but image mirrored along other axis. horizontal flip   向上水平翻转  
    UIImageOrientationDownMirrored,  // horizontal flip    向下水平翻转  
    UIImageOrientationLeftMirrored,  // vertical flip      逆时针旋转90度，垂直翻转  
    UIImageOrientationRightMirrored, // vertical flip      顺时针旋转90度，垂直翻转  
} UIImageOrientation;  
十、图像尺寸
你可以通过size属性读取一个图像的尺寸，得到一个CGSize 结构，其中包含 wifth 和height 。
[java] view plain copy print?
CGSize myImageSize = myImage.size;  

参考：
<http://blog.csdn.net/iukey/article/details/7308433>
