//
//  NoteModel.m
//  Note
//
//  Created by niit on 16/3/16.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "NoteModel.h"

@implementation NoteModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)NoteWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}


@end
