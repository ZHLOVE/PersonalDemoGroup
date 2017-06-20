//
//  FoodData.h
//  LGJ
//
//  Created by student on 16/5/18.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodData : NSObject

@property(nonatomic,strong) NSString *nameStr,*ellipsisStr,*statsScore,*statsNum,*authorName,*authorUrl;

+ (instancetype)dataWithDict:(NSDictionary *)d;
@end
