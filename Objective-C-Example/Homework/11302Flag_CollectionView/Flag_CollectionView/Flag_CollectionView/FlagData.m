//
//  FlagData.m
//  Flag_CollectionView
//
//  Created by student on 16/3/9.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "FlagData.h"


@implementation FlagData


- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        
    }
    return self;
}

+ (instancetype)flagWithDict:(NSDictionary *)dict{
    
    return [[self alloc]initWithDict:dict];
}


//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
       
//    }
//    return self;
//}



//获取图片
//+ (NSString *)flagesName:(NSInteger )row{
//    FlagData *flag = [[FlagData alloc]init];
//    return  flag.name[row];
//}
//
//+ (NSString *)flagesImage:(NSInteger )row{
//    FlagData *flag = [[FlagData alloc]init];
//    return  flag.imageName[row];
//}

@end
