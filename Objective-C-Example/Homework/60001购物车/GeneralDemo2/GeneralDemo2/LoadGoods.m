//
//  LoadGoods.m
//  GeneralDemo2
//
//  Created by 马千里 on 16/2/28.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "LoadGoods.h"
static LoadGoods *instance = nil;
@interface LoadGoods ()

@property(nonatomic,strong) NSMutableArray *goodsAlreadyCount;

@property(nonatomic,strong) NSMutableArray *goodsTotalCount;

@property(nonatomic,strong) NSMutableArray *goodsPicture;

@end

@implementation LoadGoods

+ (LoadGoods *)sharedLoadGoods{
    if (instance == nil) {
        instance = [[LoadGoods alloc]init];
    }
    return instance;
}

- (instancetype)init
{
    _goodsAlreadyCount = [[NSMutableArray alloc]init];
    _goodsTotalCount = [[NSMutableArray alloc]init];
    _goodsPicture = [[NSMutableArray alloc]init];

    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"goods" ofType:@"plist"];
        NSArray *arry = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *tempDict in arry) {
            [_goodsAlreadyCount addObject:[tempDict objectForKey:@"alreadyCount"]];
            [_goodsTotalCount addObject:tempDict[@"totalCount"]];
            [_goodsPicture addObject:tempDict[@"picture"]];
        }
        
        }
    return self;
}

+(NSArray *)goodsAlreadyCount{
    LoadGoods *goods = [[LoadGoods alloc]init];
    return goods.goodsAlreadyCount;

}

+(NSArray *)goodsTotalCount{
    LoadGoods *goods = [[LoadGoods alloc]init];
    return goods.goodsTotalCount;

}

+(NSArray *)goodsPicture{
    LoadGoods *goods = [[LoadGoods alloc]init];
    return goods.goodsPicture;
}

@end
