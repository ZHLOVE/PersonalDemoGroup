//
//  AppsModel.h
//  11216AppList
//
//  Created by 马千里 on 16/3/9.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppsModel : NSObject

@property(nonatomic,copy)NSString *image,*edition,*fortune,*softName;

- (instancetype)initWithDict:(NSDictionary *)d;

+ (instancetype)AppsModelWith:(NSDictionary *)dict;

@end
