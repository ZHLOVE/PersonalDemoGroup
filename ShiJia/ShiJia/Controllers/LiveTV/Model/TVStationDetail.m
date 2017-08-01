//
//  TVStationDetail.m
//
//  created by iSwift on 3/8/14
//  Copyright (c) 2014 . All rights reserved.
//

#import "TVStationDetail.h"
#import "TVProgram.h"
#import "TVDataProvider.h"
//#import <NSDate+Calendar.h>

NSString *const kTVStationDetailPrograms = @"programs";
NSString *const kTVStationDetailPlayDate = @"playDate";


@interface TVStationDetail ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation TVStationDetail

@synthesize programs = _programs;
@synthesize playDate = _playDate;


+ (TVStationDetail *)modelObjectWithDictionary:(NSDictionary *)dict
{
    TVStationDetail *instance = [[TVStationDetail alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        NSObject *receivedTVPrograms = [dict objectForKey:kTVStationDetailPrograms];
        NSMutableArray *parsedTVPrograms = [NSMutableArray array];
        if ([receivedTVPrograms isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedTVPrograms) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedTVPrograms addObject:[TVProgram modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedTVPrograms isKindOfClass:[NSDictionary class]]) {
            [parsedTVPrograms addObject:[TVProgram modelObjectWithDictionary:(NSDictionary *)receivedTVPrograms]];
        }
        [parsedTVPrograms sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"startTimeDouble" ascending:YES]]];
        self.programs = [NSArray arrayWithArray:parsedTVPrograms];
        self.playDate = [self objectOrNilForKey:kTVStationDetailPlayDate fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForPrograms = [NSMutableArray array];
    for (NSObject *subArrayObject in self.programs) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForPrograms addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForPrograms addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForPrograms] forKey:@"kTVStationDetailPrograms"];
    [mutableDict setValue:self.playDate forKey:kTVStationDetailPlayDate];
    
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
    
    self.programs = [aDecoder decodeObjectForKey:kTVStationDetailPrograms];
    self.playDate = [aDecoder decodeObjectForKey:kTVStationDetailPlayDate];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_programs forKey:kTVStationDetailPrograms];
    [aCoder encodeObject:_playDate forKey:kTVStationDetailPlayDate];
}

#pragma mark - public methods

- (TVProgram*) onlineProgram{
    for (TVProgram* program in self.programs) {
        if ([program.urlType isEqualToString:@"play"]) {
            return program;
        }
    }
    return nil;
}

- (NSString*)displayedDate{
    double serverTime = [self.playDate doubleValue];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:serverTime];
    NSDateFormatter* dateFormate = [[NSDateFormatter alloc] init];
    [dateFormate setDateFormat:@"MM-dd"];
    [dateFormate setLocale:[NSLocale currentLocale]];
    [dateFormate setTimeZone:[NSTimeZone defaultTimeZone]];
    return [dateFormate stringFromDate:date];
}
- (NSString*)displayedWeekDay{
    double serverTime = [self.playDate doubleValue];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:serverTime];
    
    NSInteger weekDay = [date weekday];
    if ([date day] == [[NSDate date] day]) {
        weekDay = 8;
    }
    return [HiTVConstants weekDayName:weekDay];
}

- (NSTimeInterval)playDateDouble{
    return [self.playDate doubleValue];
}

@end
