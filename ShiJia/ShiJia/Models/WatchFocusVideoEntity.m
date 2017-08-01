//
//  WatchFocusVideoEntity.m
//  HiTV
//
//  Created by lanbo zhang on 8/1/15.
//  Copyright (c) 2015 Lanbo Zhang. All rights reserved.
//

#import "WatchFocusVideoEntity.h"

@interface WatchFocusVideoEntity()

@property (nonatomic, readwrite) NSString<Ignore>* lastUpdatedString;

@end
@implementation WatchFocusVideoEntity

+(BOOL)propertyIsOptional:(NSString*)propertyName{
    return YES;
}


- (NSString<Ignore>*) lastUpdatedString{
    if (_lastUpdatedString) {
        return _lastUpdatedString;
    }
    
    NSDate* date = nil;
    if (self.lastUpdate > 0) {
        date = [NSDate dateWithTimeIntervalSince1970:self.lastUpdate];
    }else if(self.updateTime > 0){
        date = [NSDate dateWithTimeIntervalSince1970:self.updateTime];
    }
    
    if (date) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM'月'dd'日 ' hh:mm";
        _lastUpdatedString = [formatter stringFromDate:date];
    }

    return _lastUpdatedString;
}
@end
