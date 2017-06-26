# 160307星期一



##自定义表格固定高度单元格方式:
1. Storyboard原型单元格
  * 通过tag得到原型单元格上对象
  * 自定义UITableViewCell和原型单元格对应
2. Xib方式
3. 纯代码

####Storyboard流程

流程1. 在原型单元格上设计单元格

流程2.

方式一:(通过Tag找到原型单元格上的对象)
* 给控件加上tag

方式二:（自定义UITableViewCell）
* 原型单元格上的对象拉出来属性来，以便访问

####Xib方式流程
1. 新建一个UITableViewCell的子类，勾上xib
2. 在xib上设计界面，将界面对象拉出输出口
3. 表格视图控制器中注册单元格模板
```objc
    //UINib *nib = [UINib nibWithNibName:@"TableViewCell2" bundle:nil];
    //[self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
```

####纯代码    

1. 定义一些控件属性
```objc
@property (weak, nonatomic) UIImageView *iconImageView;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *colorLabel;
```
2. 在initWithStyle代码创建对象
```objc
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(150, 25, 70, 15)];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(150+80, 25, 70, 15)];
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(150, 56, 70, 15)];
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(150+80, 56, 70, 15)];
        
        label1.text = @"型号";
        label3.text = @"颜色";
        
        [self.contentView addSubview:label1];
        [self.contentView addSubview:label2];
        [self.contentView addSubview:label3];
        [self.contentView addSubview:label4];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 130, 130)];
        [self.contentView addSubview:iconImageView];
        
        self.iconImageView = iconImageView;
        self.nameLabel = label2;
        self.colorLabel = label4;
        
    }
    return self;
}
```
3. 在layoutSubviews中对对象位置大小进行设定(建议在该方法中设置)
```objc
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}
```
```

