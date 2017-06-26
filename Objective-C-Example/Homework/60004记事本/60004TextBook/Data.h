//
//  Data.h
//  60004TextBook
//
//  Created by student on 16/3/8.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject

@property (nonatomic,copy) NSString *title,*time,*detail;


- (instancetype)initWithDict:(NSDictionary *)d;
+ (instancetype)dataWithDict:(NSDictionary *)d;
+ (void)updateNote:(NSUInteger)row andTitle:(NSString*)title andTime:(NSString *)time andDetail:(NSString *)d;
+ (void)deleteNote:(NSUInteger)row;
//+ (NSArray *)dataArr;
//+ (NSString *)dataDetailWithTitle:(NSString *)title;
//+ (Data *)dataWithTitle:(NSString*)t andTime:(NSString *)time andDetail:(NSString *)d;
@end
