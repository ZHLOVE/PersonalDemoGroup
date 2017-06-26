//
//  StudentModel.m
//  SaveData
//
//  Created by niit on 16/3/14.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "StudentModel.h"

@implementation StudentModel

#define kStuId @"StuId"
#define kStuName @"StuName"
#define kStuAge @"StuAge"

- (instancetype)initWithId:(NSString *)tmpStuId andName:(NSString *)tmpStuName andAge:(NSString *)tmpStuAge
{
    self = [super init];
    if (self) {
        self.stuId = tmpStuId;
        self.stuName = tmpStuName;
        self.stuAge = tmpStuAge;
    }
    return self;
}

#pragma mark - 归档解档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.stuId forKey:kStuId];
    [aCoder encodeObject:self.stuName forKey:kStuName];
    [aCoder encodeObject:self.stuAge forKey:kStuAge];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.stuId = [aDecoder decodeObjectForKey:kStuId];
        self.stuName = [aDecoder decodeObjectForKey:kStuName];
        self.stuAge = [aDecoder decodeObjectForKey:kStuAge];
    }
    return self;
}

#pragma mark -
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ %@",self.stuId,self.stuName,self.stuAge];
}

@end
