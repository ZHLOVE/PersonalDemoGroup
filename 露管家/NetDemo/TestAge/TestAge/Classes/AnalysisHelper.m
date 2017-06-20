//
//  AnalysisHelper.m
//  TestAge
//
//  Created by niit on 16/4/11.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "AnalysisHelper.h"

#import <TFHpple.h>
#import <TFHppleElement.h>
@implementation AnalysisHelper

+ (NSArray *)analysisImagesResult:(NSData *)data
{
    // 解析html代码
    
    // 3. 解析网页内容，找出所需要的信息
    TFHpple *hpple = [TFHpple hppleWithHTMLData:data];
    
    // 通过一个xpath来查找所需信息
    NSString *xpath = @"//div [@class='ImageSelector']/div [@class='ScrollArea notSelectedImage']/img";
    
    NSArray *arr = [hpple searchWithXPathQuery:xpath];
    
    NSMutableArray *mArr = [NSMutableArray array];
    for(TFHppleElement *tmp in arr)
    {
        NSDictionary *dict = tmp.attributes;
        NSString *imgUrl = dict[@"src"];
        // data-url
        [mArr addObject:imgUrl];
    }
    
    return mArr;
}

+ (NSDictionary *)analysisInfo:(NSString *)str
{
    // 处理数据去掉\r\n
    str  = [str stringByReplacingOccurrencesOfString:@"\\\\r\\\\n" withString:@"\r\n"];// \\r\\n => \r\n
    str  = [str stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];// \" => "
    str  = [str stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];// \" => "
    str  = [str stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];// \" => "
    str  = [str stringByReplacingOccurrencesOfString:@"\"[" withString:@"["];// “[ => [
    str  = [str stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];// ]" => ]
    str  = [str stringByReplacingOccurrencesOfString:@"}\"" withString:@"}"];// "{ => {
    str  = [str stringByReplacingOccurrencesOfString:@"\"{" withString:@"{"];// }" => }
    NSLog(@"------------");
    NSLog(@"%@",str);
    
    NSData *d = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:d options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"dict:%@",dict);
    
    return dict;
}
@end
