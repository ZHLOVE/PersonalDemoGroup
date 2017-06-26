# 中文网址

今天发现一个蛋疼的问题，服务端返回的urlString里面有时含有中文,使用
[NSURL URLWithString:urlString]生成URL对象时,iOS客户端不能正确进行网络请求,网上找到的URLEncode方法又不能完全解决问题.
   方法1:
NSString* encodedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

   方法2:
NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)urlString,NULL,NULL,kCFStringEncodingUTF8);

   这两种方法当urlString里含有中文时URL编码是正确的,但是如果其中含有已转义的%等符号时,又会再次转义而导致错误.
   
   查看方法2参数说明:
CFStringRef CFURLCreateStringByAddingPercentEscapes(CFAllocatorRef allocator, CFStringRef originalString, CFStringRef charactersToLeaveUnescaped, CFStringRef legalURLCharactersToBeEscaped, CFStringEncoding encoding);

因此做出修改,写出方法:
    NSString *encodedString = (NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)urlString,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingUTF8);


如果在所有的类里都要用到这个方法,可以写成category,然后在头文件import "NSString+URL.h" 即可调用.

NSString+URL.h  文件
[html] view plain copy
@interface NSString (URL)  
- (NSString *)URLEncodedString;  
@end  

NSString+URL.m  文件
[cpp] view plain copy
#import "NSString+URL.h"  
  
@implementation NSString (URL)  
  
- (NSString *)URLEncodedString  
{  
    NSString *encodedString = (NSString *)  
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,  
                                            (CFStringRef)self,  
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",  
                                            NULL,  
                                            kCFStringEncodingUTF8);  
    return encodedString;  
}  
@end  

调用方法:
    NSString *encodedString = [urlString URLEncodedString];
    //encodedString do something