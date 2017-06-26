# 属性的格式

@property (参数) 类型 变量名;

@synthesize 变量名;

读写属性:readwrite/readonly

内存属性:assign/retain/copy (内存管理章节)

原子性:atomic/noatomic

copy： 建立一个索引计数为1的对象，然后释放旧对象

retain：释放旧的对象，将旧对象的值赋予输入对象，再提高输入对象的索引计数为1

assign: 对基础数据类型 （NSInteger）和C数据类型（int, float, double, char,等）

retain是指针拷贝，copy是内容拷贝。