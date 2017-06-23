//
//  StateZips.m
//  UIPickerViewDemo
//
//  Created by niit on 16/2/24.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "StateZips.h"

// 单例模式
static StateZips *instance = nil;

@interface StateZips()

// 保存所有城市邮编信息
@property (nonatomic,strong) NSDictionary *stateZips;
// 保存所有城市名字
@property (nonatomic,strong) NSArray *states;

@end

@implementation StateZips

// 得到单例对象
+ (StateZips *)sharedStateZips
{
    if(instance == nil)
    {
        instance = [[StateZips alloc] init];
    }
    return instance;
}

// 初始化
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // 1.1 读出所有城市邮编信息
        NSString *path = [[NSBundle mainBundle] pathForResource:@"statedictionary" ofType:@"plist"];// 文件的路径
        self.stateZips = [NSDictionary dictionaryWithContentsOfFile:path];

        // 1.2 得到所有城市的名字数组
        self.states = [[self.stateZips allKeys] sortedArrayUsingSelector:@selector(compare:)];
    }
    return self;
}

// 州名字列表
+ (NSArray *)states
{
    StateZips *s = [[StateZips alloc] init];
    // 采用单例
//    StateZips *s = [StateZips sharedStateZips];
    return s.states;
}

// 当前州对应的邮编列表
+ (NSArray *)zipsFor:(NSString *)state
{
    StateZips *s = [[StateZips alloc] init];
    // 采用单例
//    StateZips *s = [StateZips sharedStateZips];
    return s.stateZips[state];
}

@end
