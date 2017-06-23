//
//  Student+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by niit on 16/4/14.
//  Copyright © 2016年 NIIT. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Student.h"

NS_ASSUME_NONNULL_BEGIN

@interface Student (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *stuId;
@property (nullable, nonatomic, retain) NSString *stuName;
@property (nullable, nonatomic, retain) NSNumber *stuAge;
@property (nullable, nonatomic, retain) NSString *stuClass;

@end

NS_ASSUME_NONNULL_END
