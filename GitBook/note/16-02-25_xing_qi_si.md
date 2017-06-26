# 16-02-25 星期四

#### 加载Xib文件

```objc

// 方式1:
NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"Test" owner:nil options:nil ];
[self.view addSubView:objs[0]];

// 方式2:
//UINib *nib = [UINib nibWithNibName:@"Test" bundle:[NSBundle mainBundle]];
UINib *nib = [UINib nibWithNibName:@"Test" bundle:nil];
NSArray *objs = [nib instantiateWithOwner:nil options:nil];
[self.view addSubView:[objs lastObject]];

```