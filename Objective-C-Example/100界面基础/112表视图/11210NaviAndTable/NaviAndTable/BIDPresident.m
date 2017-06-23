//
//  President.m
//  Lesson10_Nav
//
//  Created by Qiang on 13-7-28.
//  Copyright (c) 2013年 XiaohuiQiang. All rights reserved.
//

#import "BIDPresident.h"

@implementation BIDPresident

@synthesize number=_number,name=_name,fromYear=_fromYear,toYear=_toYear,party=_party;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.number forKey:kPresidentNumberKey];
    [aCoder encodeObject:self.name forKey:kPresidentNameKey];
    [aCoder encodeObject:self.fromYear forKey:kPresidentFromKey];
    [aCoder encodeObject:self.toYear forKey:kPresidentToKey];
    [aCoder encodeObject:self.party forKey:kPresidentPartyKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super init];
    if(self)
    {
        self.number=[aDecoder decodeIntForKey:kPresidentNumberKey];
        self.name=[aDecoder decodeObjectForKey:kPresidentNameKey];
        self.fromYear=[aDecoder decodeObjectForKey:kPresidentFromKey];
        self.toYear=[aDecoder decodeObjectForKey:kPresidentToKey];
        self.party=[aDecoder decodeObjectForKey:kPresidentPartyKey];
    }
    return self;
}
@end
