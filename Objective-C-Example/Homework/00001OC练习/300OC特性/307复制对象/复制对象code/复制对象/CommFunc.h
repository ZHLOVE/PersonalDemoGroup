//
//  CommFunc.h
//  综合应用
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

// 写成函数
#import "def.h"

//返回值 函数名(参数类型 形参)
//{
//    return <#expression#>
//}

//NSString *contatctTypeToString(ContactType type);


// 公用的类 实现了一些类方法
@interface CommFunc : NSObject

// 类方法
+ (NSString *)contatctTypeToString:(ContactType)type;

@end
