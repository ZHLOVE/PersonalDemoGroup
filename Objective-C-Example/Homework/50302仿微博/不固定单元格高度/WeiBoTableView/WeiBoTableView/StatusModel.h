//
//  StatusModel.h
//  WeiBoTableView
//
//  Created by student on 16/3/8.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusModel : NSObject

@property (nonatomic,copy) NSString *icon,*name,*text,*picture;
@property (nonatomic,assign) BOOL vip;


- (instancetype)initWithDict:(NSDictionary *)d;

+ (instancetype)statusWithDict:(NSDictionary *)d;

+ (NSArray *)statusArr;

@end
