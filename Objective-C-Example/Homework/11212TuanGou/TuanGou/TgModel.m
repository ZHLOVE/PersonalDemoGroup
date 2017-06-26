//
//  TgModel.m
//  TuanGou
//
//  Created by niit on 16/3/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "TgModel.h"

@implementation TgModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)tgWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (NSArray *)tgList
{
    // 字典数组
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tgs" ofType:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    
    // => 模型数组
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSDictionary *dict in arr)
    {
        TgModel *m = [TgModel tgWithDict:dict];
        [mArr addObject:m];
    }
    
    return mArr;
}
@end
