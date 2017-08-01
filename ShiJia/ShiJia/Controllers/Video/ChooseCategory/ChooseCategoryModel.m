//
//  ChooseCategoryModel.m
//  ShiJia
//
//  Created by 峰 on 2016/12/30.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "ChooseCategoryModel.h"
#import "CornerEntity.h"

@implementation ChooseCategoryModel


+ (NSDictionary *)objectClassInArray{
    return @{@"condition" : [Condition class], @"sort" : [Sort class]};
}
@end
@implementation Condition

@end


@implementation Sort

@end

//@implementation requsetModel
//
//@end

@implementation searchDataModel

+ (NSDictionary *)objectClassInArray{
    return @{@"programSeries" : [programSeries class]};
}

@end

@implementation programSeries

+ (NSDictionary *)objectClassInArray{
    return @{@"corner" : [CornerEntity class]};
}

//-(NSArray<CornerEntity *> *)corner{
//    CornerEntity *entity = [CornerEntity new];
//    entity.cornerImg = @"http://112.25.75.39/cos/cos/cos/specialpt/corner/huiyuanjiaobao.png";
//    entity.position = @"1";
//    _corner =@[entity];
//    return _corner;
//}


@end

//@implementation corner
//
//
//@end
