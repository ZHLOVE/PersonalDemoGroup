//
//  Singleton.h
//  单例模式
//
//  Created by niit on 16/3/23.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#ifndef Singleton_h
#define Singleton_h

#define SingletonH(name) + (instancetype)share##name;

#define SingletonM(name) \
static id instance = nil;\
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone\
{\
    @synchronized(self)\
    {\
        if(instance == nil)\
        {\
            instance = [super allocWithZone:zone];\
        }\
    }\
    return instance;\
}\
\
+ (instancetype)share##name\
{\
    @synchronized(self)\
    {\
        if(instance == nil)\
        {\
            instance = [[self alloc] init];\
        }\
    }\
    return instance;\
}\
\
- (id)copyWithZone:(nullable NSZone *)zone\
{\
    return instance;\
}


#endif /* Singleton_h */
