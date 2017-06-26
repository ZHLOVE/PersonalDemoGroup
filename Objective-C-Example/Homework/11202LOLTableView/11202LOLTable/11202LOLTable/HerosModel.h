//
//  herosModel.h
//  11202LOLTable
//
//  Created by student on 16/3/3.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HerosModel : NSObject

@property(nonatomic,strong) NSMutableArray *imgName;
@property(nonatomic,strong) NSMutableArray *heroName;
@property(nonatomic,strong) NSMutableArray *heroInfo;

+ (NSArray *)imgName;
+ (NSArray *)heroName;
+ (NSArray *)heroInfo;

@end
