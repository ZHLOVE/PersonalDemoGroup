//
//  SQLite.h
//  myDict
//
//  Created by student on 16/4/13.
//  Copyright © 2016年 Five. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Singleton.h"
@interface SQLite : NSObject

SingletonH(SQLite)

- (void)openDB;
- (NSArray *)quaryInfoWithStr:(NSString *)str;
@end
