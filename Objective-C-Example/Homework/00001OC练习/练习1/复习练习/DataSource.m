//
//  DataSource.m
//  复习练习
//
//  Created by student on 16/3/11.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "DataSource.h"


@implementation DataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *dict = [NSDictionary  dictionaryWithContentsOfFile:@"/Users/maqianli/Library/Developer/Xcode/DerivedData/复习练习-dhesdhzhszuluuembrjbqwhrpxkm/Build/Products/Debug/足球队dictionary.plist"];
        NSArray *array = [dict.allKeys copy];
        NSMutableArray *mArray = [[NSMutableArray alloc]init];
        for (NSString *str in array) {
            [mArray addObjectsFromArray:dict[str]];
        }
        //排序
        NSArray *array1 = [array sortedArrayUsingSelector:@selector(compare:)];
        NSArray *array2 = [mArray sortedArrayUsingSelector:@selector(compare:)];
        self.teamNames = array2;
        self.groupNames = array1;
//        NSLog(@"%@,%@",self.teamNames,self.groupNames);

    }
    return self;
}


@end
