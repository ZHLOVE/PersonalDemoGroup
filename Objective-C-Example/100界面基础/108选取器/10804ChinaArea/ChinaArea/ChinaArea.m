//
//  ChinaArea.m
//  ChinaArea
//
//  Created by niit on 16/3/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ChinaArea.h"

static ChinaArea *instance = nil;

@interface ChinaArea()

@property (nonatomic,strong) NSDictionary *allDict;
@property (nonatomic,strong) NSArray *provinces;

@end

@implementation ChinaArea

+ (ChinaArea *)sharedChinaArea
{
    if(instance == nil)
    {
        instance = [[ChinaArea alloc] init];
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"area2" ofType:@"plist"];
        self.allDict = [NSDictionary dictionaryWithContentsOfFile:path];
        
        // 1. 处理省的名字
        NSMutableArray *provinces = [NSMutableArray array];
        NSArray *tmpArr1 = [[self.allDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if([obj1 intValue]>[obj2 intValue])
            {
                return 1;
            }
            else if([obj1 intValue]<[obj2 intValue])
            {
                return -1;
            }
            else
            {
                return 0;
            }
        }];
        NSLog(@"%@",tmpArr1);
        for(NSString *key in tmpArr1)
        {
            NSDictionary *tmpDict1 = self.allDict[key];
            NSArray *tmpArr2 = tmpDict1.allKeys;
            NSLog(@"%@",tmpArr2[0]);// 省会名
            
            [provinces addObject:tmpArr2[0]];
        }
        self.provinces = provinces;
        
        
    }
    return self;
}

// 根据省的名字得到省的字典信息
- (NSDictionary *)dictForProvinces:(NSString *)name
{
    NSUInteger index = [self.provinces indexOfObject:name];
    NSDictionary *tmpDict1 = self.allDict[[NSString stringWithFormat:@"%i",index]];
    NSDictionary *tmpDict2 = [tmpDict1 allValues][0];
    return tmpDict2;
}

// 根据省名字得到子城市数组
- (NSArray *)citsForProvince:(NSString *)province
{
    NSDictionary *dict = [self dictForProvinces:province];
    NSArray *keys = [[dict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if([obj1 intValue]>[obj2 intValue])
        {
            return 1;
        }
        else if([obj1 intValue]<[obj2 intValue])
        {
            return -1;
        }
        else
        {
            return 0;
        }
    }];
    NSMutableArray *mArr = [NSMutableArray array];
    
    for(NSString *key in keys)
    {
        NSDictionary *tmpDict1 = dict[key];
        NSString *name = [tmpDict1 allKeys][0];
        [mArr addObject:name];
    }
    
    return mArr;
}

- (NSArray *)zoneForProvince:(NSString *)province andCity:(NSString *)city
{
    NSDictionary *dict = [self dictForProvinces:province];
    NSArray *citysArr = [self citsForProvince:province];
    NSUInteger index = [citysArr indexOfObject:city];
    NSDictionary *tmpDict1 = dict[[NSString stringWithFormat:@"%i",index]];
    NSArray *tmpArr1 = tmpDict1[city];
    
    return tmpArr1;
}

#pragma mark -
// 得到省会列表
+ (NSArray *)provinces
{
    return [self sharedChinaArea].provinces;
}

// 得到某省会的城市数组
+ (NSArray *)citsForProvince:(NSString *)province
{
    return [[self sharedChinaArea] citsForProvince:province];
}

// 得到某省会的某城市下的区数组
+ (NSArray *)zoneForProvince:(NSString *)province andCity:(NSString *)city
{
    return [[self sharedChinaArea] zoneForProvince:province andCity:city];
}


@end
