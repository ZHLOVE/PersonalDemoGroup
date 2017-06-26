//
//  def.h
//  预处理
//
//  Created by niit on 15/12/22.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#ifndef def_h
#define def_h


// 编译前进行替换工作

// 2 预定常亮
#define PI 3.1415926
#undef PI

#define kErrorMessage1 @"测试错误"
#define kErrorMessage2 @"用户名错误"
#define kErrorMessage3 @"密码错误"
#define kErrorMessage4 @"邮箱错误"
#define kPokeCount 54

// 地图大小
#define kMapSize 10

// 服务器端口
#define kIp  @"192.168.13.2"
#define kPort 8080


// 带参数的宏定义
// 求平方
#define PF(x)  ((x)*(x))

// 求和
#define SUB(x,y)  ((x)-(y))


// 3 条件编译

//#define MAC

#ifdef MAC
    #define OS @"MacoOS 10.11.1"
#else
    #define OS @"iOS 9.2"
#endif



#endif /* def_h */
