//
//  StateZips.m
//  UIPickerView
//
//  Created by student on 16/2/24.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "StateZips.h"

static StateZips *instance = nil;

@interface StateZips()

@property (nonatomic,strong) NSDictionary *stateZips;
@property (nonatomic,strong) NSArray *allStates;

@end


@implementation StateZips

+ (StateZips *)sharedStateZips{
    if (instance == nil) {
        instance = [[StateZips alloc]init];
    }
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
            // 1.1 读出所有城市邮编信息
        NSString *path = [[NSBundle mainBundle] pathForResource:@"statedictionary" ofType:@"plist"];
        self.stateZips = [NSDictionary dictionaryWithContentsOfFile:path];
              // 1.2 得到所有城市的名字数组
        self.allStates = [[self.stateZips allKeys] sortedArrayUsingSelector:@selector(compare:)];
    }
    return self;
}

//州名字列表
+ (NSArray *)states{
    StateZips *stateZips = [StateZips sharedStateZips];
    return stateZips.allStates;
}
//当前州对应的邮编列表
+ (NSArray *)zipsFor:(NSString *)state{
    StateZips *zips = [StateZips sharedStateZips];
    return zips.stateZips[state];
}

@end
