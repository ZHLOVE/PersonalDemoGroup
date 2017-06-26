//
//  main.m
//  Foundation框架
//
//  Created by niit on 16/1/4.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

// C语言的结构体 例子
//struct MyPoint
//{
//    int x;
//    int y;
//};
//typedef struct MyPoint MyPoint;

// C语言的函数格式
//返回值类型 函数名(参数类型 参数名1，参数类型 参数名2 ,...)
//{
//    具体语句
//    ...
//    return 计算的结果
//}

// 定义C语言的枚举类型
enum Color
{
    kColorRed = 1,//
    kColorYellow = 2,// 2
    kColowBlue = 4// 3
};
typedef enum Color Color;

// @"abc123456"

NSString *revertStr(NSString *inputStr)
{
    
//    Color c1 = kColorRed;
//    Color c2 = 2;
    
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    
    // 从后往前取，逐个放入新字符串
    for (int i= inputStr.length - 1;i>=0;i--)
    {
        [resultStr appendString:[inputStr substringWithRange:NSMakeRange(i, 1)]];
        NSLog(@"resultStr = %@",resultStr);
    }
    
    // 从前往后取,逐个插入在第一个位置
//    for(int i=0;i<inputStr.length;i++)
//    {
//        [resultStr insertString:[inputStr substringWithRange:NSMakeRange(i, 1)] atIndex:0];
//        NSLog(@"resultStr = %@",resultStr);
//    }
    
    return [resultStr copy];
}


NSString *numbetToString(int a)
{
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    int tmp = a;
    while (tmp>0)
    {
        int x = tmp%10;// 求余数
        tmp = tmp/10;
        
        switch (x)
        {
            case 0:
                [resultStr insertString:@"零" atIndex:0];
                break;
            case 1:
                [resultStr insertString:@"一" atIndex:0];
                break;
            case 2:
                [resultStr insertString:@"二" atIndex:0];
                break;
            case 3:
                [resultStr insertString:@"三" atIndex:0];
                break;
            case 4:
                [resultStr insertString:@"四" atIndex:0];
                break;
            case 5:
                [resultStr insertString:@"五" atIndex:0];
                break;
            case 6:
                [resultStr insertString:@"六" atIndex:0];
                break;
            case 7:
                [resultStr insertString:@"七" atIndex:0];
                break;
            case 8:
                [resultStr insertString:@"八" atIndex:0];
                break;
            case 9:
                [resultStr insertString:@"九" atIndex:0];
                break;
                
            default:
                break;
        }
    }
 
    return [resultStr copy];
}


int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        
#pragma mark -  复习基本类型
        // 基本类型        内存字节数
        // BOOL           1
        // char           1
        // int            4
        // unsigned int   4
        // short int      4
        // long int       8
        // unsigned long  8
        // long long      16
        // float          4
        // double         8
        // long double    16
        
        //sizeof查看占用内存字节数
        printf("%lu",sizeof(BOOL));
        
#pragma mark - 一、数字类 NSNumber
#pragma mark 创建构造
        NSNumber *a = [NSNumber numberWithInt:61]; // 61 -> NSNumber
        NSNumber *b = [[NSNumber alloc] initWithInt:62];// int
        NSNumber *c = @63;// int
        NSNumber *d = @123456ul;// unsigned long int
        NSNumber *e = @NO;// BOOL
        NSNumber *f = [NSNumber numberWithBool:YES];// BOOL
        NSNumber *g = @123.456f;// f float  不加f 默认double
        NSNumber *h = @'a';// char
        
        int x = 18;
        NSNumber *n = @(x);// 由基本类型变量创建
        
        // NSNumber -> 基本类型
        NSLog(@"%@ %@ %@ %@ %@ %@ %@,%@,%@",a,b,c,d,e?@"YES":@"NO",f,g,h,n);
        NSLog(@"a = %i,b = %i,c = %i,d = %ul,e = %i,f = %i,g = %g,h = %c,n=%i",[a intValue],[b intValue],[c intValue],[d unsignedIntegerValue],[e boolValue],[f boolValue],[g floatValue],[h charValue],[n intValue]);
        
