//
//  BookStore.h
//  KVCDemo
//
//  Created by niit on 16/1/13.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Book.h"

@interface BookStore : NSObject

@property (nonatomic,strong) Book *aBook;

@property (nonatomic,strong) NSMutableArray *books;

@end
