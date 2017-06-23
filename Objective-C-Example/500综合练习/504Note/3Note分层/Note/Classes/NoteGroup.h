//
//  NoteGroup.h
//  Note
//
//  Created by niit on 16/3/16.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NoteModel.h"

// 1. 定义一个类来管理数据,数据保存在该类中
// 2. 这个类提供单例模式,所有表示层的对象如果要操作数据,通过得到该类的单例对象来操作数据
// 3. 提供增删改查数据的方法,表示层对象通过这些方法操作数据

@interface NoteGroup : NSObject

@property (nonatomic,strong) NSMutableArray *noteList;

// 得到单例对象
+ (NoteGroup *)sharedNoteGroup;

// 增删改查
// 添加
- (void)addNoteWithTitle:(NSString *)title andContent:(NSString *)content;
// 编辑
- (void)modifyNote:(NoteModel *)n withTitle:(NSString *)title andContent:(NSString *)content;
// 移除
- (void)removeNoteByIndex:(NSUInteger)index;

- (NSMutableArray *)findAll;

// 保存数据
- (void)saveData;

@end