#pragma mark  1 判断值是否相等
        NSNumber *num1 = @80;
        NSNumber *num2 = @80.1;
        if([num1 isEqualToNumber:num2])//注意:不是isEqualTo:(isEqualTo是对象比较，是不是同一个对象)
        {
            NSLog(@"相等");
        }
        else
        {
            NSLog(@"不相等");
        }
        
#pragma mark  2 判断大小
//        - (NSComparisonResult)compare:(NSNumber *)otherNumber; // 与另外一个数进行判断
        // 返回值是 NSComparisonResult 枚举类型
        // {NSOrderedAscending = -1L, 升序
        //  NSOrderedSame,            相等
        //  NSOrderedDescending};     递减
        
        NSComparisonResult result =  [num1 compare:num2];
        if(result == NSOrderedSame)
        {
            NSLog(@"相等");
        }
        else if(result == NSOrderedAscending)
        {
            NSLog(@"num1 < num2");
        }
        else
        {
            NSLog(@"num1 > num2");
        }
        
        // 练习:
        // 1 用cmd(win)+鼠标点击 NSNumber 查看NSNumber头文件中的定义
        // 2 用option(Alt）+鼠标点击 NSNumber 查看NSNumber文档的定义
        
        
#pragma mark - 二、字符串类 NSString
        
#pragma mark  创建、构造NSString对象
        NSString *str1 = @"test1234567";
        NSString *str2 = [[NSString alloc] init];
        NSString *str3 = [[NSString alloc] initWithString:str1];
        NSString *str4 = [[NSString alloc] initWithFormat:@"一个整数:%i",x];
        NSString *str5 = [NSString stringWithFormat:@"一个浮点数%f",80.1f];
        NSLog(@"%@",str5);
        
        // 相关的方法
#pragma mark  1 长度
        NSLog(@"字符串长度:%i",str1.length);
#pragma mark  2 字符串连接
        NSString *str6 = [str4 stringByAppendingString:str5];//str4 和 str5 连接之后产生了一个新的对象
        NSLog(@"指针地址%p %p %p",&str4,&str5,&str6);// 栈内存 4个字节
        NSLog(@"对象地址:%p %p %p",str4,str5,str6);// 对内存 4个对象
        
#pragma mark  3 大小写转换
        NSString *str7 = @"aBcDeFg";
        NSLog(@"%@",[str7 lowercaseString]);
        NSLog(@"%@",[str7 uppercaseString]);
        NSLog(@"%@",[str7 capitalizedString]);
#pragma mark  4 字符串的比较
        if([str1 isEqualToString:@"test1234567"])
        {
            NSLog(@"字符串相等");
        }
        else
        {
            NSLog(@"字符串不相等");
        }
        // 从第一个字母逐个比较，如果第一个相等，再比较第二个
        NSComparisonResult result2 = [str1 compare:@"tdst1234567"];
        if(result2 == NSOrderedSame)
        {
            NSLog(@"字符串相等");
        }
        else if(result2 == NSOrderedAscending)
        {
            NSLog(@"升序");
        }
        else
        {
            NSLog(@"反序");
        }
        
        // 注意:
        // 使用%p观察对象地址
        // NSString对象中内容中字符串是不可改变的的
        // 但指向NSString对象指针是可以指向新的NSString对象的
        
#pragma mark  5 字符串的截取(常用,重要!)
        NSString *str9 = @"aBcDeFg";
        NSLog(@"%p",str9);
        NSString *r = [str9 substringFromIndex:3];// 从哪里开始截取到结尾
        NSLog(@"%@ %p",r,r);// DeFg
        r = [str9 substringToIndex:3];// 从第一个字符开始截取几个
        NSLog(@"%@ %p",r,r);// AbC;
        // 如果我想截取cDe?怎么做?
        r = [[str9 substringFromIndex:2] substringToIndex:3];
        NSLog(@"%@ %p",r,r);
        
        // 6 字符串的查找(在字符串中查找子字符串的位置及长度)
        // - (NSRange)rangeOfString:(NSString *)searchString; // 查找字符串
