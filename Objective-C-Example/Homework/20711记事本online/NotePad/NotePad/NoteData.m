//
//  NoteData.m
//  NotePad
//
//  Created by student on 16/3/30.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "NoteData.h"

@implementation NoteData

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)dataWithDict:(NSDictionary *)d
{
    return [[self alloc]initWithDict:d];
}

@end
