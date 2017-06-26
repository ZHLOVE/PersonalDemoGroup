//
//  Data.m
//  60004TextBook
//
//  Created by student on 16/3/8.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "Data.h"

@implementation Data

- (instancetype)initWithDict:(NSDictionary *)d
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:d];
    }
    return self;
}

+ (instancetype)dataWithDict:(NSDictionary *)d
{
    return [[self alloc]initWithDict:d];
}

+ (Data *)dataWithTitle:(NSString*)t andTime:(NSString *)time andDetail:(NSString *)d{
    Data *data = [[Data alloc]init];
    data.title = t;
    data.time = time;
    data.detail = d;
    return data;
}

////读取所有记录
//+ (NSArray *)dataArr{
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSMutableArray *mArray = [NSMutableArray array];
//    mArray = [[userDefault objectForKey:@"NoteBook"] mutableCopy];
//    NSMutableArray *newArray = [NSMutableArray array];
//    for (NSDictionary *d in mArray) {
//        Data *m = [Data dataWithDict:d];
//        [newArray addObject:m];
//    }
//    //newArray中寸了所有的记录条目
//    return newArray;
//}

////显示内容
//+ (NSString *)dataDetailWithTitle:(NSString *)title{
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSMutableArray *mArray = [NSMutableArray array];
//    mArray = [[userDefault objectForKey:@"NoteBook"] mutableCopy];
//    for (NSDictionary *d in mArray) {
//        if ([[d objectForKey:@"title"] isEqualToString:title]) {
//            return [d objectForKey:@"detail"];
//        }
//    }
//    return nil;
//}

//删除
+ (void)deleteNote:(NSUInteger)row{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *mArray = [NSMutableArray array];
    mArray = [[userDefault objectForKey:@"NoteBook"] mutableCopy];
    [mArray removeObjectAtIndex:row];
    [userDefault setObject:[mArray copy] forKey:@"NoteBook"];
    // 保存
    [userDefault synchronize];
//    NSLog(@"%@",mArray);
}

//同步
+ (void)updateNote:(NSUInteger)row andTitle:(NSString*)title andTime:(NSString *)time andDetail:(NSString *)d;
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *mArray = [NSMutableArray array];
    mArray = [[userDefault objectForKey:@"NoteBook"] mutableCopy];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:title forKey:@"title"];
    [dict setObject:time forKey:@"time"];
    [dict setObject:d forKey:@"detail"];
    [mArray replaceObjectAtIndex:row withObject:dict];
    [userDefault setObject:[mArray copy] forKey:@"NoteBook"];
    // 保存
    [userDefault synchronize];
}
@end