//        NSrange r = [a rangeOfString:b]; 就是在a字符串中找b的位置
        
        // NSRange 是一个用来表示范围的结构体
//        typedef struct _NSRange {
//            NSUInteger location;// 位置
//            NSUInteger length;// 长度
//        } NSRange;
        // 如果找不到则 range.location 的值是NSNotFound
        // NSNotFound 一个最大的NSUInteger 其实也就是整数-1

        NSRange range = [str9 rangeOfString:@"Xe"];
        if(range.location == NSNotFound)
        {
            NSLog(@"没找到");
        }
        else
        {
            NSLog(@"位置:%lu,长度:%i",range.location,range.length);
        }
        
#pragma mark  C字符串 <--> OC字符串 转换
        // C字符串转NSString
        char *cStr = "xiaoming";
        // 编码方式
        NSString *ocStr = [[NSString alloc] initWithCString:cStr encoding:NSUTF8StringEncoding];
        NSLog(@"%s %@",cStr,ocStr);
        
        // OC -> C语言字符串
        char *cStr2 = ocStr.UTF8String;
         NSLog(@"%s",cStr2);
        
#pragma mark - 三、可变字符串类 NSMutableString
        
        NSString *s = @"Objective-C";
        NSMutableString *mStr = [s mutableCopy];//
        
        NSLog(@"%@",mStr);
        
#pragma mark  1 插入
        [mStr insertString:@" Java" atIndex:9];
        NSLog(@"插入之后:%@",mStr);
        [mStr insertString:@" and C++" atIndex:mStr.length];
        NSLog(@"插入之后:%@",mStr);
        
#pragma mark  2 追加
        [mStr appendString:@" and C"];
        NSLog(@"连接之后:%@",mStr);
        
#pragma mark  3 删除
        NSRange range1;
        range1 = NSMakeRange(16, 13);// 创建一个从location 16 length 13 的NSRange结构体变量
        [mStr deleteCharactersInRange:range1];// 删除指定范围的内容
        NSLog(@"删除之后:%@",mStr);
        
#pragma mark  4 设置
        [mStr setString:@"This is a string A"];
        NSLog(@"重新设置之后:%@",mStr);
        
        
#pragma mark  5 替换
        // NSMakeRange 是函数 参数传入位置及长度 返回一个NSRange结构体
//        NS_INLINE NSRange NSMakeRange(NSUInteger loc, NSUInteger len) {
//            NSRange r;
//            r.location = loc;
//            r.length = len;
//            return r;
//        }
        [mStr replaceCharactersInRange:NSMakeRange(8, 8) withString:@"a mutableString"];
        NSLog(@"替换之后:%@",mStr);
        
#pragma mark 查找和替换相结合
        range = [mStr rangeOfString:@"This is"];
        if(range.location !=
           NSNotFound)
        {
            [mStr replaceCharactersInRange:range withString:@"An Example of"];
            NSLog(@"替换之后:%@",mStr);
        }
        
        // 所有的a替换成X
        NSString *searchStr = @"a";
        NSString *replaceStr = @"X";
        range = [mStr rangeOfString:searchStr];
        while (range.location != NSNotFound)
        {
            [mStr replaceCharactersInRange:range withString:replaceStr];
            range = [mStr rangeOfString:searchStr];
        }
        NSLog(@"批量替换之后:%@",mStr);
        
#pragma mark  6 NSString 与 NSMutableString 相互转换
        
        // NSString -> NSMuatalbeString
//        NSString *str = @"abc";
//        NSMutableString *mutableStr = [str mutableCopy];
        NSMutableString *mutableStr = [@"abc" mutableCopy];// 产生一个新的可变的字符串对象
        
        //  NSMuatalbeString -> NSString
        // 方法1
//        NSString *sStr = [mutableStr copy];// 产生一个新的不可变的字符串对象
        // 方法2
