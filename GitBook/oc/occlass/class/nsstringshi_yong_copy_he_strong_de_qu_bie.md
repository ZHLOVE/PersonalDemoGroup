# NSString使用copy和strong的区别


```objc
@property (nonatomic,strong) NSString *sStr;
@property (nonatomic,copy) NSString *cStr;

- (void)test
{
    NSMutableString *mStr = [NSMutableString stringWithFormat:@"abc"];
    self.sStr   = mStr;
    self.cStr   = mStr;
    NSLog(@"mStr:%p,%p",  mStr,&mStr);
    NSLog(@"strongStr:%p,%p", _sStr, &_sStr);
    NSLog(@"copyStr:%p,%p",   _cStr, &_cStr);
    //mStr:0x16d613b0,0x208480
    //sStr:0x16d613b0,0x16d634f4
    //cStr:0x16d652f0,0x16d634f8
    
    //说明:
    //mStr对象的地址为0x13b0，也就是0x13b0是@“abc”的首地址，mStr变量自身在内存中的地址为0x8480；
    //当把mStr赋值给strong的sStr时，sStr对象的地址为0x13b0，rStr变量自身在内存中的地址为0x34f4；sStr与mStr指向同样的地址，他们指向的是同一个对象@“abc”，这个对象的地址为0x13b0，所以他们的值是一样的。
    //当把mStr赋值给copy的cStr时，cStr对象的地址为0x52f0，cStr变量自身在内存中的地址0x34f8；cStr与mStr指向的地址是不一样的，他们指向的是不同的对象，所以copy是深复制，一个新的对象，这个对象的地址为0x52f0，值为@“abc”。
    
    [mStr appendString:@"de"];
    NSLog(@"sStr = %@",_sStr);
    NSLog(@"cStr = %@",_cStr);
    //sStr = abcde
    //ctr = abc
    
    //注意:当把NSMutableString赋值给NSString的时候，才会有不同，如果是赋值是NSString对象，那么使用copy还是strong，结果都是一样的，因为NSString对象根本就不能改变自身的值，他是不可变的。
}
```