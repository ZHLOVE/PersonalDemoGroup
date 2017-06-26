//
//  NewsModel.h
//  11215
//
//  Created by 马千里 on 16/3/9.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

@property(nonatomic,copy)NSString *image,*title,*date,*Text;

- (instancetype)initWithDict:(NSDictionary *)d;

+ (instancetype)NewsModelWith:(NSDictionary *)dict;
@end
