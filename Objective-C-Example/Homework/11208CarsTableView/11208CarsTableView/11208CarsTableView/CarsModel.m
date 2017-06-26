//
//  ChinaArea.m
//  10803省市PickerView
//
//  Created by student on 16/2/24.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "CarsModel.h"

//单例模式
static CarsModel *instance = nil;

@interface CarsModel()




@end


@implementation CarsModel

//得到单例对象
+ (CarsModel *)sharedCarsModel{
    if (instance == nil) {
        instance = [[CarsModel alloc]init];
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = [[NSMutableArray alloc]init]; //不初始化的话无法写入数组元素
        self.cars = [[NSMutableArray alloc]init];
        //1读出所有首字母信息
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cars_total" ofType:@"plist"];
        self.filePlist = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *tempDict in self.filePlist) {
            [self.title addObject:[tempDict objectForKey:@"title"]];
        }
    }
    return self;
}


//得到首字母列表
+ (NSArray *)title{
    CarsModel *area = [CarsModel sharedCarsModel];
//    NSLog(@"%@",area.title);
    return area.title;
}

//得到该字母下的汽车品牌
+ (NSArray *)carsForTitle:(NSString *)title{
    
    CarsModel *area = [CarsModel sharedCarsModel];

   
    for (NSDictionary *tempDict in area.filePlist) {
        if ([[tempDict objectForKey:@"title"] isEqualToString:title]) {
            [area.cars removeAllObjects]; //清空一下汽车列表
            NSArray *cities = [[tempDict objectForKey:@"cars"] copy];
            for (NSDictionary *tempDict_2 in cities) {
                [area.cars addObject:[tempDict_2 objectForKey:@"name"]];
//                NSLog(@"%@",area.cars[3]);
            }
        }
    }
    return area.cars;

}

@end