//        NSString *sStr = [NSString stringWithFormat:@"%@",mutableStr];

#pragma mark - 练习
        // 1 @"iPhone Android WinPhone"
        //删除其中的Android
         ;
        NSMutableString *tmpStr2 = [@"iPhone Android WinPhone" mutableCopy];
//        NSRange tmpRange1 = [tmpStr2 rangeOfString:@"Android"];
        //NSMakeRange(7, 7);
        //{7,7};
//        tmpRange1.location = 7;
//        tmpRange1.length = 7;
        [tmpStr2 deleteCharactersInRange:[tmpStr2 rangeOfString:@"Android"]];
        NSLog(@"tmpStr2 = %@",tmpStr2);
        
        
        // 2 求字符串 str1 str2 数字之和,结果再放在一个NSString中
        // NSString *str1 = @"158";
        // NSString *str2 = @"39";
        // 查询文档中NSString类的相关文档
        // 找到Getting Numeric Values段
        // 有个intValue的方法 可以得到字符串的数字值
         NSString *strX1 = @"158";
         NSString *strX2 = @"39";
         NSString *resultXStr = [NSString stringWithFormat:@"%@", @([strX1 intValue] + [strX2 integerValue])];
        
        // 3 去掉字符串"123-456-789-000"中的-
        NSMutableString *mStrX1 = [@"123-456-789-000" mutableCopy];
        // 删除的方式
//        NSRange tmpRange2 = [mStrX1 rangeOfString:@"-"];
//        while (tmpRange2.location != NSNotFound)
//        {
//            [mStrX1 deleteCharactersInRange:tmpRange2];
//            NSLog(@"%@",mStrX1);
//            tmpRange2 = [mStrX1 rangeOfString:@"-"];
//        }
//        mStrX1 deleteCharactersInRange:<#(NSRange)#>
        
        // 4 @"老鼠抓猫，猫怕老鼠" 将字符串中的猫和老鼠交换
        NSMutableString *tmpStrX3 = [@"老鼠抓猫，猫怕老鼠" mutableCopy];
        // 老鼠->狗
        NSRange tmpRange3 = [tmpStrX3  rangeOfString:@"老鼠"];
        while (tmpRange3.location != NSNotFound)
        {
            [tmpStrX3 replaceCharactersInRange:tmpRange3 withString:@"狗"];
            NSLog(@"%@",tmpStrX3);
            tmpRange3 = [tmpStrX3 rangeOfString:@"老鼠"];
        }
        // 猫->老鼠
        tmpRange3 = [tmpStrX3  rangeOfString:@"猫"];
        while (tmpRange3.location != NSNotFound)
        {
            [tmpStrX3 replaceCharactersInRange:tmpRange3 withString:@"老鼠"];
            NSLog(@"%@",tmpStrX3);
            tmpRange3 = [tmpStrX3 rangeOfString:@"猫"];
        }
        // 狗->猫
        tmpRange3 = [tmpStrX3  rangeOfString:@"狗"];
        while (tmpRange3.location != NSNotFound)
        {
            [tmpStrX3 replaceCharactersInRange:tmpRange3 withString:@"猫"];
            NSLog(@"%@",tmpStrX3);
            tmpRange3 = [tmpStrX3 rangeOfString:@"狗"];
        }
        
        // 5 @"When the iphone was released in 2007, developers clamored for the opportunity to develop applications for this revolutionary device.At first,apple did not welcome third- party application development.The company’s way of placating wannabe iphone devel- opers was to allow them to develop web-based applications."
        //1)将这段字符串中所有iphone替换成iPhone
        //apple替换成Apple 显示输出
        //2)首字符大写输出
        
        // 6 将写一个函数实现字符串翻转，如原先字符串@"abc123456" 翻转后 @”654321cba“
        //用以下语句测试
        NSString *oldStr = @"abc1234567890";
        NSString *newStr = revertStr(oldStr);
        NSLog(@"%@",newStr);
        //打印显示除:
        //654321cba
        
        // 7 编写一个函数将数字转换成中文 比如165 -> @"一六五"
        // 用以下语句测试:
        NSString *resultStr3 = numbetToString(165234);
        NSLog(@"%@",resultStr3);
        //打印出:一六五
        
        //* 8 编写一个函数将数字转换成大写中文的金额 比如165 -> @"一六五"
        // 壹、贰、叁、肆、、陆、柒、捌、玖、拾、佰、仟、万、亿
        // 16 壹拾陆
        // 156 壹佰伍拾陆
        
