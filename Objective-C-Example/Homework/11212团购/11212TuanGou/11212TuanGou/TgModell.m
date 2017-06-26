//
//  TgModell.m
//  11212TuanGou
//
//  Created by 马千里 on 16/3/7.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "TgModell.h"

@implementation TgModell



- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
    
}
+ (instancetype)tgWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

+ (NSArray *)tgList{
    // 字典数组
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tgs" ofType:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    
    // => 模型数组
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSDictionary *dict in arr)
    {
        TgModell *m = [TgModell tgWithDict:dict];
        [mArr addObject:m];
    }
    
    return mArr;
}

@end