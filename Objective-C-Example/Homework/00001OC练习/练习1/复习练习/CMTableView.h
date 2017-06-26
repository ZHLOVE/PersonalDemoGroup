//
//  CMTableView.h
//  复习练习
//
//  Created by student on 16/3/11.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSource.h"





@interface CMTableView : NSObject


@property(nonatomic,strong) NSArray *sectionArray;
@property(nonatomic,strong) NSArray *rowArray;

@property(nonatomic,weak) DataSource *dataSource;


- (void)show;
@end
