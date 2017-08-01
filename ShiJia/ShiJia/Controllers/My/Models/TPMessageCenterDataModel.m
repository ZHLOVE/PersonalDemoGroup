//
//  TPMessageModel.m
//  HiTV
//
//  Created by yy on 15/7/28.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "TPMessageCenterDataModel.h"
#import "TPIMNodeModel.h"

@implementation TPMessageCenterDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self) {
    
        self.from = [TPIMNodeModel mj_objectWithKeyValues:[dictionary valueForKey:@"from"]];
        self.msgId = [dictionary objectForKey:@"msgId"];
        self.read = [[dictionary objectForKey:@"read"] boolValue];
        self.type = [dictionary objectForKey:@"type"];
        if ([[dictionary objectForKey:@"title"] isKindOfClass:[NSNull class]]) {
            self.title = @"";
        }
        else{
            self.title = [dictionary valueForKey:@"title"];
        }
        
        if ([dictionary objectForKey:@"time"] != nil) {
            if ([[dictionary objectForKey:@"time"] isKindOfClass:[NSNumber class]]) {
                self.time = [[dictionary objectForKey:@"time"] stringValue];
            }
            
        }
        
        NSArray *toa = [dictionary valueForKey:@"to"];
        NSMutableArray *toarray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in toa) {
            TPIMNodeModel *todata = [TPIMNodeModel mj_objectWithKeyValues:dic];
            [toarray addObject:todata];
        }
        self.to = [NSArray arrayWithArray:toarray];
        
    }
    return self;
}

@end
