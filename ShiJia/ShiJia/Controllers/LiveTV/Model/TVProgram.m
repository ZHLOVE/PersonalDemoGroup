//
//  TVPrograms.m
//
//  created by iSwift on 3/8/14
//  Copyright (c) 2014 . All rights reserved.
//

#import "TVProgram.h"
#import "TVDataProvider.h"
#import "CornerEntity.h"

NSString *const kTVProgramsDesImg = @"desImg";
NSString *const kTVProgramsDes = @"des";
NSString *const kTVProgramsEndTime = @"endTime";
NSString *const kTVProgramsProgramUrl = @"programUrl";
NSString *const kTVProgramsUrlType = @"urlType";
NSString *const kTVProgramsType = @"type";
NSString *const kTVProgramsProgramName = @"programName";
NSString *const kTVProgramsProgramId = @"programId";
NSString *const kTVProgramsStartTime = @"startTime";
//modify by jianghailiang 20150130
NSString *const kTVBoxProgramsProgramUrl = @"boxProgramUrl";
//modifyend

@interface TVProgram ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation TVProgram

@synthesize desImg = _desImg;
@synthesize des = _des;
@synthesize endTime = _endTime;
@synthesize programUrl = _programUrl;
@synthesize urlType = _urlType;
@synthesize type = _type;
@synthesize programName = _programName;
@synthesize programId = _programId;
@synthesize startTime = _startTime;
//modify by jianghailiang 20150130
@synthesize boxProgramUrl = _boxProgramUrl;
//modifyend

+ (TVProgram *)modelObjectWithDictionary:(NSDictionary *)dict
{
    TVProgram *instance = [[TVProgram alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.desImg = [self objectOrNilForKey:kTVProgramsDesImg fromDictionary:dict];
            self.des = [self objectOrNilForKey:kTVProgramsDes fromDictionary:dict];
            self.endTime = [self objectOrNilForKey:kTVProgramsEndTime fromDictionary:dict];
            self.programUrl = [self objectOrNilForKey:kTVProgramsProgramUrl fromDictionary:dict];
            self.urlType = [self objectOrNilForKey:kTVProgramsUrlType fromDictionary:dict];
            self.type = [self objectOrNilForKey:kTVProgramsType fromDictionary:dict];
            self.programName = [self objectOrNilForKey:kTVProgramsProgramName fromDictionary:dict];
            self.programId = [[self objectOrNilForKey:kTVProgramsProgramId fromDictionary:dict] doubleValue];
            self.startTime = [self objectOrNilForKey:kTVProgramsStartTime fromDictionary:dict];
            self.uuid = [self objectOrNilForKey:@"channelUuid" fromDictionary:dict];
            self.mediaType = [self objectOrNilForKey:@"mediaType" fromDictionary:dict];
        
        
            self.channelName = dict[@"channelName"];
            self.channelUuid = dict[@"channelUuid"];
            self.cur = dict[@"cur"];
            self.programMobileUrl = dict[@"programMobileUrl"];
        if (self.programUrl==nil||[self.programUrl isEqualToString:@""]) {
            self.programUrl = dict[@"programMobileUrl"];
        }
            self.seriesNum = dict[@"seriesNum"];
            self.ppvId  = [self objectOrNilForKey:@"ppvId" fromDictionary:dict];

        self.ppvList = dict[@"ppvList"];
        self.cornerArray = [NSMutableArray arrayWithArray:[self getCorners:dict[@"corner"]]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.desImg forKey:kTVProgramsDesImg];
    [mutableDict setValue:self.des forKey:kTVProgramsDes];
    [mutableDict setValue:self.endTime forKey:kTVProgramsEndTime];
    [mutableDict setValue:self.programUrl forKey:kTVProgramsProgramUrl];
    [mutableDict setValue:self.urlType forKey:kTVProgramsUrlType];
    [mutableDict setValue:self.type forKey:kTVProgramsType];
    [mutableDict setValue:self.programName forKey:kTVProgramsProgramName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.programId] forKey:kTVProgramsProgramId];
    [mutableDict setValue:self.startTime forKey:kTVProgramsStartTime];
    //modify by jianghailiang 20150130
    [mutableDict setValue:self.boxProgramUrl forKey:kTVBoxProgramsProgramUrl];
    [mutableDict setValue:self.seriesNum forKey:@"seriesNum"];
    //modifyend
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

    self.desImg = [aDecoder decodeObjectForKey:kTVProgramsDesImg];
    self.des = [aDecoder decodeObjectForKey:kTVProgramsDes];
    self.endTime = [aDecoder decodeObjectForKey:kTVProgramsEndTime];
    self.programUrl = [aDecoder decodeObjectForKey:kTVProgramsProgramUrl];
    self.urlType = [aDecoder decodeObjectForKey:kTVProgramsUrlType];
    self.type = [aDecoder decodeObjectForKey:kTVProgramsType];
    self.programName = [aDecoder decodeObjectForKey:kTVProgramsProgramName];
    self.programId = [aDecoder decodeDoubleForKey:kTVProgramsProgramId];
    self.startTime = [aDecoder decodeObjectForKey:kTVProgramsStartTime];
    //modify by jianghailiang 20150130
    self.boxProgramUrl = [aDecoder decodeObjectForKey:kTVBoxProgramsProgramUrl];
    self.seriesNum = [aDecoder decodeObjectForKey:@"seriesNum"];

    //modifyend
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_desImg forKey:kTVProgramsDesImg];
    [aCoder encodeObject:_des forKey:kTVProgramsDes];
    [aCoder encodeObject:_endTime forKey:kTVProgramsEndTime];
    [aCoder encodeObject:_programUrl forKey:kTVProgramsProgramUrl];
    [aCoder encodeObject:_urlType forKey:kTVProgramsUrlType];
    [aCoder encodeObject:_type forKey:kTVProgramsType];
    [aCoder encodeObject:_programName forKey:kTVProgramsProgramName];
    [aCoder encodeDouble:_programId forKey:kTVProgramsProgramId];
    [aCoder encodeObject:_startTime forKey:kTVProgramsStartTime];
    //modify by jianghailiang 20150130
    [aCoder encodeObject:_boxProgramUrl forKey:kTVBoxProgramsProgramUrl];
    //modifyend
    [aCoder encodeObject:_seriesNum forKey:@"seriesNum"];

}


