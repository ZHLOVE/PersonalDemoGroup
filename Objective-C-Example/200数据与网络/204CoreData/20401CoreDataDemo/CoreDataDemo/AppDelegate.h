//
//  AppDelegate.h
//  CoreDataDemo
//
//  Created by niit on 16/4/14.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// 1. 托管对象上下文 (一个容器，存放托管对象)
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// 2. 托管对象模型 (数据库中所有表格和数据结构，定义了实体的属性结构及关系)
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

// 3. 持久存储 (相当于数据库的连接,设置了数据存储的具体位置及方式)
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

