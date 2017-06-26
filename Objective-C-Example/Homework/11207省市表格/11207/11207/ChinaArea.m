//
//  ChinaArea.m
//  10803省市PickerView
//
//  Created by student on 16/2/24.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ChinaArea.h"

//单例模式
static ChinaArea *instance = nil;

@interface ChinaArea()




@end


@implementation ChinaArea

//得到单例对象
+ (ChinaArea *)sharedChinaArea{
    if (instance == nil) {
        instance = [[ChinaArea alloc]init];
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.provinces = [[NSMutableArray alloc]init]; //不初始化的话无法写入数组元素
        self.cities = [[NSMutableArray alloc]init];
        //1读出所有省信息
        NSString *path = [[NSBundle mainBundle] pathForResource:@"area1" ofType:@"plist"];
        self.filePlist = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *tempDict in self.filePlist) {
            [self.provinces addObject:[tempDict objectForKey:@"State"]];
        }
    }
    return self;
}


//得到省会列表
+ (NSArray *)provinces{
    ChinaArea *area = [ChinaArea sharedChinaArea];
//    NSLog(@"%@",area.provinces);
    return area.provinces;
}

//得到某省会的城市数组
+ (NSArray *)citiesForProvince:(NSString *)province{
    
    ChinaArea *area = [ChinaArea sharedChinaArea];
    //坑爹的area1.plist文件
   
    for (NSDictionary *tempDict in area.filePlist) {
        if ([[tempDict objectForKey:@"State"] isEqualToString:province]) {
            [area.cities removeAllObjects]; //清空一下城市列表
            NSArray *cities = [[tempDict objectForKey:@"Cities"] copy];
            for (NSDictionary *tempDict_2 in cities) {
                [area.cities addObject:[tempDict_2 objectForKey:@"city"]];
//                NSLog(@"%@",area.cities[0]);
            }
        }
    }
    return area.cities;

}

@end