- (NSString*)displayedStartTime{
    NSTimeInterval serverTime = [self.startTime doubleValue] - [TVDataProvider sharedInstance].serverTimeOffset;
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:serverTime];
    NSDateFormatter* dateFormate = [[NSDateFormatter alloc] init];
    [dateFormate setDateFormat:@"H:mm"];
    [dateFormate setLocale:[NSLocale currentLocale]];
    return [dateFormate stringFromDate:date];
}
- (NSString*)displayedEndTime{
    NSTimeInterval serverTime = [self.endTime doubleValue] - [TVDataProvider sharedInstance].serverTimeOffset;
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:serverTime];
    NSDateFormatter* dateFormate = [[NSDateFormatter alloc] init];
    [dateFormate setDateFormat:@"H:mm"];
    [dateFormate setLocale:[NSLocale currentLocale]];
    return [dateFormate stringFromDate:date];
}
- (NSString*)displayedFullStartTime{
    NSTimeInterval serverTime = [self.startTime doubleValue] - [TVDataProvider sharedInstance].serverTimeOffset;
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:serverTime];
    NSDateFormatter* dateFormate = [[NSDateFormatter alloc] init];
    [dateFormate setDateFormat:@"YYYY.MM.dd"];
    [dateFormate setLocale:[NSLocale currentLocale]];
    return [dateFormate stringFromDate:date];
}
- (NSTimeInterval)startTimeDouble{
    return [self.startTime doubleValue];
}

- (BOOL)canReplay{
    return [self.urlType isEqualToString:@"replay"];
}
- (BOOL)canPlay{
    return [self.urlType isEqualToString:@"play"];
}

- (NSArray*)getCorners:(id)responseObject{
    NSMutableArray* returnMenus = [[NSMutableArray alloc] init];
    for (NSDictionary* aMenu in responseObject) {
        [returnMenus addObject:[[CornerEntity alloc] initWithDict:aMenu]];
    }
    return returnMenus;
}
@end
