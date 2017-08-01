//
//  WatchFocusVideoProgramEntity.m
//  HiTV
//
//  Created by lanbo zhang on 8/1/15.
//  Copyright (c) 2015 Lanbo Zhang. All rights reserved.
//

#import "WatchFocusVideoProgramEntity.h"

@implementation WatchFocusVideoProgramEntity

+(BOOL)propertyIsOptional:(NSString*)propertyName{
    return YES;
}

- (NSString*) programMobileUrl{
    if (_programMobileUrl.length==0) {
        return _programUrl;
    }
    return _programMobileUrl;
}

- (NSString*) info{
    return self.programName;
}

- (NSString*)detailsid{
    return self.programId;
}
@end
