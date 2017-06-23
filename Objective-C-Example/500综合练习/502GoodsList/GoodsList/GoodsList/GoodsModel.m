//
//  GoodsModel.m
//  GoodsList
//
//  Created by niit on 16/2/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        // KVC方式设置 dict里的key要和本类的属性完全一致
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)goodsModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (NSArray *)goodsArr
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"goods" ofType:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *mArr = [NSMutableArray array];
    for(NSDictionary *dict in arr)
    {
        GoodsModel *m = [GoodsModel goodsModelWithDict:dict];
        [mArr addObject:m];
    }
    return mArr;
}

@end
