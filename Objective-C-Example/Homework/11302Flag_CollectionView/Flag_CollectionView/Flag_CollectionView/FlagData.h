//
//  FlagData.h
//  Flag_CollectionView
//
//  Created by student on 16/3/9.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlagData : NSObject

@property(nonatomic,strong) NSString  *name;
@property(nonatomic,strong) NSString *imageName;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)flagWithDict:(NSDictionary *)dict;

//+ (NSString *)flagesName:(NSInteger )row;
//
//+ (NSString *)flagesImage:(NSInteger )row;

@end
