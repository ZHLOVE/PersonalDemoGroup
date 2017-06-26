//
//  DataSource.h
//  复习练习
//
//  Created by student on 16/3/11.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataSource : NSObject

@property(nonatomic,copy) NSArray *teamNames;
@property(nonatomic,copy) NSArray *groupNames;


- (NSArray *)tableViewSection:(NSArray *)s;
- (NSArray *)tableViewRow:(NSArray *)r;

@end
