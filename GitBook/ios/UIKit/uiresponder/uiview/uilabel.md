# UILabel

##1. 创建

```Objc
CGRect rect = CGRectMake(100, 200, 50, 50);
UILabel *label = [[UILabel alloc] initWithFrame:rect];
```
##2. text 设置和读取文本内容,默认为nil

```Objc
label.text = @”文本信息”; //设置内容
NSLog(@”%@”, label.text); //读取内容
```
##3. textColor 设置文字颜色，默认为黑色

```Objc
lable.textColor = [UIColor redColor];
```
##4. font 设置字体大小，默认17

```Objc
label.font = [UIFont systemFontOfSize:20]; //⼀一般方法
label.font = [UIFont boldSystemFontOfSize:20]; //加粗方法
label.font = [UIFont fontWithName:@"Arial" size:16]; //指定字体的方法
//还有⼀一种从外部导入字体的方法。
```
##5. textAlignment 设置标签文本对齐方式。

```Objc
label.textAlignment = NSTextAlignmentCenter; //还有
NSTextAlignmentLeft、 NSTextAlignmentRight.
```

##6. numberOfLines 标签最多显示行数,如果为0则表示多行。

```Objc
label.numberOfLines = 2;
```

##7. enabled 只是决定了Label的绘制方式，将它设置为NO将会使文本变暗，表示它没有激活，这时向它设置颜色值是无效的。

```
label.enable = NO;
```

##8. highlighted 是否高亮显示

```
label.highlighted = YES;
label.highlightedTextColor = [UIColor orangeColor]; //高亮显示时的文本颜色
```
##9. ShadowColor 设置阴影颜色 

```Objc
[label setShadowColor:[UIColor blackColor]];
```
##10. ShadowOffset 设置阴影偏移量

```Objc
[label setShadowOffset:CGSizeMake(-1, -1)];
```
##11 baselineAdjustment 如果adjustsFontSizeToFitWidth属性设置为YES，这个属性就来控制文本基线的行为。

```Objc
label.baselineAdjustment = UIBaselineAdjustmentNone;
UIBaselineAdjustmentAlignBaselines = 0,默认，文本最上端与中线对齐。
UIBaselineAdjustmentAlignCenters,  文本中线与label中线对齐。
UIBaselineAdjustmentNone, 文本最低端与label中线对齐。
```
##12. Autoshrink //是否自动收缩

```Objc
//Fixed Font Size 默认,如果Label宽度小于文字长度时时,文字大小不自动缩放
//minimumScaleFactor 设置最小收缩比例，如果Label宽度小于文字长度时，文字
进行收缩，收缩超过比例后，停止收缩。
//minimumFontSize 设置最小收缩字号，如果Label宽度小于文字长度时，文字字号
减小，低于设定字号后，不再减小。//6.0以后不再使用了。
label.minimumScaleFactor = 0.5;
```

##13. adjustsLetterSpacingToFitWidth 改变字母之间的间距来适应Label大小

```Objc
myLabel.adjustsLetterSpacingToFitWidth = NO;
```

##14. lineBreakMode 设置文字过长时的显示格式

```Objc            
label.lineBreakMode = NSLineBreakByCharWrapping;以字符为显示单位显
示，后面部分省略不显示。
label.lineBreakMode = NSLineBreakByClipping;剪切与文本宽度相同的内
容长度，后半部分被删除。
label.lineBreakMode = NSLineBreakByTruncatingHead;前面部分文字
以……方式省略，显示尾部文字内容。
label.lineBreakMode = NSLineBreakByTruncatingMiddle;中间的内容
以……方式省略，显示头尾的文字内容。
label.lineBreakMode = NSLineBreakByTruncatingTail;结尾部分的内容
以……方式省略，显示头的文字内容。
label.lineBreakMode = NSLineBreakByWordWrapping;以单词为显示单位显
示，后面部分省略不显示。
```

##15. adjustsFontSizeToFitWidth //设置字体大小适应label宽度

```objc
label.adjustsFontSizeToFitWidth = YES;
```
##16. attributedText：设置标签属性文本。

```objc
NSString *text = @"first";
NSMutableAttributedString *textLabelStr =
[[NSMutableAttributedString alloc]
initWithString:text];
[textLabelStr
setAttributes:@{NSForegroundColorAttributeName :
[UIColor lightGrayColor], NSFontAttributeName :
[UIFont systemFontOfSize:17]} range:NSMakeRange(11,
10)];
label.attributedText = textLabelStr;
```

##17. 竖排文字显示每个文字加一个换行符，最方便和简单的实现方式

```Objc
label.text = @"请\n竖\n直\n方\n向\n排\n列";
label.numberOfLines = [label.text length];
```

##18. 计算UIlabel 随字体多行后的高度

```Objc
CGRect bounds = CGRectMake(0, 0, 200, 300);
heightLabel = [myLabel textRectForBounds:bounds
limitedToNumberOfLines:20]; //计算20行后的Label的Frame
NSLog(@"%f",heightLabel.size.height);
```

##19. UILabel根据字数多少自动实现适应高度

```objc
UILabel *msgLabel = [[UILabel alloc]
initWithFrame:CGRectMake(15, 45, 0, 0)];
msgLabel.backgroundColor = [UIColor lightTextColor];
[msgLabel setNumberOfLines:0];
msgLabel.lineBreakMode = UILineBreakModeWordWrap;
msgLabel.font = [UIFont fontWithName:@"Arial" size:12];
CGSize size = CGSizeMake(290, 1000);
msgLabel.text = "获取到的deviceToken，我们可以通过webservice服务提交给.net应用程序，这里我简单处理，直接打印出来，拷贝到.net应用环境中使用。";
CGSize msgSie = [msgLabel.text sizeWithFont:fonts
constrainedToSize:size];
[msgLabel setFrame:CGRectMake(15, 45, 290, msgSie.height)];
```

##20. 渐变字体Label

```Objc
UIColor *titleColor = [UIColor colorWithPatternImage:[UIImage
imageNamed:@"btn.png"]];
NSString *title = @"Setting";
UILabel *titleLabel = [[UILabel alloc]
initWithFrame:CGRectMake(0, 0, 80, 44)];
titleLabel.textColor = titleColor;
titleLabel.text = title;
titleLabel.font = [UIFont boldSystemFontOfSize:20];
titleLabel.backgroundColor = [UIColor clearColor];
[self.view addSubview:titleLabel];
```

##21. Label添加边框

```Objc
titleLabel.layer.borderColor = [[UIColor grayColor] CGColor];
titleLabel.layer.borderWidth = 2;
```