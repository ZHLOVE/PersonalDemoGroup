//
//  TVStation.m
//
//  created by iSwift on 3/8/14
//  Copyright (c) 2014 . All rights reserved.
//

#import "TVStation.h"


NSString *const kTVStationUsable = @"usable";
NSString *const kTVStationOnplay = @"onplay";
NSString *const kTVStationChannelName = @"channelName";
NSString *const kTVStationUuid = @"uuid";
NSString *const kTVStationNo = @"no";
NSString *const kTVStationUrlid = @"urlid";
NSString *const kTVStationLogo = @"logo";


@interface TVStation ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation TVStation

@synthesize usable = _usable;
@synthesize onplay = _onplay;
@synthesize channelName = _channelName;
@synthesize uuid = _uuid;
@synthesize noProperty = _noProperty;
@synthesize urlid = _urlid;
@synthesize logo = _logo;


+ (TVStation *)modelObjectWithDictionary:(NSDictionary *)dict
{
    TVStation *instance = [[TVStation alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.usable = [[self objectOrNilForKey:kTVStationUsable fromDictionary:dict] doubleValue];
            self.onplay = [self objectOrNilForKey:kTVStationOnplay fromDictionary:dict];
            self.channelName = [self objectOrNilForKey:kTVStationChannelName fromDictionary:dict];
            self.uuid = [self objectOrNilForKey:kTVStationUuid fromDictionary:dict];
            self.noProperty = [self objectOrNilForKey:kTVStationNo fromDictionary:dict];
            self.urlid = [self objectOrNilForKey:kTVStationUrlid fromDictionary:dict];
            self.logo = [self objectOrNilForKey:kTVStationLogo fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.usable] forKey:kTVStationUsable];
    [mutableDict setValue:self.onplay forKey:kTVStationOnplay];
    [mutableDict setValue:self.channelName forKey:kTVStationChannelName];
    [mutableDict setValue:self.uuid forKey:kTVStationUuid];
    [mutableDict setValue:self.noProperty forKey:kTVStationNo];
    [mutableDict setValue:self.urlid forKey:kTVStationUrlid];
    [mutableDict setValue:self.logo forKey:kTVStationLogo];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.usable = [aDecoder decodeDoubleForKey:kTVStationUsable];
    self.onplay = [aDecoder decodeObjectForKey:kTVStationOnplay];
    self.channelName = [aDecoder decodeObjectForKey:kTVStationChannelName];
    self.uuid = [aDecoder decodeObjectForKey:kTVStationUuid];
    self.noProperty = [aDecoder decodeObjectForKey:kTVStationNo];
    self.urlid = [aDecoder decodeObjectForKey:kTVStationUrlid];
    self.logo = [aDecoder decodeObjectForKey:kTVStationLogo];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_usable forKey:kTVStationUsable];
    [aCoder encodeObject:_onplay forKey:kTVStationOnplay];
    [aCoder encodeObject:_channelName forKey:kTVStationChannelName];
    [aCoder encodeObject:_uuid forKey:kTVStationUuid];
    [aCoder encodeObject:_noProperty forKey:kTVStationNo];
    [aCoder encodeObject:_urlid forKey:kTVStationUrlid];
    [aCoder encodeObject:_logo forKey:kTVStationLogo];
}


@end
