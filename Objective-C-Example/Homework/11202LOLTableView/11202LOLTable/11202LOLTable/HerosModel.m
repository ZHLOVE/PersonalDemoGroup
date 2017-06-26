//
//  herosModel.m
//  11202LOLTable
//
//  Created by student on 16/3/3.
//  Copyright © 2016年 马千里. All rights reserved.
//


#import "HerosModel.h"
static HerosModel *instance = nil;

@implementation HerosModel

+ (HerosModel *)sharedHerosModel{
    if (instance == nil) {
            instance = [[HerosModel alloc]init];
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.heroName = [[NSMutableArray alloc]init];
        self.heroInfo = [[NSMutableArray alloc]init];
        self.imgName = [[NSMutableArray alloc]init];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"heroes" ofType:@"plist"];
        NSArray *herosArray = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *dict in herosArray) {
            [self.heroName addObject:dict[@"name"]];
            [self.heroInfo addObject:dict[@"intro"]];
            [self.imgName addObject:dict[@"icon"]];
        }
      
    }
    return self;
}

+ (NSArray *)imgName{
    HerosModel *h = [[HerosModel alloc]init];
    return h.imgName;
}

+ (NSArray *)heroName{
    HerosModel *h = [[HerosModel alloc]init];
    return h.heroName;
}

+ (NSArray *)heroInfo{
    HerosModel *h = [[HerosModel alloc]init];
    return h.heroInfo;
}

@end






















