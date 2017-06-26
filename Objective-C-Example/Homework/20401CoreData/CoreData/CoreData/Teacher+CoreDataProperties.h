//
//  Teacher+CoreDataProperties.h
//  CoreData
//
//  Created by student on 16/4/14.
//  Copyright © 2016年 Five. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Teacher.h"

NS_ASSUME_NONNULL_BEGIN

@interface Teacher (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *department;
@property (nullable, nonatomic, retain) NSNumber *teacherID;

@end

NS_ASSUME_NONNULL_END
