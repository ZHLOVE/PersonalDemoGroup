//
//  EmployeeM.m
//  WingsBurning
//
//  Created by MBP on 16/8/19.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "EmployeeM.h"
#import "NSString+Utils.h"//汉字转英文
#import "MJExtension.h"


@implementation EmployeeM

- (void)setName:(NSString *)name{
    if (name) {
        _name = name;
        _pinyin = _name.pinyin;
    }
}

- (NSString *)pinyin{
    return [_pinyin lowercaseString];
}
//**这是因为七牛使用cdn缓存加速访问资源，而cdn的缓存并不能马上失效，导致了更新资源后还是访问到的旧的资源。你可以通过http://sunyi.qiniudn.com/test.txt?v=23333这样的url，在资源后面带上query强制从七牛源站获取资源，而不是从cdn节点上获取资源，来获得最新的资源；另外你也可以再空间设置的高级设置中刷新你更新的资源的url，来达到资源更新的目的。*/
/*
- (NSString *)avatar_url{
    int ranNum = arc4random()%100;
    NSString *str = [NSString stringWithFormat:@"&=%@",@(ranNum)];
    NSString *url = [_avatar_url stringByAppendingString:str];
    return url;
}
*/

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
MJExtensionLogAllProperties
@end