#pragma mark - 附加

#pragma mark 字符串在比较和搜索的时候可以使用带选项的方法
        
        // 比较方法
//        - (NSComparisonResult)compare:(NSString *)string options:(NSStringCompareOptions)mask;
//        - (NSComparisonResult)compare:(NSString *)string options:(NSStringCompareOptions)mask range:(NSRange)compareRange;// 且指定搜索范围
        // 搜索方法
//        - (NSRange)rangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask;
//        - (NSRange)rangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)searchRange;
        
//        NSStringCompareOptions 是一个枚举类型 以下列出了枚举值具体的功能含义
//        enum{
//            NSCaseInsensitiveSearch = 1,//不区分大小写比较
//            NSLiteralSearch = 2,//区分大小写比较
//            NSBackwardsSearch = 4,//从字符串末尾开始搜索
//            NSAnchoredSearch = 8,//搜索限制范围的字符串
//            NSNumbericSearch = 64//按照字符串里的数字为依据，算出顺序。例如 Foo2.txt < Foo7.txt < Foo25.txt
//            //以下定义高于 mac os 10.5 或者高于 iphone 2.0 可用
//            ,
//            NSDiacriticInsensitiveSearch = 128,//忽略 "-" 符号的比较
//            NSWidthInsensitiveSearch = 256,//忽略字符串的长度，比较出结果
//            NSForcedOrderingSearch = 512//忽略不区分大小写比较的选项，并强制返回 NSOrderedAscending 或者 NSOrderedDescending
//            //以下定义高于 iphone 3.2 可用
//            ,
//            NSRegularExpressionSearch = 1024//只能应用于 rangeOfString:..., stringByReplacingOccurrencesOfString:...和 replaceOccurrencesOfString:... 方法。使用通用兼容的比较方法，如果设置此项，可以去掉 NSCaseInsensitiveSearch 和 NSAnchoredSearch
//        }
        
        // 例子1 不区分大小写比较
//        NSString *tmpStrY1 = @"abc";
//        NSString *tmpStrY2 = @"ABC";
//        if([tmpStrY1 compare:tmpStrY2 options:NSCaseInsensitiveSearch] == NSOrderedSame)//NSCaseInsensitiveSearch 不区分大小写比较
//        {
//            NSLog(@"abc 与 ABC 字符串相等");
//        }
//        else
//        {
//            NSLog(@"abc 与 ABC 不相等");
//        }
//
//        // 例子2 从后往前搜索
//        NSMutableString *tmpStr3 = [@"abc123abc" mutableCopy];
//        NSRange tmpRange = [tmpStr3 rangeOfString:@"abc" options:NSBackwardsSearch];//NSBackwardsSearch 从后往前搜索
//        [tmpStr3 deleteCharactersInRange:tmpRange];
//        NSLog(@"%@",tmpStr3);
//
//        // 例子3 从后往前搜索且忽略大小写
        NSMutableString *tmpStr4 = [@"abc123ABC" mutableCopy];
        
//        NSCaseInsensitiveSearch 1   001
//        NSBackwardsSearch       4   100
        //                            101
        // 两个条件选项用|
        NSRange tmpRange2 = [tmpStr4 rangeOfString:@"abc" options:NSBackwardsSearch|NSCaseInsensitiveSearch];//从后往前搜索且忽略大小写
        [tmpStr4 deleteCharactersInRange:tmpRange2];
        NSLog(@"%@",tmpStr4);

    }
    return 0;
}
