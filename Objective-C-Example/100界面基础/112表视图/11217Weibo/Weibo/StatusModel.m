//
//  StatusModel.m
//  Weibo
//
//  Created by niit on 16/3/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "StatusModel.h"

@implementation StatusModel

- (instancetype)initWithDict:(NSDictionary *)d
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:d];
    }
    return self;
}

+ (instancetype)statusWithDict:(NSDictionary *)d
{
    return [[self alloc] initWithDict:d];
}

+ (NSArray *)statusArr
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"statuses" ofType:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSDictionary *dict in arr)
    {
        StatusModel *m = [StatusModel statusWithDict:dict];
        [mArr addObject:m];
    }
    
    return mArr;
}
@end
